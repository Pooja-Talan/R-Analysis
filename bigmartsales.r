# Sample Analysis Project with Rstudio
print('Dataset used is BigMartSales')
print('Loading data')

train <- read.csv('/home/pooja/Desktop/BigMartSales/Train_UWu5bXk.csv')
test <- read.csv('/home/pooja/Desktop/BigMartSales/Test_u94Q5KV.csv')

print('Combine train and test dataset to clean data')
test$Item_Outlet_Sales <-1
combi <- rbind(train,test)

print('Fill missing weight values by median of Item weight')
combi$Item_Weight[is.na(combi$Item_Weight)] <- median(combi$Item_Weight, na.rm=TRUE)

print('Change the minimum Item Visibility value to median of item visibility')
combi$Item_Visibility <- ifelse(combi$Item_Visibility == 0, median(combi$Item_Visibility), combi$Item_Visibility )

levels(combi$Outlet_Size)[1] <- 'Other'
library(plyr)
combi$Item_Fat_Content <- revalue(combi$Item_Fat_Content, c('LF'='Low Fat', 'low fat'= 'Low Fat', 'reg'='Regular'))

library(dplyr)

# Groupby Outlet Identifier and take the join with combi, count of Outlet_Identifier
a <- combi%>%
  group_by(Outlet_Identifier)%>%
  tally()
head(a)
names(a)[2] <- 'Outlet_Count'
combi<- full_join(a,combi, by='Outlet_Identifier')

# Groupby Item Identifier and take the join with combi, count of item_Identifier

b <- combi %>%
  group_by(Item_Identifier) %>%
  tally()
names(b)[2] <- 'Identifier_Count'
combi <- full_join(b,combi, by='Item_Identifier')


