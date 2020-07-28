
# Make some simple date to play with 
d <- data.frame(sdate = c("2019-12-20", "2018-12-20"))
d$date <- as.Date(d$sdate, format = "%Y-%m-%d")
head(d)
class(d$date)
class(d$sdate)

# Obviously this won't work 
d$datebefore <- ifelse(d$date >= "2019-12-19", d$date, "2019-12-19")
head(d)
class(d$datebefore)
class(as.Date("2019-12-19", format = "%Y-%m-%d"))

# This doesn't work 
d$datebefore <- ifelse(d$date >= as.Date("2019-12-19"), 
                       d$date, 
                       as.Date("2019-12-19"))
head(d)
class(d$datebefore)

# Using if_else in dplyr 
library(dplyr)
d$datebefore <- if_else(d$date >= as.Date("2019-12-19"), 
                       d$date, 
                       as.Date("2019-12-19"))
head(d)
class(d$datebefore)

