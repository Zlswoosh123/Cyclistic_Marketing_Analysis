library(tidyverse)
library(dplyr)
library(readr)
library(skimr)
library(lubridate)

path_data <- 'C:/Users/Zlswo/VsCode Projects/Google capstone/Data'

# Merging files into single df
df_all <- list.files(path=path_data) %>% 
  lapply(read_csv) %>% 
  bind_rows

# Adding ride_length and day_of_the_week columns. Day is based on start (uses lubridate)
df_all <- df_all %>%
  mutate(ride_length = ended_at - started_at) %>%
  mutate(day_of_the_week = wday(started_at, label=TRUE))
  

# Filters, removing 100 rows of ride_length < 0, 
df_all <- df_all %>%
  filter(ride_length >= 0)

df_working <- df_all %>%
  select(ride_id,rideable_type,
         member_casual,
         ride_length,
         day_of_the_week)

skim_without_charts(df_working)

# Shows # of rides per day of the week from each member group
df_days <- df_working %>%
  group_by(member_casual, day_of_the_week) %>%
  summarize(count_per_day = n())
View(df_days)

# Shows average ride length per rideable type per member type
df_ridetype <- df_working %>%
  group_by(member_casual, rideable_type) %>%
  summarize(average_ride_time = mean(ride_length))
View(df_ridetype)

df_longs <- df_working %>%
  filter(ride_length > 60000)
skim_without_charts(df_longs)
