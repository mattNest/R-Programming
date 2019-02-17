# lists in R

# Project Brief:
# You have been engaged as a Data Science consultant by a coal terminal. They would
# like you to investigate one of their heavy machines - RL1
# You have been supplied one month worth of data for all of their machines. The
# dataset shows what percentage of capacity for each machine was idle (unused) in any
# given hour. You are required to deliver an R list with the following components:
# Character: Machine name
# Vector: (min, mean, max) utilisation for the month (excluding unknown hours)
# Logical: Has utilisation ever fallen below 90%? TRUE / FALSE
# Vector: All hours where utilisation is unknown (NA’s)
# Dataframe: For this machine
# Plot: For all machines

getwd()
setwd("/Users/Matthew/Desktop/Advanced R programming A-Z/")
util <- read.csv("Machine-Utilization.csv")
head(util,12)
str(util)
summary(util)


# Derive Utilization Column
util$Utilization <- 1 - util$Percent.Idle

# Handling Date-Times in R
?POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp, format="%d/%m/%Y %H:%M")
head(util,12)
summary(util)

# TIP: How to rearrange cols in a df?
util$Timestamp <- NULL
head(util)
util <- util[,c(4,1,2,3)] # 照4,1,2,3的順序
head(util,12)


# What is a list
summary(util)
RL1 <- util[util$Machine == "RL1",] # subsetting RL1
summary(RL1)
RL1$Machine <- factor(RL1$Machine) # rerun the factor (optional step)
summary(RL1)


# Construct the list
# Character: Machine name
# Vector: (min, mean, max) utilisation for the month (excluding unknown hours)
# Logical: Has utilisation ever fallen below 90%? TRUE / FALSE

util_stats_rl1 <- c(min(RL1$Utilization, na.rm = TRUE),
                    median(RL1$Utilization, na.rm = TRUE),
                    max(RL1$Utilization, na.rm = TRUE))

util_under90_flag <- length(which(util$Utilization < 0.90)) > 0
util_under90_flag # logical operator

util_list <- list("RL1", util_stats_rl1, util_under90_flag)
util_list


# Naming the components
names(util_list) # NULL
names(util_list) <- c("Machine Name", "Stats", "LowerThreshold")
names(util_list)


# Another Way. Like with Dataframes
rm(util_list)
util_list <- list(Machine="RL1", Stats=util_stats_rl1, LowThreshold=util_under90_flag) # assign the name when creating the list
util_list


# Extracting components of a list
# three ways:
# 1. []: will always return a list
# 2. [[]]: will always return the actual object
# 3. $: same as [[]] buy prettier

util_list[2]
typeof(util_list[2]) # list
util_list[[2]]
typeof(util_list[[2]]) # double
util_list$Stats
typeof(util_list$Stats) # double

util_list$Stats[3]


# Adding and Deleting list components
util_list
util_list[4] <- "New Information"
util_list
names(util_list)[4] <- "Random"

# Another way to add a component: via the $
util_list$UnknownHours <- RL1[is.na(RL1$Utilization),"PosixTime"]


# Remove a component: Use the NULL method
util_list[4] <- NULL
util_list

# Notice: The numeration is SHIFTED
# util_list[4] is now the UnknownHours

# Add anothe component
# Dataframe: For this machine
util_list$Data <- RL1
util_list
summary(util_list)


# Subsetting a list
# Quick Chanllenge
util_list$UnknownHours[1]
util_list[[4]][1]

# Subsetting a list
util_list[1:2]
util_list[c(1,4)]
sublist_util_list <- util_list[c("Machine","Stats")]
sublist_util_list

# NOTE: Double Square Brackets are not for Subsetting
# util_list[[1:3]] # ERROR


# Building a timeseries plot
library(ggplot2)
p <- ggplot(data=util)
p + geom_line(aes(x=PosixTime, y=Utilization,
                  color=Machine),size=1.2)+
  facet_grid(Machine~.)+ # seperate to multi-graphs
  geom_hline(yintercept = 0.90,
             color="Gray", size=1.2,
             linetype=3)

myplot <- p + geom_line(aes(x=PosixTime, y=Utilization,
                            color=Machine),size=1.2)+
  facet_grid(Machine~.)+ # seperate to multi-graphs
  geom_hline(yintercept = 0.90,
             color="Gray", size=1.2,
             linetype=3)

util_list$Plot <- myplot # add the plot to the list
util_list
summary(util_list)
