#***********************************************************************************************
#                                   Algorithms without rav
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


# df2 = df
# 
# data = rownames(df2[2:242,])
# 
# rgold = diff(log(df2$gold))
# roil = diff(log(df2$oil))
# rcdi = diff(log(df2$cdi))
# rcb = diff(log(df2$cb))
# rembi = diff(log(as.numeric(df2$embi)))
# crise = df2$crise[2:242]
# rvix =  df2$rvix[2:242]
# rav = df2$rav[2:242]
# 
# dff = data.frame(rgold, roil, rcdi, rcb, rembi, rvix, rav, crise)

# rownames(dff) = data



#--- Rose library

library(ROSE)

df3 = ovun.sample(as.factor(crise)~., data=df, method="both", p=0.50,
                  subset=options("subset")$subset,
                  na.action=options("na.action")$na.action, seed=1)

df3 = data.frame(df3$data)


prop.table(table(df3$crise))


#---- Control train


control_train = trainControl(method = 'repeatedcv', number = 10, repeats = 10)    # ten fold




###############################################################################################
#                                     Sem RAV
###############################################################################################


# LOGIT

model_d = train(as.factor(crise) ~  gold + embi + oil + cb  + cdi, data=df3,  
                trControl = control_train, 
                method='multinom', 
                family='binomial') 


varImp(model_d)
cm_lg1 = confusionMatrix(model_d)



# RF


model_h =train(as.factor(crise) ~  gold + embi + oil + cb + cdi, data=df3, 
               trControl = control_train, method='rf') 


cm_rf1 = confusionMatrix(model_h)





#---------- create dataframe


métricas = data.frame(matrix(, nrow=2, ncol=10))
row.names(métricas) = c('Logit',  'Random Forests')
colnames(métricas) = c("Acurácia", "CPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



métricas[1, ] = metrics(cm_lg1)
métricas[2, ] = metrics(cm_rf1)


métricas = round( métricas, 4)

semrav = t(métricas)







###############################################################################################
#                                     Com  RAV
###############################################################################################



# LOGIT


model_c = train(as.factor(crise) ~  gold + embi + oil + cb + vix + cdi, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial') 


cm_lg2 = confusionMatrix(model_c)

plot(df3$rav, type='l')
abline(h=0)


# RF

library('randomForest')

model_g = train(as.factor(crise) ~  gold + embi + oil + cb + vix + cdi, data=df3, 
                trControl = control_train, method='rf'
               ) 

cm_rf2 = confusionMatrix(model_g)


#---------- create dataframe


métricas = data.frame(matrix(, nrow=2, ncol=10))
row.names(métricas) = c('Logit',  'Random Forests')
colnames(métricas) = c("Acurácia", "CPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



métricas[1, ] = metrics(cm_lg2)
métricas[2, ] = metrics(cm_rf2)


métricas = round( métricas, 4)

comrav = t(métricas)






###############################################################################################
#                                     Somente  RAV
###############################################################################################

# LOGIT


model_m = train(as.factor(crise) ~  vix, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial') 


cm_lg3 = confusionMatrix(model_m)




# RF


model_r = train(as.factor(crise) ~ vix, data=df3,
                trControl = control_train,
                method='rf') 


cm_rf3 = confusionMatrix(model_r)




#---------- create dataframe


métricas = data.frame(matrix(, nrow=2, ncol=10))
row.names(métricas) = c('Logit',  'Random Forests')
colnames(métricas) = c("Acurácia", "CPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



métricas[1, ] = metrics(cm_lg3)
métricas[2, ] = metrics(cm_rf3)


métricas = round( métricas, 4)

sorav = t(métricas)




#print(xtable(métricas, type = "latex", digits=4), file = "sóRAV.tex")

semrav
comrav
sorav




########################################

df3$rav = as.numeric(df3$rav)

summary(df3$rav)

model =glm(as.factor(crise) ~  gold  + oil +  cdi +
             rav + cb +
             as.numeric(embi),
           family = 'binomial',  data=df3[-2,])

summary(model)

plot(as.numeric(df$av)/10, type = 'l', ylim = c(0,1))
abline(h=0)
lines(df$crise)


plot(df$vix/100, type = 'l', ylim = c(0,1))
abline(h=0)
lines(df$crise)




library(randomForest)

rf = randomForest(as.factor(crise) ~  gold  + oil +  cdi + vix + embi + cb, data=df3)

importance(rf)
varImpPlot(rf)



