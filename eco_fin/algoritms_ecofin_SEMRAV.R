#***********************************************************************************************
#                                   Algorithms without rav
#***********************************************************************************************

setwd("D:/Git projects/college_works/eco_fin")


# functions


metrics = function(cm){
  acur�cia = (cm[["table"]][1,1] + cm[["table"]][2,2])/sum(cm[["table"]])
  cpc = cm[["table"]][2,2] / ( cm[["table"]][1,2] + cm[["table"]][2,2] )
  sensibilidade = cm[["table"]][1,1] / ( cm[["table"]][1,1] + cm[["table"]][2,1] )  
  especificidade = cm[["table"]][2,2] /( cm[["table"]][2,2] + cm[["table"]][1,2] )
  G = sqrt(sensibilidade*especificidade)
  LP = sensibilidade/(1 - especificidade)
  LR = (1 - sensibilidade)/(especificidade)
  DP = sqrt(pi)/3 * ( log(sensibilidade/(1 - sensibilidade) ) + log( especificidade/(1 - especificidade) )  )
  gamma = sensibilidade - (1 - especificidade)
  BA = (1/2) * (sensibilidade + especificidade)
  m�tricas = data.frame(acur�cia, cpc, sensibilidade, especificidade, G, LP, LR, DP, gamma, BA)
}



# libraries

library('xtable')
library(caret)
library(ROSE)



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


control_train = trainControl(method = 'repeatedcv', number = 10, repeats = 5)    # ten fold


#----- Neural net

# sem rav


model_b = train(as.factor(crise) ~  gold + embi + oil + cb  + cdi, data=df3, 
                trControl = control_train, 
                method='nnet', 
                threshold = 0.3,
                maxit=600,
                MaxNWts=1500)
 


cm_nn = confusionMatrix(model_b)



#------ logit


# sem rav


model_d = train(as.factor(crise) ~  gold + embi + oil + cb  + cdi, data=df3,  
                trControl = control_train, 
                method='multinom', 
                family='binomial') 


cm_ml = confusionMatrix(model_d)


#------- KNN




# sem rav

model_f = train(as.factor(crise) ~  gold + embi + oil + cb  + cdi, data=df3, 
                trControl = control_train, 
                method='knn') 


cm_knn = confusionMatrix(model_f)






#------ Random Forests


# sem rav

model_h =train(as.factor(crise) ~  gold + embi + oil + cb + cdi, data=df3, 
                trControl = control_train, method='rf') 


model_h
cm_rf = confusionMatrix(model_h)



#--- XGboost

tune_grid <- expand.grid(nrounds = 200,
                         max_depth = 5,
                         eta = 0.05,
                         gamma = 0.01,
                         colsample_bytree = 0.75,
                         min_child_weight = 0,
                         subsample = 0.5)




# sem rav


model_j = train(as.factor(crise) ~  gold + embi + oil + cb  + cdi, data=df3,
          method = "xgbTree",
          trControl=control_train,
          tuneGrid = tune_grid,
          tuneLength = 10)



cm_xg = confusionMatrix(model_j)



#--------- SVM

# rav

model_k = train(as.factor(crise) ~  gold + embi + oil + cb + cdi, data=df3,
               method='svmRadial',
               tuneLength = 8,
               trControl = control_train) 



cm_svm = confusionMatrix(model_k)



#------------- create dataframe




m�tricas = data.frame(matrix(, nrow=5, ncol=10))
row.names(m�tricas) = c('Logit', 'Redes neurais','SVM', 'Random Forests', 'XGboost')
colnames(m�tricas) = c("Acur�cia", "CPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



m�tricas[1, ] = metrics(cm_ml)
m�tricas[2, ] = metrics(cm_nn)
m�tricas[3, ] = metrics(cm_svm)
m�tricas[4, ] = metrics(cm_rf)
m�tricas[5, ] = metrics(cm_xg)


m�tricas = round( m�tricas, 4)

m�tricas = t(m�tricas)



m2 = m�tricas

print(xtable(m�tricas, type = "latex", digits=4), file = "semRAV.tex")


