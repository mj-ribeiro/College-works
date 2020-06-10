#***********************************************************************************************
#                                   Algorithms only RAV
#***********************************************************************************************

setwd("D:/Git projects/college_works/eco_fin")


# functions



metrics = function(cm){
  acurácia = (cm[["table"]][1,1] + cm[["table"]][2,2])/sum(cm[["table"]])
  cpc = cm[["table"]][2,2] / ( cm[["table"]][1,2] + cm[["table"]][2,2] )
  sensibilidade = cm[["table"]][1,1] / ( cm[["table"]][1,1] + cm[["table"]][2,1] )  
  especificidade = cm[["table"]][2,2] /( cm[["table"]][2,2] + cm[["table"]][1,2] )
  G = sqrt(sensibilidade*especificidade)
  LP = sensibilidade/(1 - especificidade)
  LR = (1 - sensibilidade)/(especificidade)
  DP = sqrt(pi)/3 * ( log(sensibilidade/(1 - sensibilidade) ) + log( especificidade/(1 - especificidade) )  )
  gamma = sensibilidade - (1 - especificidade)
  BA = (1/2) * (sensibilidade + especificidade)
  métricas = data.frame(acurácia, cpc, sensibilidade, especificidade, G, LP, LR, DP, gamma, BA)
}




# libraries

library('xtable')
library(caret)
library(ROSE)



#--- load variables

df = readRDS('df.rds')


df3 = ovun.sample(as.factor(crise)~., data=df, method="both", p=0.5,
                  subset=options("subset")$subset,
                  na.action=options("na.action")$na.action, seed=1)

df3 = data.frame(df3$data)


prop.table(table(df3$crise))


#---- Control train


control_train = trainControl(method = 'repeatedcv',
                             number = 10, 
                             repeats = 10,
                             savePredictions = T)    # ten fold


#----- Neural net


# rav

model_a = train(as.factor(crise) ~  rav, data=df3, 
                trControl = control_train, 
                method='nnet', threshold = 0.3,
                maxit=700,
                MaxNWts=1300
)


model_a

cm_NN = confusionMatrix(model_a)



#------ Multilogit

# rav

model_c = train(as.factor(crise) ~  rav, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial') 


cm_ml = confusionMatrix(model_c)



#------- KNN


# rav

model_e = train(as.factor(crise) ~  rav, data=df3,
                trControl = control_train, 
                method='knn') 

model_e
cm_knn = confusionMatrix(model_e)



#------ Random Forests
library('plotROC')



control_train = trainControl(method = 'repeatedcv',
                             number = 10, 
                             repeats = 10,
                             savePredictions = T)    # ten fold



# rav

model_g = train(as.factor(crise) ~  rav, data=df3,
                trControl = control_train, method='rf') 



model_g

selectedIndices <- model_g$pred$mtry == 135

g <- ggplot(model_g$pred[selectedIndices, ], aes(m=M, d=factor(obs, levels = c("R", "M")))) + 
  geom_roc(n.cuts=0) + 
  coord_equal() +
  style_roc()

g + annotate("text", x=0.75, y=0.25, label=paste("AUC =", round((calc_auc(g))$AUC, 4)))



cm_rf = confusionMatrix(model_g)



#--- XGboost

tune_grid <- expand.grid(nrounds = 200,
                         max_depth = 5,
                         eta = 0.05,
                         gamma = 0.01,
                         colsample_bytree = 0.75,
                         min_child_weight = 0,
                         subsample = 0.5)



# rav



model_i = train(as.factor(crise) ~  rav, data=df3,
                method = "xgbTree",
                trControl=control_train,
                tuneGrid = tune_grid,
                tuneLength = 10)



cm_xg = confusionMatrix(model_i)




#--------- SVM

# rav

model_k = train(as.factor(crise) ~  rav, data=df3,
                method='svmRadial',
                tuneLength = 10,
                trControl = control_train) 



cm_svm = confusionMatrix(model_k)

ggplot(model_k) + scale_x_log10() 

#------------- create dataframe


métricas = data.frame(matrix(, nrow=5, ncol=10))
row.names(métricas) = c('Logit', 'Redes neurais','SVM', 'Random Forests', 'XGboost')
colnames(métricas) = c("Acurácia", "CPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



métricas[1, ] = metrics(cm_ml)
métricas[2, ] = metrics(cm_NN)
métricas[3, ] = metrics(cm_svm)
métricas[4, ] = metrics(cm_rf)
métricas[5, ] = metrics(cm_xg)


métricas = round( métricas, 4)

métricas = t(métricas)


m2
m3
m4



print(xtable(métricas, type = "latex", digits=4), file = "sóRAV.tex")


