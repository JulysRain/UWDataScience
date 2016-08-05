library(data.table)
library(plyr)

data <- read.csv("sanfrancisco_incidents_summer_2014.csv")

date <- as.Date(data$Date,format="%m/%d/%y")
day<-format(date, "%d")

dt <- data.table(data)

agdt <- aggregate(dt$Category, by=list(dt$Category,day),FUN = length)

library(reshape2)

aqw <- dcast(agdt, Group.2~Group.1)
aqw[is.na(aqw)]=0
aqw$Group.2=NULL
head(aqw)
xzz <- cor(aqw)
xzz[upper.tri(xzz,diag=T)]=NA
match_ind = which(abs(xzz)>0.5,arr.ind=T);match_ind

matched <- data.frame(x=colnames(aqw)[match_ind[,2]],y=row.names(match_ind),cor=xzz[match_ind]);matched


