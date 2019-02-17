getwd()
setwd("/Users/Matthew/Desktop/Advanced R programming A-Z/")
getwd()


fin <- read.csv("Future-500.csv", na.strings = c(""))
head(fin)
tail(fin)
str(fin)
summary(fin)

# Factor --> Categorical variable
# Changing from non-factor to factor:
fin$ID <- factor(fin$ID)
summary(fin)
str(fin)

fin$Inception <- factor(fin$Inception)
summary(fin)
str(fin)


# Factor Variable Trap
# Converting into Numerics For "Characters" ("Characters" to "Numerics")
a <- c("12","13","14","12","12")
a
typeof(a) # character

b <- as.numeric(a)
b
typeof(b) # double

# Converting into Numeric for "Factors" ("Factors" to "Numerics")
z <- factor(c("12","13","14","12","12"))
z
typeof(z) # integer

y <- as.numeric(z)
y # [1] 1 2 3 1 1
typeof(y) # double
# 因為R是用數字在存categorical變數，所以直接呼叫as.numeric會變成一堆整數

# The correct way: 先轉成character，再轉乘numeric
x <- as.numeric(as.character(z))
x # [1] 12 13 14 12 12
typeof(x) # double


# Factor Variable Trap (FVT) Example
head(fin)
str(fin)
# fin$Profit <- factor(fin$Profit) 很危險！

head(fin)
str(fin)
summary(fin)

# fin$Profit <- as.numeric(fin$Profit) 很危險！
str(fin)
head(fin)

# sub() and gsub()
fin$Expenses <- gsub(pattern = ' Dollars',replacement = "",x = fin$Expenses)
fin$Expenses <- gsub(pattern = ',',replacement = "",x = fin$Expenses) 
str(fin) # Expenses現在是chr
head(fin)

fin$Revenue <- gsub("\\$","",fin$Revenue) # R escape sequences
fin$Revenue <- gsub(",","",fin$Revenue)

fin$Growth <- gsub("%","",fin$Growth)

fin$Expenses <- as.numeric(fin$Expenses)
fin$Revenue <- as.numeric(fin$Revenue)
fin$Growth <- as.numeric(fin$Growth)

str(fin)
summary(fin)


# What is NA?
?NA

# NA: 3th logical variable
TRUE #1
FALSE #2
NA 


NA == TRUE
NA == FALSE 
NA == NA 

# Locating Missing Data
# Updated import to : fin <- read.csv("Future-500.csv", na.strings = c(""))
head(fin,24)
fin[!complete.cases(fin),] # !complete.cases(fin): have missing values

# Filtering: using which() for non-missing data
head(fin)
fin[fin$Revenue == 9746272,]
which(fin$Revenue == 9746272)
fin[c(3,4,5),]

head(fin)
fin[fin$Employees == 45,]
fin[which(fin$Employees == 45),]

# Filtering: using is.na() for missing data(上面filtering的相反做法)
head(fin,24)
fin[fin$Expenses == NA,] #不能直接跟NA比較

test <- c(1,24,543,NA,76,45,NA)
is.na(test)

is.na(fin$Expenses)
fin[is.na(fin$Expenses),]

is.na(fin$State)
fin[is.na(fin$State),]


# Removing records with the missing data
fin_backup <- fin # make a back_up data just in case
fin[!complete.cases(fin),]
fin[is.na(fin$Industry),]
fin[!is.na(fin$Industry),] #opposite(移除row14,row15)
fin <- fin[!is.na(fin$Industry),] # reassing to fin

# Resetting the dataframe index
fin
rownames(fin) <- 1:nrow(fin) # nrow(fin)==498
tail(fin)


# Replacing missing data: factual analysis
fin[!complete.cases(fin),]

fin[is.na(fin$State),]
fin[is.na(fin$State) & fin$City=="New York",]
fin[is.na(fin$State) & fin$City=="New York","State"] <- "NY"

# check if the missing data has been replaced
fin[c(11,377),] 

fin[!complete.cases(fin),]

fin[is.na(fin$State),]
fin[is.na(fin$State) & fin$City=="San Francisco","State"] <- "CA"

# check
fin[c(82,265),]

fin[!complete.cases(fin),] # getting smaller and smaller!


# Replacing missing data: Median Imputation method
fin[!complete.cases(fin),]

# whole dataset
median(fin[,"Employees"],na.rm = TRUE)
mean(fin[,"Employees"],na.rm = TRUE)

# retail sector (Industry==Retail)
median(fin[fin$Industry=="Retail","Employees"], na.rm = TRUE)
mean(fin[fin$Industry=="Retail","Employees"], na.rm = TRUE)

median_employee_retail <- median(fin[fin$Industry=="Retail","Employees"], na.rm = TRUE)
median_employee_retail


fin[is.na(fin$Employees),] # 取得整個dataset中Employees==NA的rows
fin[is.na(fin$Employees) & fin$Industry == "Retail",] # 取得整個dataset中Employees==NA 且 Industry==Retail的rows
fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] # 取得整個dataset中Employees==NA 且 Industry==Retail的rows的Employees col
fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] <- median_employee_retail # assign the value to median_employee_retail

# check
fin[3,]

# 剩下5個rows missing data要處理！
fin[!complete.cases(fin),]

# Financial Sector (Industry==Financial Services)
median(fin[fin$Industry=="Financial Services","Employees"], na.rm = TRUE)
mean(fin[fin$Industry=="Financial Services","Employees"], na.rm = TRUE)

median_employee_financial <- median(median(fin[fin$Industry=="Financial Services","Employees"], na.rm = TRUE))
fin[is.na(fin$Employees) & fin$Industry == "Financial Services", "Employees"] <- median_employee_financial

# check
fin[330,]

# 剩下4個rows missing data要處理！
fin[!complete.cases(fin),]


median(fin[fin$Industry=="Construction","Growth"], na.rm = TRUE)
median_growth_construction <- median(fin[fin$Industry=="Construction","Growth"], na.rm = TRUE)
fin[is.na(fin$Growth) & fin$Industry == "Construction", "Growth"] <- median_growth_construction
fin[8,]
fin[!complete.cases(fin),]


median(fin[fin$Industry=="Construction","Revenue"], na.rm = TRUE)
median_revenue_construction <- median(fin[fin$Industry=="Construction","Revenue"], na.rm = TRUE)
fin[is.na(fin$Revenue) & fin$Industry == "Construction", "Revenue"] <- median_revenue_construction
fin[8,]


median(fin[fin$Industry=="Construction","Expenses"], na.rm = TRUE)
median_expenses_construction <- median(fin[fin$Industry=="Construction","Expenses"], na.rm = TRUE)
# row filter多加了一個條件is.na(fin$Profit)，確保不會幫已經可以從Profit derive值的expenses填中位數
# ex: 假設row 15的Industry == Construction，不加入is.na(fin$Profit)這個條件的話就會出錯（因為row15 expense可以用profit+expenses直接算)
fin[is.na(fin$Expenses) & fin$Industry=="Construction" & is.na(fin$Profit),"Expenses"] <- median_expenses_construction
fin[8,]


# Replacing missing data: deriving values
# Revenue - Expenses = Profit
# Expenses = Revenue - Profit
fin[is.na(fin$Profit),"Profit"] <- fin[is.na(fin$Profit),"Revenue"] - fin[is.na(fin$Expenses),"Expenses"]
fin[is.na(fin$Expenses),"Expenses"] <- fin[is.na(fin$Expenses),"Revenue"] - fin[is.na(fin$Expenses),"Profit"]

# check
fin[c(8,42),]
fin[!complete.cases(fin),] # done filtering


# deriving the value from individual
# fin[8,"Profit"] = fin[8,"Revenue"]-fin[8,"Expenses"]
#
# fin[!complete.cases(fin),]
# fin[42,"Profit"] = fin[42,"Revenue"]-fin[42,"Expenses"]
# fin[42,]
#
#
# fin[!complete.cases(fin),]
# fin[15,"Expenses"] = fin[15,"Profit"]+fin[15,"Revenue"]
# fin[15,]
#

# fin[!complete.cases(fin),]



# Visualization
# install packages ggplot
library(ggplot2)

# plot 1: A scatterplot classified by industry showing revenue, expenses, profit
p <- ggplot(data=fin)
p + geom_point(aes(x=Revenue, y=Expenses
                   ,color=Industry, size=Profit))

# plot 2:  A scatterplot that includes industry trends for the expenses~revenue relationship
d <- ggplot(data=fin, aes(x=Revenue, y=Expenses,
                          color=Industry))
d + geom_point() +
  geom_smooth(fill=NA, size=1.2)


# Boxplot
f <- ggplot(data=fin, aes(x=Revenue, y=Growth,
                          color=Industry))
f + geom_boxplot(size=1)

# Extra: adding geom_jitter()
f + geom_jitter()+
  geom_boxplot(size=1, alpha=0.5,
               outlier.color = NA)
