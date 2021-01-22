# RUGs Interaction Puzzle 
# 21 Jan 2021 
# Calum Davey 
  
  library(multcomp) # (1)
  library(Epi)      # (2)
  library(emmeans)  # (3)

# Generate simple dataset with interaction 
# ========================================
  
  N <- 1000
  data2 <- data.frame(  
    f = rbinom(n = N, size=1, prob=0.5), # A factor exposure (e.g. treatment)
    x = rnorm(n = N, 10, 2),             # A continuous exposure (e.g. age)
    e = rnorm(n = N, 0, 5))              # Random error 
  
  # Set the model parameters 
  Alpha = 10
  Beta1 = .2
  Beta2 = 1.3
  Beta3 = 1.4 
  
  # Generate the dependent variable 
  data2$y = Alpha + Beta1*data2$f + Beta2*data2$x + Beta3*data2$f*data2$x + data2$e
  
  # Reclass f as factor
  data2$f <- as.factor(data2$f)
  
# Fit the model   
# =============
  
  model <- lm(y ~ f*x, data = data2) 
  summary(model) 
  
# Return the interaction
# ======================  
  
  # (1) Calum + Will + Saravanakumar 
    confint(multcomp::glht(model, linfct="x + f1:x = 0"))
    
  # (2) Antonio   
    model2 <- lm(y ~ x:f + f, data=data2)
    Epi::ci.lin(model2)
    
  # (3) Paul, https://stats.idre.ucla.edu/r/seminars/interactions-r/#s4a
    emmeans::emtrends(model, ~ f, var = "x")
    
  
    
