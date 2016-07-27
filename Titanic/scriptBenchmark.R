
# This script trains a Random Forest model based on the data,
# saves a sample submission, and plots the relative importance
# of the variables in making predictions

# Download 1_random_forest_r_submission.csv from the output below
# and submit it through https://www.kaggle.com/c/titanic-gettingStarted/submissions/attach
# to enter this getting started competition!

library(ggplot2)
library(randomForest)
library(caret)

set.seed(1006)
train <- read.csv("train.csv", stringsAsFactors=FALSE)
accuracy<-0
# avgAccu<-0
# p=0.5
# i=1
# while (p<1){
x = createDataPartition(train$Survived, p=0.7, list=FALSE)
training <- train[x,]
testing <- train[-x,]

extractFeatures <- function(data) {
  features <- c("Pclass",
                "Age",
                "Sex",
                "Parch",
                "SibSp",
                "Fare",
                "Embarked")
  fea <- data[,features]
  fea$Age[is.na(fea$Age)] <- -1
  fea$Fare[is.na(fea$Fare)] <- median(fea$Fare, na.rm=TRUE)
  fea$Embarked[fea$Embarked==""] = "S"
  fea$Sex      <- as.factor(fea$Sex)
  fea$Embarked <- as.factor(fea$Embarked)
  return(fea)
}

treenum = 1
while (treenum<100){
rf <- randomForest(extractFeatures(training), as.factor(training$Survived), ntree=1, importance=TRUE)

submission <- data.frame(PassengerId = testing$PassengerId)
submission$Survived <- predict(rf, extractFeatures(testing))
submission$label <- train$Survived[PassengerId=testing$PassengerId]
submission$correct <- (submission$Survived==submission$label)
accuracy[treenum] <- sum(submission$correct)/nrow(submission); accuracy[treenum]
treenum = treenum + 1
}
# avgAccu[i] <- mean(accuracy)
# p=p+0.02
# i=i+1
# }
mean(accuracy)
plot(accuracy,type="l", xlab = "number of trees", ylab = "accuracy")


imp <- importance(rf, type=1)
featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])

p <- ggplot(featureImportance, aes(x=reorder(Feature, Importance), y=Importance)) +
  geom_bar(stat="identity", fill="#53cfff") +
  coord_flip() + 
  theme_light(base_size=20) +
  xlab("") +
  ylab("Importance") + 
  ggtitle("Random Forest Feature Importance\n") +
  theme(plot.title=element_text(size=18))

ggsave("2_feature_importance.png", p)