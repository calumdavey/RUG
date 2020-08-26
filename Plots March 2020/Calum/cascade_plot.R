# HIV treatment serrated cascade plot 
# Calum Daveu
# LSHTM 
# 26 MAR 2020

# Change working directory 
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read the data 
  d <- read.csv('data.csv')

# Set some arbitrary x-values
  xs <- c(0.01,.1,0.01,.1,.11,.2,.11,.2,.21,.3,.21,.3,.31,.4,.31,.4)

# Set values for the point types 
  pt <- rep(c(1,19),each=2,times=nrow(d)/4)

# Create the plot and the points 
  plot(xs, d$p, 
       ylim=c(0,1), xlim=c(0.01,.4), yaxt="n", xaxt="n", pch=pt, bty="n",
       xlab="", ylab="Means of RDS-adjusted proportions in all women", cex.lab=.7)

# Add the sloping lines 
  for (r in c(1,3,5,7,9,11,13,15)){
    lines(xs[r:(r+1)], d$p[r:(r+1)], type="l", lwd=1.7)
  }

#  Add the vertical lines
  for (r in c(1:16)){
    lines(c(xs[r],xs[r]),c(0,d$p[r]), lwd=.7)
  }

# Add horizontal line at bottom
lines(c(0.01,.4), c(0,0))

# Add the 90:90:90 lines
  base_hiv <- mean(d[d$outcome=='HIV' & d$year==2013,'p'])
  nnn <- c(base_hiv*.9,       # First 90 for diagnosis 
           base_hiv*.9*.9,    # Second 90 for treatment  
           base_hiv*.9*.9*.9) # Third 90 for suppression 
  
  lines(c(.11,.2), c(nnn[1],nnn[1]), lty=5, lwd=.7)
  lines(c(.21,.3), c(nnn[2],nnn[2]), lty=5, lwd=.7)
  lines(c(.31,.4), c(nnn[3],nnn[3]), lty=5, lwd=.7)
  
  text(.2-.01,nnn[1]+.02,labels="90%", cex=.7)
  text(.3-.01,nnn[2]+.02,labels="81%", cex=.7)
  text(.4-.01,nnn[3]+.02,labels="73%", cex=.7)

# Add the dates 
  lines(c(xs[1],xs[1]),c(d$p[1],d$p[1]+.08), lty=3, lwd=.7)
  lines(c(xs[2],xs[2]),c(d$p[2],d$p[2]+.08), lty=3, lwd=.7)
  
  text(xs[1]+0.0125,d$p[1]+.1,labels="2013", cex=.6)
  text(xs[2]+0.0125,d$p[2]+.1,labels="2016", cex=.6)

# Add axes and labels
  ap <- c(0,.2,.4,.6,.8,1)
  axis(2, at=ap, lab=paste0(ap * 100, "%"), las=TRUE, cex.axis=0.7)
  
  text(c(.05, .15, .25, .35, .55,.65),c(-.0193), 
       labels=c("HIV +ve", "Know +ve", "On ART", "vl<1000c/ml"), cex=.7)

# Add legend
  legend(0,.9,c("Sisters only arm", "Enhanced Sisters arm"),pch=c(1,19), bty="n", cex=.7)

# Add title
  mytitle = "HIV-treatment cascade across 14 sites in Zimbabwe"
  mysubtitle = "Change between baseline and endline in each arm of SAPPH-IRe trial"
  mtext(side=3, line=2, at=-0.07, adj=0, cex=1, mytitle)
  mtext(side=3, line=1, at=-0.07, adj=0, cex=0.7, mysubtitle)