#***********************************************************************************************
#                                   Algorithms
#***********************************************************************************************

setwd("D:/Git projects/college_works/eco_fin")

library(caret)
library(ROSE)
library(xgboost)



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

# rav

model_a = train(as.factor(crise) ~ ret^2 + rav + oil + cb + embi + cdi, data=df3, 
              trControl = control_train, 
              method='nnet', threshold = 0.3,
              maxit=1000,
              MaxNWts=2000
              )
              

model_a

confusionMatrix(model_a)


# vix

model_b = train(as.factor(crise) ~ ret^2 + rvix + oil + cb + embi + cdi, data=df3 , 
                trControl = control_train, 
                method='nnet', 
                threshold = 0.3,
                maxit=1000,
                MaxNWts=2000)
 
model_b
confusionMatrix(model_b)




#------ Multilogit

# rav

model_c = train(as.factor(crise) ~ ret^2 + rav + oil + cb + embi + cdi, data=df3, 
               trControl = control_train, 
               method='multinom', 
               family='binomial') 

model3
confusionMatrix(model3)


# vix


model_d = train(as.factor(crise) ~ ret^2 + rvix + oil + cb + embi + cdi, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial') 


#------- SVM

model5 = train(as.factor(crise) ~ ret^2 + rav + oil + cb + embi + cdi, data=df3, 
               method='svmRadial') 

model5
confusionMatrix(model5)




#------- KNN

# vix

model_e = train(as.factor(crise) ~ ret^2 + rvix + oil + cb + embi + cdi, data=df3, 
               trControl = control_train, 
               method='knn') 

model_e
confusionMatrix(model_e)


# rav

model_f = train(as.factor(crise) ~ ret^2 + rav + oil + cb + embi + cdi, data=df3, 
                trControl = control_train, 
                method='knn') 



model_f


#------ Random Forests

# vix

model_g = train(as.factor(crise) ~ ret^2 + rvix + oil + cb + embi + cdi, data=df3,
               trControl = control_train, method='rf') 


model_g
confusionMatrix(model_g)


# rav

model_h = train(as.factor(crise) ~ ret^2 + rav + oil + cb + embi + cdi, data=df3,
                trControl = control_train, method='rf') 


model_h
confusionMatrix(model_h)



#--- XGboost

tune_grid <- expand.grid(nrounds = 200,
                         max_depth = 5,
                         eta = 0.05,
                         gamma = 0.01,
                         colsample_bytree = 0.75,
                         min_child_weight = 0,
                         subsample = 0.5)




# vix

control_train = trainControl(method = 'repeatedcv', number = 10, repeats = 10)    # ten fold


model_i = train(as.factor(crise) ~ ret^2 + rvix + oil + cb + embi + cdi, data=df3,
                method = "xgbTree",
                trControl=control_train,
                tuneGrid = tune_grid,
                tuneLength = 10)

confusionMatrix(model_i)




# rav


model_j = train(as.factor(crise) ~ ret^2 + rav + oil + cb + embi + cdi, data=df3,
          method = "xgbTree",
          trControl=control_train,
          tuneGrid = tune_grid,
          tuneLength = 10)



cm = confusionMatrix(model_j)

metrics = function(cm){
  acurácia = (cm$table[1,1] + cm$table[2,2])/sum(cm$table)
  sensibilidade = cm$table[1,1] / ( cm$table[1,1] + cm$table[2,1] )  
  especificidade = cm$table[2,2] /( cm$table[2,2] + cm$table[1,2] )
  G = sqrt(sensibilidade*especificidade)
  LP = sensibilidade/(1 - especificidade)
  LR = (1 - sensibilidade)/(especificidade)
  DP = sqrt(pi)/3 * ( log(sensibilidade/(1 - sensibilidade) ) + log( especificidade/(1 - especificidade) )  )
  gamma = sensibilidade - (1 - especificidade)
  BA = (1/2) * (sensibilidade + especificidade)
  métricas = data.frame(acurácia, sensibilidade, especificidade, G, LP, LR, DP, gamma, BA)
  knitr::kable(métricas)
}

a = metrics(cm)










