
#----------------------#
# GGplot show and tell #
#----------------------#  

require(tidyverse)
require(broom)
require(ggforce)

#------#
# Data #
#------#  

set.seed(123)

df1 <- data.frame( weight = rnorm(500),
            sex = runif(500)>0.5,
            SES = rnorm(500),
            yob = sample(1:10, 500, replace = TRUE),
            trt1 = runif(500)>0.7,
            trt2 = runif(500)>0.2,
            trt3 = runif(500)>0.9,
            pa = runif(500)>0.5,
            staph = runif(500)>0.4)


df1$y <- with(df1, 0.3*weight + 0.5*sex - 0.2*SES + 
                0.1*yob + 0.01*trt1 + 0.8*trt2 - 0.4*trt3 -0.5*pa +  rnorm(500, sd = 0.7) )

#-------------------------------#
# Model + point estimates + CI  #
#-------------------------------#  

mod1 <- lm(y ~ weight + sex + SES + yob + trt1 + trt2 + trt3 + pa + staph, data = df1)

# Pt estimates + confidence intervals

coefs <- tidy(mod1, conf.int = TRUE)
coefs <- subset(coefs, term!="(Intercept)") # remove intercept

# Add nicer names

coefs$names <- c( "Weight (kg)", "Sex = FEMALE", 
                 "SES (IMD z-score)", "Year of birth (unit = 1 year)", 
                 "Treatment A", "Treatment B", "Treatment C",
                 "Bronchitis", "Pneumonia")

# Group the variables 

coefs$type = c("Weight at age 1 year",
               rep("Demographics", 3),
               rep("Clinical", 3),
               rep("Infections", 2))


# Gather point estimates and CIs

coefs$display_ests <-sprintf("%.2f [%.2f, %.2f]" , coefs$estimate, coefs$conf.low, coefs$conf.high)

#-------------------#
# Plot 1: no groups #
#-------------------#  



ggplot( coefs, aes(estimate, names )) + 
  geom_point(aes())+ 
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0, size = 0.5)+
  geom_text(aes(x = Inf, label = display_ests), vjust = -0.5, colour = "black", hjust = -0.1, size = 3.5) +
  coord_cartesian(clip = "off") +
  geom_vline(xintercept = 0, linetype = 2)+
  theme_bw(base_size = 12)+
  theme(plot.margin = unit(c(0,4,0,0), "cm")) +
  labs(x =  "Lung function (FEV1%)",y = NULL, title = NULL)+  
  facet_col(~type, scale = "free_y", space = "free")  


#------------------------#
# Plot 2: order by group #
#------------------------#  


coefs$type <- factor(coefs$type, ordered = TRUE, levels = c("Weight at age 1 year", "Demographics", "Clinical", "Infections"))
coefs <- coefs[ order(coefs$type, coefs$estimate), ]
coefs$names <- factor( coefs$names, ordered = TRUE, levels = rev(coefs$names) )


ggplot( coefs, aes(estimate, names )) + 
  geom_point()+ 
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0, size = 0.5)+
  geom_text(aes(x = Inf, label = display_ests), vjust = -0.5, colour = "black", hjust = -0.1, size = 3.5) +
  coord_cartesian(clip = "off") +
  geom_vline(xintercept = 0, linetype = 2)+
  theme_bw(base_size = 12)+
  theme(plot.margin = unit(c(0,4,0,0), "cm")) +
  theme(axis.title.x = element_text(face = "bold", size = 15)) +
  labs(x =  "Lung function (FEV1%)",y = NULL, title = NULL)+  
  facet_col(~type, scale = "free_y", space = "free")  


#-----------------------------#
# Plot 3: Colour by std error #
#-----------------------------#  

ggplot( coefs, aes(estimate, names )) + 
  geom_point(aes( colour = 1/std.error))+ 
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high, colour = 1/std.error), height = 0, size = 0.5)+
  geom_text(aes(x = Inf, label = display_ests), vjust = -0.5, colour = "black", hjust = -0.1, size = 3.5) +
  coord_cartesian(clip = "off") +
  geom_vline(xintercept = 0, linetype = 2)+
  theme_bw(base_size = 12)+
  theme(plot.margin = unit(c(0,4,0,0), "cm")) +
  theme(axis.title.x = element_text(face = "bold", size = 15)) +
  labs(x =  "Lung function (FEV1%)",y = NULL, title = NULL)+  
  facet_col(~type, scale = "free_y", space = "free")  +
  scale_colour_gradient(low = "grey60", high = "black") + 
  theme(legend.position = "none")

