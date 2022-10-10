rm(list=ls())

# Load Libraries ----
library(tidyverse)
library(readxl)
library(here)

### Set Directory ----
here::i_am("sipri-dashboard.Rproj")

### Import Data ----
dfConstant <- read_excel(here::here("old-data", "sipri.xlsx"), sheet = 5, skip = 5)
dfCurrent <- read_excel(here::here("old-data", "sipri.xlsx"), sheet = 6, skip = 5)
dfGDP <- read_excel(here::here("old-data", "sipri.xlsx"), sheet = 7, skip = 5)
dfCapita <- read_excel(here::here("old-data", "sipri.xlsx"), sheet = 8, skip = 6)
dfGovernment <- read_excel(here::here("old-data", "sipri.xlsx"), sheet = 9, skip = 7)

# Data Wrangling ----

# Define Variables
subsetCountries <- c(
  "Africa",
  "North Africa",
  "sub-Saharan Africa",
  "Americas",
  "Central America and the Caribbean",
  "North America",
  "South America",
  "Asia & Oceania",
  "Oceania",
  "South Asia",
  "East Asia",
  "South East Asia",
  "Central Asia",
  "Europe",
  "Central Europe",
  "Eastern Europe",
  "Western Europe",
  "USSR",
  "Middle East",
  "Yemen, North",
  "German Democratic Republic"
)

# dfConstant ----
dfConstant <- dfConstant %>%
  distinct() %>%
  filter(!is.na(Country)) %>%
  subset(!(Country %in% subsetCountries)) %>%
  within(rm("...2", "Notes")) %>%
  pivot_longer(!Country, names_to="year", values_to="USD Constant") %>%
  mutate_at(c(2:3), as.numeric) %>%
  mutate(Country = case_when(
    Country == "United States of America" ~ "United States",
    Country == "Korea, South" ~ "South Korea",
    Country == "Korea, North" ~ "North Korea",
    Country == "Viet Nam" ~ "Vietnam",
    Country == "Congo, Republic" ~ "Republic of the Congo",
    Country == "Congo, DR" ~ "Democratic Republic of the Congo",
    TRUE ~ as.character(Country)
  )
)

dfConstant$`USD Constant` <- round((dfConstant$`USD Constant` * 1000000), 0)

# dfCurrent 
dfCurrent <- dfCurrent %>%
  distinct() %>%
  filter(!is.na(Country)) %>%
  subset(!(Country %in% subsetCountries)) %>%
  within(rm("Notes")) %>%
  pivot_longer(!Country, names_to="year", values_to="USD Current") %>%
  mutate_at(c(2:3), as.numeric) %>%
  mutate(Country = case_when(
    Country == "United States of America" ~ "United States",
    Country == "Korea, South" ~ "South Korea",
    Country == "Korea, North" ~ "North Korea",
    Country == "Viet Nam" ~ "Vietnam",
    Country == "Congo, Republic" ~ "Republic of the Congo",
    Country == "Congo, DR" ~ "Democratic Republic of the Congo",
    TRUE ~ as.character(Country)
  )
)

dfCurrent$`USD Current` <- round((dfCurrent$`USD Current` * 1000000), 0)

# dfGDP
dfGDP <- dfGDP %>%
  distinct() %>%
  filter(!is.na(Country)) %>%
  subset(!(Country %in% subsetCountries)) %>%
  within(rm("Notes")) %>%
  pivot_longer(!Country, names_to = "year", values_to = "GDP Percent") %>%
  mutate_at(c(2:3), as.numeric) %>%
  mutate(Country = case_when(
    Country == "United States of America" ~ "United States",
    Country == "Korea, South" ~ "South Korea",
    Country == "Korea, North" ~ "North Korea",
    Country == "Viet Nam" ~ "Vietnam",
    Country == "Congo, Republic" ~ "Republic of the Congo",
    Country == "Congo, DR" ~ "Democratic Republic of the Congo",
    TRUE ~ as.character(Country)
  )
)

dfGDP$`GDP Percent` <- round((dfGDP$`GDP Percent` * 100), 2)

# dfCapita 
dfCapita <- dfCapita %>%
  distinct() %>%
  filter(!is.na(Country)) %>%
  subset(!(Country %in% subsetCountries)) %>%
  within(rm("Notes")) %>%
  pivot_longer(!Country, names_to = "year", values_to = "Military Capita Spending") %>%
  mutate_at(c(2:3), as.numeric) %>%
  mutate(Country = case_when(
    Country == "United States of America" ~ "United States",
    Country == "Korea, South" ~ "South Korea",
    Country == "Korea, North" ~ "North Korea",
    Country == "Viet Nam" ~ "Vietnam",
    Country == "Congo, Republic" ~ "Republic of the Congo",
    Country == "Congo, DR" ~ "Democratic Republic of the Congo",
    TRUE ~ as.character(Country)
  )
)

dfCapita$`Military Capita Spending` <- round(dfCapita$`Military Capita Spending`, 0)

# dfGovernment
dfGovernment <- dfGovernment %>%
  distinct() %>%
  filter(!is.na(Country)) %>%
  subset(!(Country %in% subsetCountries)) %>%
  within(rm("Notes", "Reporting year")) %>%
  pivot_longer(!Country, names_to = "year", values_to = "Government Percent") %>%
  mutate_at(c(2:3), as.numeric) %>%
  mutate(Country = case_when(
    Country == "United States of America" ~ "United States",
    Country == "Korea, South" ~ "South Korea",
    Country == "Korea, North" ~ "North Korea",
    Country == "Viet Nam" ~ "Vietnam",
    Country == "Congo, Republic" ~ "Republic of the Congo",
    Country == "Congo, DR" ~ "Democratic Republic of the Congo",
    TRUE ~ as.character(Country)
  )
)

dfGovernment$`Government Percent` <- round((dfGovernment$`Government Percent` * 100), 2)

# Combine Datasets 
df <- print(list(dfConstant, dfCurrent, dfGDP, dfGovernment, dfCapita)) %>%
  reduce(left_join, by = c("Country", "year")) %>%
  pivot_longer(cols = c(-Country, -year), names_to = "metric", values_to = "amount")

# Save Datasets ----
write_csv(df, here::here("sipri-dashboard", "sipri-military-expenditure.csv"))
