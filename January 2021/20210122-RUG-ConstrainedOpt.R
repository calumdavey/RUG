###################################################
#
#  LSHTM R users group
#  Constrained optimization with R
#  Friday 22 January 2021
#
###################################################

#--------------------------------------
#  Part 1 - What is constrained optimization?
#--------------------------------------

#---- Optimization: find where is the minimum of a function

#- Function to be minimized: the minimum is 3
f <- function(x) (x - 3)^2 + 5
curve(f, from = -10, to = 10)

# We can use optimize to find this minimum
?optimize # performs 1D optimization

resmin <- optimize(f, interval = c(-100, 100))
resmin

points(resmin$minimum, resmin$objective, pch = 16, col = 4, cex = 2)

#- Adding a constraint that x < -5
rect(xleft = -5, ybottom = par("usr")[3], xright = par("usr")[2],
  ytop = par("usr")[4], density = 10, col = 2)

# Now let's otpimize with box constraint
rescons <- optimize(f, interval = c(-100, 100), upper = -5)
rescons

points(rescons$minimum, rescons$objective, pch = 16, col = 4, cex = 2)

#---- 2D optimization: Booth function takes 2 parameters
booth <- function(x1, x2) (x1 + 2*x2 - 7)^2 + (2*x1 + x2 - 5)^2

# To plot the function
xseq <- seq(-10, 10, length.out = 100)
y <- outer(xseq, xseq, booth)
image(xseq, xseq, y, xlab = "x1", ylab = "x2", breaks = 0:12 * 200)
contour(xseq, xseq, y, add = T, levels = 0:12 * 200)

#- Optimization with optim function
?optim

booth_vec <- function(x) booth(x[1], x[2])
resbooth <- optim(c(0, 0), fn = booth_vec)
resbooth

# Showing the minimum location
points(resbooth$par[1], resbooth$par[2], pch = 16, cex = 2)
text(resbooth$par[1], resbooth$par[2], 
  sprintf("(%1.1f,%1.1f)", resbooth$par[1], resbooth$par[2]),
  pos = 3, offset = 1)

#- Let's add linear constraints
# Those are constraints of the form u %*% x >= c
?constrOptim

# We want to find the min of the Booth function such that x1 + x2 <= 0
Cmat <- matrix(1, nrow = 1, ncol = 2)
Cmat
Cmat %*% c(1,3)
Cmat %*% c(-1, 2)
Cmat %*% c(1, -2)

ccontour <- outer(xseq, xseq, function(x, y) (cbind(x, y) %*% t(Cmat)) <= 0)
image(xseq, xseq, ccontour, col = adjustcolor(c(2, 3), .5), 
  breaks = c(-1, .5, 1), xlab = "x1", ylab = "x2")
contour(xseq, xseq, y, add = T, levels = 0:12 * 200)
points(resbooth$par[1], resbooth$par[2], pch = 16, cex = 2)

# Performing constrained optimization
constr_res <- constrOptim(c(-10, -10), f = booth_vec, grad = NULL, 
  ui = -Cmat, ci = 0)
constr_res

# Adding it to the plot
points(constr_res$par[1], constr_res$par[2], pch = 16, cex = 2)
text(constr_res$par[1], constr_res$par[2], 
  sprintf("(%1.1f,%1.1f)", constr_res$par[1], constr_res$par[2]),
  pos = 3, offset = 1)


#--------------------------------------
#  Part 2 - Where I talk about my work: constrained splines
#--------------------------------------

# Flexible way of doing nonlinear regression

#----- Let's simulate a function with data
set.seed(1)
x <- sort(c(runif(98, 0, 10), 0, 10))
y <- (x - 3)^2 + rnorm(100, 0, 10)

# Plot
plot(x, y, main = "Scatterplot of x and y", col = grey(0.7), pch = 19)
lines(x, (x - 3)^2, lty = 2, lwd = 2)

#----- What are splines ?
# Splines are polynomial bases applied to x
spline_mat <- dlnm::ps(x, int = T)
str(spline_mat)

# We now have 10 variables called bases
matplot(x, spline_mat, type = "l", ylab = "Spline bases")

# To approximate the function, these bases are used as new variables in a regression model
lmres <- lm(y ~ 0 + spline_mat)
coefs <- coef(lmres)

# I multiply each basis by its associated coefficient
coefmat <- mapply("*", as.data.frame(spline_mat), coefs)

matplot(x, coefmat, type = "l", ylab = "Spline basis * coef", ylim = range(coefs))
points(x[apply(spline_mat, 2, which.max)], coefs, type = "h", col = 1:6)
text(x[apply(spline_mat, 2, which.max)], coefs, round(coefs, 1), pos = 3, col = 1:6, xpd = T)

# Resulting curve: we add all bases * coef
lm_curve <- spline_mat %*% coefs
lines(x, lm_curve, lwd = 2)

# Let's compare to the true curve
plot(x, y, main = "Scatterplot of x and y", col = grey(0.7), pch = 19)
lines(x, (x-3)^2, lty = 2, lwd = 2)
lines(x, lm_curve, lwd = 2, col = 2)

#----- What does this have to do with optimization?

# Fitting a regression model is an optimization problem: minimizing least squares
# Let's define a least squares function
lsfun <- function(coefs) sum((y - spline_mat %*% coefs)^2)
# Optimization is easier with the gradient of the function
lsgr <- function(coefs) -2 * t(spline_mat) %*% y + 2 * crossprod(spline_mat) %*% coefs

# we can use this function in a general purpose optimizer
opt <- optim(rep(0, 10), fn = lsfun, gr = lsgr, method = "BFGS")

opt$par
coefs

opt_curve <- spline_mat %*% opt$par
lines(x, opt_curve, col = 4, lty = 2, lwd = 2)

#----- Constrained splines
# We want to fit a curve that is monotone increasing
# This mean that the spline coefficients must also increase (the beauty of B-splines)
# e.g. if we use coefs
ex_coef <- 1:10
ex_coefmat <- mapply("*", as.data.frame(spline_mat), ex_coef)
ex_curve <- spline_mat %*% ex_coef

# We plot these coefs with the resulting curve: we obtain a straight curve
matplot(x, ex_coefmat, type = "l", ylab = "Spline basis * coef", 
  ylim = range(ex_coef))
points(x[apply(spline_mat, 2, which.max)], ex_coef, type = "h", col = 1:6)
text(x[apply(spline_mat, 2, which.max)], ex_coef, round(ex_coef, 1), 
  pos = 3, col = 1:6, xpd = T)
lines(x, ex_curve, lwd = 2)

# Another example but with coefficient increasing quadraticaly
ex2_coef <- (1:10)^2
ex2_coefmat <- mapply("*", as.data.frame(spline_mat), ex2_coef)
ex2_curve <- spline_mat %*% ex2_coef

# We now obtain nice quadratic curve
matplot(x, ex2_coefmat, type = "l", ylab = "Spline basis * coef", 
  ylim = range(ex2_coef))
points(x[apply(spline_mat, 2, which.max)], ex2_coef, type = "h", col = 1:6)
text(x[apply(spline_mat, 2, which.max)], ex2_coef, round(ex2_coef, 1), 
  pos = 3, col = 1:6, xpd = T)
lines(x, ex2_curve, lwd = 2)

# To obtain an increasing curve we otpimize least-squares
# but with the constraint that the coefficients increase
# i.e. that the difference between successive coefficients is > 0
Cmat <- diff(diag(10))
Cmat # We have 9 constraints, one for each coefficient difference

# Now let's use constrOptim: we need starting value
# We'll use increasing values that are the closest to unconstrained ones
start <- predict(lm(opt$par ~ I(1:10)))

# Now we can use these starting values for optimization
copt <- constrOptim(start, f = lsfun, grad = lsgr, 
  ui = Cmat, ci = 0, method = "BFGS")
copt$par

copt_curve <- spline_mat %*% copt$par

plot(x, y, main = "Scatterplot of x and y", col = grey(0.7), pch = 19)
lines(x, (x-3)^2, lty = 2, lwd = 2)
lines(x, opt_curve, lwd = 2, col = 4)
lines(x, copt_curve, lwd = 2, col = 3)
legend("topleft", c("True", "Unconstrained", "optim"),
  lwd = 2, col = c(1, 4, 3), lty = c(2, 1, 1), bty = "n")

#----- Quadratic programming
# Since the objective function is quadratic, we can use that a Quadratic program
library(quadprog)
?solve.QP

# Here we need to rearrange our objective function
Dmat <- crossprod(spline_mat)
dvec <- t(y) %*% spline_mat

# We can use solve.QP to solve the optimization problem
# The good thing is that we don't need starting values
qpres <- solve.QP(Dmat, dvec, t(Cmat))

qpres

qpcurve <- spline_mat %*% qpres$solution

plot(x, y, main = "Scatterplot of x and y", col = grey(0.7), pch = 19)
lines(x, (x-3)^2, lty = 2, lwd = 2)
lines(x, opt_curve, lwd = 2, col = 4)
lines(x, copt_curve, lwd = 2, col = 3)
lines(x, qpcurve, lwd = 2, col = 7)
legend("topleft", c("True", "Unconstrained", "optim", "quadprog"),
  lwd = 2, col = c(1, 4, 3, 7), lty = c(2, 1, 1, 1), bty = "n")

#----- Convex curve
# The true curve is actually convex
# We can force our splines to be convex
# This means constraining the second differences
Cmat2 <- diff(diag(10), diff = 2)
Cmat2

# Now let's use it in the QP
qpres2 <- solve.QP(Dmat, dvec, t(Cmat2))

qpcurve2 <- spline_mat %*% qpres2$solution

plot(x, y, main = "Scatterplot of x and y", col = grey(0.7), pch = 19)
lines(x, (x-3)^2, lty = 2, lwd = 2)
lines(x, opt_curve, lwd = 2, col = 4)
lines(x, qpcurve2, lwd = 2, col = 6)
legend("topleft", c("True", "Unconstrained", "Convex"),
  lwd = 2, col = c(1, 4, 6), lty = c(2, 1, 1), bty = "n")



#################
# Some material
#################

#----- To understand the basic concepts: 
# Boyd, S., Vandenberghe, L., 2004. Convex Optimization, 1 edition. ed. Cambridge University Press, Cambridge, UK; New York.

#----- For details about the different optimization algorithms: 
# Nocedal, J., Wright, S., 2006. Numerical Optimization. Springer Science & Business Media.

# CRAN task view on optimization: https://cran.r-project.org/web/views/Optimization.html

#----- Some useful functions for specific applications
# Linear objective functions (linear programming): lpSolve
# Quadratic objective functions (quadratic programming): quadprog
# Non-linear least-squares: nls/nls2
# Stochastic optimization useful for non-convex problems: GA