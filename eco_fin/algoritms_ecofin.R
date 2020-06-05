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

df = readRDS('df.rds')

#--- Rose library

library(ROSE)

df3 = ovun.sample(as.factor(crise)~., data=df, method="both", p=0.5,
            subset=options("subset")$subset,
            na.action=options("na.action")$na.action, seed=1)

df3 = data.frame(df3$data)


prop.table(table(df3$crise))


#---- Control train


control_train = trainControl(method = 'repeatedcv', number = 10, repeats = 2)    # ten fold


#----- Neural net

#control_train =trainControl(method = "timeslice",initialWindow = 36, horizon = 12, fixedWindow = T,allowParallel = T)  

model_a = train(as.factor(crise) ~ ret^2 + rav + oil + cb + embi + cdi, data=df3, 
              trControl = control_train, 
              method='nnet', threshold = 0.3,
              maxit=1000,
              MaxNWts=2000
              )
              

model_a

confusionMatrix(model_a)


#best performance

model_b = train(as.factor(crise) ~ ret^2 + rvix + oil + cb + embi + cdi, data=df3 , trControl = control_train, 
               method='nnet', threshold = 0.6)
 
model_b
confusionMatrix(model_b)







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








