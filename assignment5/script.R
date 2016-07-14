# Question 1, 2
data <- read.csv("seaflow_21min.csv")

str(data)
summary(data)

head(data,20)
summary(data$pop)

# Question 3
library(caret)
# createDataPartition, Y means the vector you want to evaluate/i.e. the outcomes.
x = createDataPartition(data$pop, p=0.5, list=FALSE)
head(x)
training <- data[x,]
testing <- data[-x,]
dim(training)
dim(testing)
mean(training$time)

# Question 4
library(ggplot2)
str(data)

ggplot(data,aes(x=pe, y=chl_small, colour=pop))+
  geom_point()

# Question 5,6,7
library(rpart)
fol <- formula(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small)
model <- rpart(fol, method = "class", data=training)
print(model)

# Question 8
ptA <- as.data.frame(predict(model, testing))
x = levels(testing$pop)
ptA$max <- factor(names(ptA)[apply(ptA, 1, which.max)], levels=x)
ptA$real <- testing$pop

myfunc <- function(x){
  m=0
  if (x[6]==x[7]){
   m = 1 
  }
  return(m)
}
ptA$correct <- apply(ptA,1,myfunc)
accuracy <- sum(ptA$correct)/nrow(na.omit(ptA))
# 0.8543861
accuracy

# Question 9
library(randomForest)
modelForest <- randomForest(fol, data=training)
ptB <- as.data.frame(predict(modelForest, testing))
ptB$max <- predict(modelForest, testing)
ptB$real <- testing$pop
myfunc <- function(x){
  m=0
  if (x[2]==x[3]){
    m = 1 
  }
  return(m)
}
ptB$correct <- apply(ptB,1,myfunc)
accuracy <- sum(ptB$correct)/nrow(na.omit(ptB))
# 0.9201017
accuracy

# Question 10
importance(modelForest)

# Question 11
library(e1071)
modelSVM <- svm(fol, data=training)
ptC <- as.data.frame(predict(modelSVM, testing))
ptC$max <- predict(modelSVM, testing)
ptC$real <- testing$pop
myfunc <- function(x){
  m=0
  if (x[2]==x[3]){
    m = 1 
  }
  return(m)
}
ptC$correct <- apply(ptC,1,myfunc)
accuracy <- sum(ptC$correct)/nrow(na.omit(ptC))
# 0.92071
accuracy
# Question 12
table(pred = ptA$max, true = ptA$real)
table(pred = ptB$max, true = ptB$real)
table(pred = ptC$max, true = ptC$real)

# Question 13
plot(data$fsc_small)
plot(data$fsc_perp)

# This looks like a categorical type
plot(data$fsc_big)

plot(data$pe)
plot(data$chl_small)
plot(data$chl_big)

# Question 14
with(data,plot(time,chl_big))
row_to_keep = (data$file_id != 208)
data = data[row_to_keep,]
x = createDataPartition(data$pop, p=0.5, list=FALSE)
training <- data[x,]
testing <- data[-x,]
#method A
ptA <- as.data.frame(predict(model, testing))
x = levels(testing$pop)
ptA$max <- factor(names(ptA)[apply(ptA, 1, which.max)], levels=x)
ptA$real <- testing$pop

myfunc <- function(x){
  m=0
  if (x[6]==x[7]){
    m = 1 
  }
  return(m)
}
ptA$correct <- apply(ptA,1,myfunc)
accuracy <- sum(ptA$correct)/nrow(na.omit(ptA))
# 0.8928181
accuracy

#method B
modelForest <- randomForest(fol, data=training)
ptB <- as.data.frame(predict(modelForest, testing))
ptB$max <- predict(modelForest, testing)
ptB$real <- testing$pop
myfunc <- function(x){
  m=0
  if (x[2]==x[3]){
    m = 1 
  }
  return(m)
}
ptB$correct <- apply(ptB,1,myfunc)
accuracy <- sum(ptB$correct)/nrow(na.omit(ptB))
# 0.9703046
accuracy

#method C
modelSVM <- svm(fol, data=training)
ptC <- as.data.frame(predict(modelSVM, testing))
ptC$max <- predict(modelSVM, testing)
ptC$real <- testing$pop
myfunc <- function(x){
  m=0
  if (x[2]==x[3]){
    m = 1 
  }
  return(m)
}
ptC$correct <- apply(ptC,1,myfunc)
accuracy <- sum(ptC$correct)/nrow(na.omit(ptC))
# 0.9723594
accuracy
