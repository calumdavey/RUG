## General resources 

(Julia) Just adding to chat some resources I'd really recommend for learning R, if you are within the RStudio + Tidyverse paradigm:

- https://r4ds.had.co.nz/
- https://rstudio.com/resources/cheatsheets/
- https://www.statlearning.com/ (not specific to Tidyverse, excellent as a practical open textbook walkthrough on various ML methods)
- https://otexts.com/fpp2/

(Julia) At some point I will probably compile the above into a running list on GitHub (like this one https://github.com/7j7j/lshtm-rd-resources), maybe we should set this up with RUsers group (https://github.com/lshtm-rug) and/or CHIL-R (LSHTM health economists') GitHub (https://github.com/LSHTM-CHIL)

There's also this R for Stata Users book but I have not used it myself: https://www.springer.com/gp/book/9781441913173

(Naomi) "writing R is like writing a paper, you wouldn't submit your first draft" [write the first draft in notes only, and then a rough version, and improve from there]

French book https://link.springer.com/book/10.1007/978-2-8178-0535-1

Interesting presentation from Jeroen Ooms on assessing the quality of open source projects in general and R packages in particular https://rstudio.com/resources/rstudioglobal-2021/monitoring-health-and-impact-of-open-source-projects/

For absolute beginners (not this group) SWIRL is useful https://swirlstats.com/ 

I also use this all the time - https://www.r-graph-gallery.com/ 

Good overview of packages in different domains - which I only just became aware of and wish I'd found earlier https://cran.r-project.org/web/views/

## Data wrangling 

(Julia) What I mean by data wrangling is how you go from relatively unstructured raw data to your specific analytical spine (https://en.wikipedia.org/wiki/Data_wrangling)

Other resources for this in R:
https://www.experfy.com/training/courses/data-wrangling-in-r (I used some of my PhD training funds for this) 

Alternatives that are probably good too:
- https://www.pluralsight.com/paths/data-wrangling-with-r
- http://uc-r.github.io/data_wrangling
- https://www.edx.org/course/data-science-wrangling
- https://www.udemy.com/course/learn-data-wrangling-with-r/

... and others exist


## Multiple imputation 

Rdocumentation.org in general is a great resource, e.g. for mice as Andrei is discussing: https://www.rdocumentation.org/packages/mice/versions/3.6.0/topics/mice

(Example of a vignette with mice: https://amices.org/mice/ -- great package for missing data multiple imputation in general)

## Community 

Also really recommend peer learning resources like R Ladies London: https://www.meetup.com/rladies-london/

and similarly across R/Python/Julia etc: https://www.meetup.com/London-Data-Science-ODSC/

Per Andrei's point, nice example of StackExchange thread: https://stats.stackexchange.com/questions/25025/how-to-build-a-linear-mixed-effects-model-in-r

Example NHS R conference: https://nhsrcommunity.com/events/nhs-r-virtual-conference-2020/

Also as a PhD student you can use the stats Helpdesk to get some input

Blogs, e.g. https://www.r-bloggers.com/

Naomi and Sam's great software chatter initiative: https://github.com/cmmid/SoftwareChatter 

another great resource is the Recon project (partly run by Thubaut Jombart) which focuses on R and epidemics: https://www.reconlearn.org/ (lots of cases studies and resources here)

## Loops 

(Julia) Oh man, I'm still quite bad at loops but some resources with vignette code where purrr and dplyr in Tidyverse are specifically meant for this quite often (where 'across' and 'apply' are lifesavers):
 https://bookdown.org/ansellbr/WEHI_tidyR_course_book/automating-your-work.html

https://datacarpentry.org/semester-biology/materials/for-loops-R/

https://dplyr.tidyverse.org/articles/programming.html

Working with new packages:

- Copy own function, add a break to see what it is doing 
- Use fake data 

- apply https://www.r-bloggers.com/2009/09/r-function-of-the-day-tapply-2/
- map https://www.rdocumentation.org/packages/purrr/versions/0.2.5/topics/map


## Other languages 
Reticulate is a package by RStudio to translate python to R: https://rstudio.github.io/reticulate/

https://dept.stat.lsa.umich.edu/~jerrick/courses/stat701/notes/sql.html SQL in R

## Plotting 
- lattice can also be very powerful. I particularly enjoy using “levelplot” for rasters
- If wanting to map you can use tmap which uses the same grammar of graphics approach as ggplot.

## Tables
- Xtable (latex) 
- https://cran.r-project.org/web/packages/tableone/vignettes/introduction.html
- https://rmarkdown.rstudio.com/