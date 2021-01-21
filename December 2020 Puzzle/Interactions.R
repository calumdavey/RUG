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
  Beta3 = 1.3
  Beta4 = 1.4 
  
  # Generate the dependent variable 
  data2$y = Alpha + Beta1*data2$f + Beta2*data2$x + Beta3*data2$f*data2$x + data2$e
  
# Fit the model   
# =============
  
  model <- lm(y ~ f*x, data = data2) 
  summary(model) 
  
# Return the interaction
# ======================  
  
  # (1) Calum + Will + Saravanakumar 
    confint(multcomp::glht(model, linfct="f + f:x = 1"))
    
  # (2) Antonio   
    model2 <- lm(y ~ x:f + f)
    Epi::ci.lin(model2)
    
  # (3) Paul, https://stats.idre.ucla.edu/r/seminars/interactions-r/#s4a
    emmeans::emmeans(model, ~ x*f)
    emmeans::emmip(model,  x ~  f)
  
  
  # # plotting this (bar plot)
  #   geo_day_dat1 <- as.data.frame(emmeans::emmeans(covid.mod1, ~ mid_day_group*geo_region_factor))
  # 
  #   library(ggplot2)
  #   ggplot(data= geo_day_dat1, aes(x=geo_region_factor,y=emmean, fill=mid_day_group)) +
  #   geom_bar(stat="identity",position="dodge") +
  #   geom_errorbar(position=position_dodge(.9),width=.25, aes(ymax=upper.CL, ymin=lower.CL),alpha=0.3) +
  #   geom_text(aes(label=sprintf("%0.2f", round(emmean, digits = 2))), position=position_dodge(width=0.9), vjust=-0.5,size=3.5) +
  #   labs(x="Geographic region", y="Rt Mean", fill="Mid day",
  #        title = "Rt Mean predictions for combinations of Mid day and Region
  #               \n (Unadjusted plot)") +
  #   coord_cartesian(ylim = c(0.9, 1.5) )
 
    
