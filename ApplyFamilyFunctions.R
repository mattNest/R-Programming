getwd()
setwd("/Users/Matthew/Desktop/Advanced R programming A-Z/Weather Data/")
getwd() 

Chicago <- read.csv("Chicago-F.csv", row.names = 1)
NewYork <- read.csv("NewYork-F.csv", row.names = 1)
Houston <- read.csv("Houston-F.csv", row.names = 1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names = 1)

# convert to matrix
Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco <- as.matrix(SanFrancisco)

# put them into a weather list
Weather <- list(Chicago=Chicago, NewYork=NewYork, Houston=Houston, SanFrancisco=SanFrancisco)
typeof(Weather) # list
Weather


# using apply()
Chicago
apply(Chicago, 1, mean) # apply mean function to Chicago's rows

# compare
apply(Chicago,1,mean)
apply(NewYork,1,mean)
apply(Houston,1,mean)
apply(SanFrancisco,1,mean)
# find the max 
temp <- cbind(apply(Chicago,1,mean),apply(NewYork,1,mean),apply(Houston,1,mean),apply(SanFrancisco,1,mean))
colnames(temp) <- c("Chicago","New York","Houston","San Francisco")
apply(temp,1,max)


# Recreating the applying function with loops(advanced topics)
Chicago

# Goal: Find the mean of every row

# Method One: via loops
output <- NULL 
for(i in 1:nrow(Chicago)){
  output[i] <- mean(Chicago[i,])
}
output
names(output) <- rownames(Chicago)


# Method Two: via apply()
apply(Chicago,1,mean)


# lapply()
my_new_t_list <- lapply(Weather,t) # my_new_list <- (t(Weather$Chicago),t(Weather$NewYork),t(Weather$Houston),t(Weather$San Francisco))
my_new_t_list

my_rowmean_list <- lapply(Weather,rowMeans)
my_rowmean_list
# compare with the previous method
apply(Chicago,1,mean)
apply(NewYork,1,mean)
apply(Houston,1,mean)
apply(SanFrancisco,1,mean)


# Combining lapply with the [] operator
Weather
Weather$Chicago[1,1] # Weather[[1]][1,1]
lapply(Weather,"[",1,1)
Weather
lapply(Weather,"[",1,)
Weather
lapply(Weather,"[",,3)


# Adding your own functions
lapply(Weather, rowMeans)
lapply(Weather, function(x) x[1,])
lapply(Weather, function(x) x[5,])
lapply(Weather, function(x) x[,12])
Weather
highLow_pctchange <- lapply(Weather, function(y) round((y[1,]-y[2,])/y[2,],2))
highLow_pctchange


# Using sapply()

# AvgHigh_F for July
lapply(Weather,"[",1,7) # return a list
sapply(Weather,"[",1,7) # return a vector

# AvgHigh_F for 4th quarter
lapply(Weather,"[",1,10:12)
sapply(Weather,"[",1,10:12)

# Another Example
lapply(Weather,rowMeans)
sapply(Weather,rowMeans)
round(sapply(Weather,rowMeans),2)

# Another Example
lapply(Weather, function(y) round((y[1,]-y[2,])/y[2,],2))
sapply(Weather, function(y) round((y[1,]-y[2,])/y[2,],2))


# Nesting apply functions
Weather
lapply(Weather, rowMeans)
Chicago
apply(Chicago,1,max) # find the max of each row

# apply across the whole list using lapply
lapply(Weather,apply,1,max)
lapply(Weather, function(x) apply(x,1,max)) # preferred approach # same as line 114

# apply across the whole list using sapply
sapply(Weather,apply,1,max)
sapply(Weather, function(x) apply(x,1,max)) # preferred approach # same as line 117


# Very advanced tutorial
# which.max
which.max(Chicago[1,])
names(which.max(Chicago[1,]))
apply(Chicago, 1, function(x) names(which.max(x))) # use apply() to iterate over the rows of matrix
lapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x)))) # use sapply or lapply to iterate the components in the list
sapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x)))) # use sapply or lapply to iterate the components in the list

