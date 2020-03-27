
hour_day <- read_dta("~/PhD work/DrinkLess app/16th April data all of it/hour_day.dta")
View(hour_day)

setwd("C:/Users/lsh1703883/Documents/PhD work/DrinkLess app/16th April data all of it/gganimate")

install.packages("tidyverse")
library(gganimate)

p <- ggplot(
  hour_day,
  aes(x= hour, y= n, colour=factor(sincedownload_cat))
) +
  geom_line() +
  scale_color_viridis_d() +   
  labs(title= 'Number of Session from Day 1 to Day 30', x = " Hour", y = "Number of sessions") +
 theme(legend.position="top") + geom_point()  + transition_reveal(sincedownload_cat)

 final_animation<-animate(p,100,fps = 20,duration = 30, width = 950, height = 750, renderer = gifski_renderer())

anim_save("./Days_hours.gif",animation=final_animation)


View(gapminder)



library(gapminder)

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')