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

# 2.2 Messages and warnings resulting from loading the package are suppressed.
## quietly = T will suppress warning and messages

# 2.3 Explanation is provided regarding the purpose of each package
library(tidyverse, quietly = T) # TODO: here initially, break out into needed later and add descriptions why you have each
library(readr, quietly = T) # import csv in a more feature rich way
library(here, quietly = T) # The here package creates paths relative to the top-level directory, better for sharing code for collaboration

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

# dog_adoptable
dog_adoptable <- read_csv("data/raw/dog_adoptable.csv")
View(dog_adoptable)
# TODO: update field inUS to snake_case in_us
# TODO: filter to just true for in_us
# TODO: drop field in_us as all records have same value


# dog_descriptions
dog_descriptions <- read_csv("data/raw/dog_descriptions.csv") 
#TODO: One or more parsing issues, see `problems()` for details
# problem may be from some having commas in values like with id 41330726
View(dog_descriptions)
# TODO:  update field stateQ to snake_case state_q
table(dog_descriptions$species)
# TODO:  drop type field as all are dogs so adds no value.
table(dog_descriptions$type)
# TODO:  drop type field as all are dogs so adds no value. 3 are NA but confirmed they are dogs with their description
table(dog_descriptions$photo)
# drop as all are NA
table(dog_descriptions$declawed)
# TODO:  drop as all are NA
table(dog_descriptions$contact_country)
# TODO:  drop type field contact_country as all are in the US, some have state or zip here by error
table(dog_descriptions$posted)
# TODO: handle city and state names in datetime field. do we need this at all? 
# TODO:  Shows us how long they have been in for. Perhaps derive days_available from accessed - posted. dogs there longer are less desireable
table(dog_descriptions$accessed)
# TODO:  drop type field accessed as all are 20/9/2019 or NA
# TODO: convert state abbreviated name to full state name (need to find a key-value)

# Question: should we convert description to description_length or just drop it?
# Question: drop contact_city and contact_zip ? Are we doing anything lower than the state level?


# dog_destination
dog_destination <- read_csv("data/raw/dog_destination.csv") 
View(dog_descriptions)

# TODO: outliers and errors for all three tables


# 3.4 Once your data is clean, show what the final data set looks like. 
#     However, do not print off a data frame with 200+ rows; show me the data in the most condensed form possible.

# 3.5 Provide summary information about the variables of concern in your cleaned data set. 
#     Do not just print off a bunch of code chunks with str(), summary(), etc. 
#     Rather, provide me with a consolidated explanation, 
#     either with a table that provides summary info for each variable or a nicely written summary paragraph with inline code.


# 4 Exploratory Data Analysis ---------------------------------------------
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