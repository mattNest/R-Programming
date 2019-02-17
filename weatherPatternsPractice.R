getwd()

Chicago <- read.csv("Chicago-C.csv", row.names = 1)
Houston <- read.csv("Houston-C.csv", row.names = 1)
NewYork <- read.csv("NewYork-C.csv", row.names = 1)
SanFran <- read.csv("SanFrancisco-C.csv", row.names = 1)

# Task One: A table showing the annual averages of each observed metric for every city
apply(Chicago,1,mean)
apply(Houston,1,mean)
apply(NewYork,1,mean)
apply(SanFran,1,mean)

Weather <- list(Chicago=Chicago,Houston=Houston,NewYork=NewYork,SanFran=SanFran) # put 
sapply(Weather,apply,1,mean) # apply the whole list using sapply

# Task Two: A table showing by how much temperature fluctuates each month from min to
# max (in %). Take min temperature as the base

sapply(Weather, function(y) round((y[1,]-y[2,])/y[2,],2))
lapply(Weather, function(x) round((x[1,]-x[2,]/x[2,]),2))


# Task Three: A table showing the annual maximums of each observed metric for every city
sapply(Weather,apply,1,max)
sapply(Weather, function(x) apply(x,1,max)) # better way


# Task Four: A table showing the annual minimums of each observed metric for every city
sapply(Weather,apply,1,min)
sapply(Weather, function(x) apply(x,1,min)) # better way


# A table showing in which months the annual maximums of each metric were
# observed in every city (Advanced)

apply(Chicago, 1, function(x) names(which.max(x)))
apply(Houston, 1, function(x) names(which.max(x)))
apply(NewYork, 1, function(x) names(which.max(x)))
apply(SanFran, 1, function(x) names(which.max(x)))

sapply(Weather,function(y) apply(y,1, function(x) names(which.max(x)))) # better way
