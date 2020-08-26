library(ggplot2)

library(rayshader)

library(viridis)

setwd("C:/Users/lsh1703883/Documents/PhD work/DrinkLess app/16th April data all of it")
getwd()

# heatmap of when session starts 

library(haven)
session_start_heatmap <- read_dta("session start heatmap.dta")
View(session_start_heatmap)

session_start_heatmap$day <- factor(session_start_heatmap$day,
                    levels = c(1,2,3,4,5,6,0),
                    labels = c( "Mon", "Tues","Wed","Thur","Fri","Sat","Sun"))

names(session_start_heatmap)[4] <- "sessions"

ggplot(session_start_heatmap) + 
  geom_tile(aes(x=day, y=hour, fill=n, color=n),size=1,color="black") +
  ggtitle("Heatmap of when sessions begin") +
  scale_fill_gradient2(low="white", high="black", guide="colorbar") +
  labs(caption = "May 2017 to Jan 2019, excluding 21st August 2018") +
  theme(axis.text = element_text(size = 12),
        title = element_text(size = 12,face="bold"),
        panel.border= element_rect(size=2,color="black",fill=NA))  ->
  session_gg


#filename_movie = tempfile()

phivechalf = 30 + 60 * 1/(1 + exp(seq(-7, 20, length.out = 180)/2))
phivecfull = c(phivechalf, rev(phivechalf))
thetavec =  60 * sin(seq(0,359,length.out = 360) * pi/180)
zoomvec = 0.45 + 0.2 * 1/(1 + exp(seq(-5, 20, length.out = 180)))
zoomvecfull = c(zoomvec, rev(zoomvec))


plot_gg(session_gg, multicore = TRUE, width = 6, height = 5.5, scale = 300, 
        background = "#afceff",shadowcolor = "#3a4f70")

render_movie(filename =  "session_graph.mp4", type = "custom", 
             frames = 360,  phi = phivecfull, zoom = zoomvecfull, theta = thetavec)