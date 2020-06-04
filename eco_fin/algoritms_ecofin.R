#***********************************************************************************************
#                                   Algorithms
#***********************************************************************************************

setwd("D:/Git projects/college_works/eco_fin")

library(caret)
library(ROSE)




# see: http://topepo.github.io/caret/train-models-by-tag.html#neural-network
# see: https://www.analyticsvidhya.com/blog/2016/03/practical-guide-deal-imbalanced-classification-problems/
# CV in TS https://rpubs.com/crossxwill/time-series-cv


#--- load variables

pca = readRDS('pca.rds')
df = readRDS('df.rds')

pca2 = pca
pca2 = pca2[-1]
#pca2 =pca2[-242]


basicStats(pca2)

df2 = df
df2$pca = pca2


table(df2$x)

saveRDS(df2, 'findata.rds')
#--- Rose library

library(ROSE)

df3 = ovun.sample(as.factor(x)~., data=df2, method="both", p=0.5,
            subset=options("subset")$subset,
            na.action=options("na.action")$na.action, seed=1)

df3 = data.frame(df3$data)


table(df3$x)


#---- Control train


control_train = trainControl(method = 'repeatedcv', number = 10, repeats = 2)    # ten fold


#----- Neural net

#control_train =trainControl(method = "timeslice",initialWindow = 36, horizon = 12, fixedWindow = T,allowParallel = T)  


model4 = train(as.factor(x) ~., data=df2, trControl = control_train, 
               method='nnet', threshold = 0.3)



model4 = train(as.factor(x) ~ vix + oil + cdi + cb, data=df3 , trControl = control_train, 
               method='nnet', threshold = 0.6)
 
model4
confusionMatrix(model4)

library(nnet)
library('pROC')


library(neuralnet)
m = neuralnet(x~., data=df2, hidden = 3, linear.output = T)



roc(df$x, m$response, plot=T)






# 41% correto com var2 

# 1 best: as.factor(x) ~ vix + ret**2 + cdi + gold + oil   (0.9087)
# 2 best: as.factor(x) ~ vix + ret + cdi + gold + oil      (0.8921)
# 3 best: as.factor(x) ~ vix + ret + cdi + gold + cb       (0.8423)

#------ Multilogit


model3 = train(as.factor(x) ~., data=df3, 
               trControl = control_train, 
               method='multinom', family='binomial') 

model3
confusionMatrix(model3)


#------- SVM

model5 = train(as.factor(crise) ~., data=df, trControl = control_train, 
               method='svmRadial') 

model5
confusionMatrix(model5)




#------- KNN


model6 = train(as.factor(crise) ~., data=df, 
               trControl = control_train, 
               method='knn') 

model6
confusionMatrix(model6)








