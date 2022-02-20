# Header ------------------------------------------------------------------
# DSCI 353 - Data Management, Cleaning and Imputation
# Final Project
# Nicholas Johnson and Samuel Rasely


# 1 Introduction ----------------------------------------------------------
# 1.1 Provide an introduction that explains the problem statement you are addressing. Why should I be interested in this? 

# 1.2 Provide a short explanation of how you plan to address this problem statement (the data used and the methodology employed) 

# 1.3 Discuss your current proposed approach/analytic technique you think will address (fully or partially) this problem. 

# 1.4 Explain how your analysis will help the consumer of your analysis.



# 2 Packages Required ---------------------------------------------------
# 2.1 All packages used are loaded upfront so the reader knows which are required to replicate the analysis.
install.packages("tidyverse")
install.packages("readr")
install.packages("here") 
install.packages("dplyr")
install.packages("usmap") 
install.packages("ggplot2")

# 2.2 Messages and warnings resulting from loading the package are suppressed.
## quietly = T will suppress warning and messages

# 2.3 Explanation is provided regarding the purpose of each package
library(tidyverse, quietly = T) # TODO: here initially, break out into needed later and add descriptions why you have each
library(readr, quietly = T) # import csv in a more feature rich way
library(here, quietly = T) # The here package creates paths relative to the top-level directory, better for sharing code for collaboration
library(dplyr) # for data/dataframe manipulation
library(usmap) # US map plots
library(ggplot2) # data visualization

here::i_am("Final.Rproj")
here() # set current directory to top-level of project 

# 3 Data Preparation ------------------------------------------------------
# 3.1 Original source where the data was obtained is cited

# 3.2 Source data is thoroughly explained
#     what was the original purpose of the data, when was it collected, 
#     how many variables did the original have, 
#     explain any peculiarities of the source data such as how missing values are recorded, or how data was imputed

# 3.3 Data importing and cleaning steps are explained in the text 
#     (tell me why you are doing the data cleaning activities that you perform) and follow a logical process.
dog_adoptable_variable_table <- read_csv("dog_adoptable_variable_table.csv")
dog_descriptions_variable_table <- read_csv("dog_descriptions_variable_table.csv")
dog_destination_variable_table <- read_csv("dog_destination_variable_table.csv")


# load dog_adoptable
dog_adoptable <- read_csv("data/raw/dog_adoptable.csv")
# update field inUS to snake_case in_us
dog_adoptable <- rename(dog_adoptable, in_us = inUS)
# filter to just true for in_us
dog_adoptable <- filter(dog_adoptable, in_us == TRUE)
# drop field in_us as all records have same value
dog_adoptable <- select(dog_adoptable, !in_us)
# replace all NA with 0
dog_adoptable <- mutate_all(dog_adoptable, ~replace(., is.na(.), 0))
# rename location to state
dog_adoptable <- rename(dog_adoptable, state = location)

# save as processed
write.csv(dog_descriptions,"data/processed/dog_adoptable.csv", row.names = FALSE)


# dog_descriptions
dog_descriptions <- read_csv("data/raw/dog_descriptions.csv") 
#TODO: One or more parsing issues, see `problems()` for details
# problem may be from some having commas in values like with id 41330726

# drop stateQ as is only "The state abbreviation queried in the API to return this result " 
dog_descriptions <- select(dog_descriptions, !stateQ)
# drop status field as all are dogs adoptable
dog_descriptions <- select(dog_descriptions, !status)
# drop species field as all are dogs so adds no value.
dog_descriptions <- select(dog_descriptions, !species)
# drop type field as all are dogs so adds no value.3 are NA but confirmed they are dogs with their description
dog_descriptions <- select(dog_descriptions, !type)
# drop photo as all are NA
dog_descriptions <- select(dog_descriptions, !photo)
# drop name as useless
dog_descriptions <- select(dog_descriptions, !name)
# drop tags as useless
dog_descriptions <- select(dog_descriptions, !tags)
# drop declawed as all are NA
dog_descriptions <- select(dog_descriptions, !declawed)
# drop contact_country as all are in the US, some have state or zip here by error
dog_descriptions <- filter(dog_descriptions, contact_country == "US")
dog_descriptions <- select(dog_descriptions, !contact_country)

# TODO: handle city and state names in datetime field. do we need this at all? 
# TODO:  Shows us how long they have been in for. Perhaps derive days_available from accessed - posted. dogs there longer are less desireable
dog_descriptions <- mutate(dog_descriptions, posted_date = as.Date(posted))
dog_descriptions <- mutate(dog_descriptions, accessed_date = as.Date(accessed, "%d/%m/%Y"))
dog_descriptions <- mutate(dog_descriptions, days_in_shelter = 
                             as.numeric(difftime(dog_descriptions$accessed_date, 
                                                 dog_descriptions$posted_date , units = c("days"))))
dog_descriptions <- select(dog_descriptions, !c(posted, posted_date, accessed, accessed_date))


# Question: should we convert description to description_length or just drop it?
dog_descriptions <- select(dog_descriptions, !description)

# Question: drop contact_city and contact_zip ? Are we doing anything lower than the state level?


# fix zip na, all are in Boston 02108
dog_descriptions <- mutate_at(dog_descriptions, vars("contact_zip"), ~replace(., is.na(.), 02108))
# TODO: why is this not padding zip with 0s?
dog_descriptions <- mutate(dog_descriptions,
          zip = str_pad(string = contact_zip,
                              width = 5,
                              side = "left",
                              pad = "0"))
#rename to city state and zip
dog_descriptions <- select(dog_descriptions, !contact_zip)
dog_descriptions <- rename(dog_descriptions, city = contact_city)
dog_descriptions <- rename(dog_descriptions, state = contact_state)

# state abbreviation to full names
state.abb.and.name <- tibble(state.abb, state.name)
# TODO: what's wrong with this join
dog_descriptions <- left_join(dog_descriptions, state.abb.and.name, by = c("state" = "state.abb"))
# TODO: once joined, drop state and rename state.name to state

# save as processed
write.csv(dog_descriptions,"data/processed/dog_descriptions.csv", row.names = FALSE)


# dog_destination
dog_destination <- read_csv("data/raw/dog_destination.csv") 
# save as processed
write.csv(dog_descriptions,"data/processed/dog_destination.csv", row.names = FALSE)


# TODO: outliers, errors, and NAs for all three tables

# dog_adoptable
# While there are outliers in exported, imported and total, I found them all to be believable numbers.

# dog_destination (removed)

# dog_descriptions

# breed_secondary
dog_descriptions$breed_secondary[is.na(dog_descriptions$breed_secondary)] <- "NONE / UNKNOWN"

# color_primary
dog_descriptions$color_primary[is.na(dog_descriptions$color_primary)] <- "OTHER"

# color_secondary
dog_descriptions$color_secondary[is.na(dog_descriptions$color_secondary)] <- "NONE / OTHER"

# color_tertiary
dog_descriptions$color_tertiary[is.na(dog_descriptions$color_tertiary)] <- "NONE / OTHER"

# coat
dog_descriptions$coat[is.na(dog_descriptions$coat)] <- "OTHER"

# 3.4 Once your data is clean, show what the final data set looks like. 
#     However, do not print off a data frame with 200+ rows; show me the data in the most condensed form possible.
# condensed form?
head(dog_descriptions, 20)
head(dog_adoptable, 20)

# 3.5 Provide summary information about the variables of concern in your cleaned data set. 
#     Do not just print off a bunch of code chunks with str(), summary(), etc. 
#     Rather, provide me with a consolidated explanation, 
#     either with a table that provides summary info for each variable or a nicely written summary paragraph with inline code.


# 4 Exploratory Data Analysis ---------------------------------------------

# Dog Availability Per State
plot_usmap(data = dog_adoptable, values = "total", color = "red") + 
  scale_fill_continuous(name = "Dogs Adoptable", label = scales::comma) + 
  theme(legend.position = "right")

# TODO: table of most popular dog per state, frequency and percent within that state
# use datatable() like air bnb example 

# 4.1 Uncover new information in the data that is not self-evident, do not just plot the data as it is; 
#     rather, slice and dice the data in different ways, create new variables, 
#     or join separate data frames to create new summary information).

# 4.2 Provide findings in the form of plots and tables. Show me you can display findings in different ways.

# 4.3 Graph(s) are carefully tuned for desired purpose. 
#     One graph illustrates one primary point and is appropriately formatted 
#     (plot and axis titles, legend if necessary, scales are appropriate, appropriate geoms used, etc.).

# 4.4 Table(s) carefully constructed to make it easy to perform important comparisons. 
#     Careful styling highlights important features. Size of table is appropriate.

# 4.5 Insights obtained from the analysis are thoroughly, yet succinctly, explained. 
#     Easy to see and understand the interesting findings that you uncovered.


# 6 Summary ---------------------------------------------------------------
# 6.1 Summarize the problem statement you addressed. 

# 6.2 Summarize how you addressed this problem statement (the data used and the methodology employed). 

# 6.3 Summarize the interesting insights that your analysis provided. 

# 6.4 Summarize the implications to the consumer of your analysis. 

# 6.5 Discuss the limitations of your analysis and how you, or someone else, could improve or build on it.


# 7 Formatting & Other Requirements ---------------------------------------
# 7.1 Proper coding style is followed and code is well commented (see section regarding style).
# 7.2 Coding is systematic - complicated problem broken down into sub-problems 
#     that are individually much simpler. Code is efficient, correct, and minimal. 
#     Code uses appropriate data structure (list, data frame, vector/matrix/array). 
#     Code checks for common errors.
# 7.3 Achievement, mastery, cleverness, creativity: 
#     Tools and techniques from the course are applied very competently and, perhaps,somewhat creatively. 
#     Perhaps student has gone beyond what was expected and required,
#     e.g., extraordinary effort, additional tools not addressed by this course, 
#     unusually sophisticated application of tools from course.
# 7.4 .Rmd fully executes without any errors and HTML produced matches the HTML report submitted by student.