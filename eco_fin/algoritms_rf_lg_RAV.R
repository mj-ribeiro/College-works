#***********************************************************************************************
#                                   Algorithms without rav
#***********************************************************************************************

setwd("D:/Git projects/college_works/eco_fin")


# functions


metrics = function(cm){
  acurácia = (cm[["table"]][1,1] + cm[["table"]][2,2])/sum(cm[["table"]])
  cpc = cm[["table"]][2,2] / ( cm[["table"]][1,2] + cm[["table"]][2,2] )
  epc = cm[["table"]][1,1] / ( cm[["table"]][2,1] + cm[["table"]][1,1] )
  sensibilidade = cm[["table"]][1,1] / ( cm[["table"]][1,1] + cm[["table"]][2,1] )  
  especificidade = cm[["table"]][2,2] /( cm[["table"]][2,2] + cm[["table"]][1,2] )
  G = sqrt(sensibilidade*especificidade)
  LP = sensibilidade/(1 - especificidade)
  LR = (1 - sensibilidade)/(especificidade)
  DP = sqrt(pi)/3 * ( log(sensibilidade/(1 - sensibilidade) ) + log( especificidade/(1 - especificidade) )  )
  gamma = sensibilidade - (1 - especificidade)
  BA = (1/2) * (sensibilidade + especificidade)
  métricas = data.frame(acurácia, cpc, epc, sensibilidade, especificidade, G, LP, LR, DP, gamma, BA)
}



# libraries

library('xtable')
library(caret)
library(ROSE)
library('randomForest')
library(MLeval) # to get ROC curve



#--- load variables

df1 = readRDS('df.rds')


#df$rexc = as.numeric(df$rexc)
#df$embi = as.numeric(df$embi)

keep = c('crise2', 'gold',  'embi',  'oil', 'cb', 'rexc',  'cdi')

df6 = df1[,keep]


#--- Rose library

library(ROSE)

df3 = ovun.sample(as.factor(crise2)~., data=df6, method="both", p=0.50,
                  subset=options("subset")$subset,
                  na.action=options("na.action")$na.action, seed=1)

df3 = data.frame(df3$data)


prop.table(table(df3$crise2))


df3$crise2 = ifelse(df3$crise2==1, 'yes', 'no')

#---- Control train


control_train = trainControl(method = 'repeatedcv', 
                             number = 10, 
                             repeats = 10,
                             savePredictions = TRUE, 
                             classProbs = TRUE, 
                             verboseIter = TRUE)    # ten fold




###############################################################################################
#                                     Sem RAV
###############################################################################################


# LOGIT

model_d = train(as.factor(crise2) ~  gold + embi + oil + cb  + cdi, data=df3,  
                trControl = control_train, 
                method='multinom', 
                family='binomial',
                maxit=200) 


cm_lg1 = confusionMatrix(model_d)



x_d = evalm(model_d)


roc_lg1 = data.frame( x_d$roc$data[,c(2,1)] ) 




#---- RF


model_h =train(as.factor(crise2) ~  gold + embi + oil + cb + cdi, data=df3, 
               trControl = control_train, method='rf') 


cm_rf1 = confusionMatrix(model_h)



x_h = evalm(model_h)




roc_rf1 = data.frame( x_h$roc$data[,c(2,1)] ) 


roc_lg1$feature="Logit"
roc_rf1$feature="FAs"

m_sav = rbind(roc_lg1, roc_rf1)


ggplot(m_sav, aes(FPR, SENS, colour=feature)) +
  geom_line(size=0.8) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=17), 
        axis.text.y = element_text(size=17), 
        axis.title.x = element_text(colour = 'black', size=19),
        axis.title.y = element_text(colour = 'black', size=19),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size = 17)) + 
  xlab('Falso Positivo') + 
  ylab('Verdadeiro Positivo')  



#---------- create dataframe


métricas = data.frame(matrix(, nrow=2, ncol=11))
row.names(métricas) = c('Logit',  'FA')
colnames(métricas) = c("Acurácia", "CPC", "EPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



métricas[1, ] = metrics(cm_lg1)
métricas[2, ] = metrics(cm_rf1)


métricas = round( métricas, 4)

semrav = t(métricas)







###############################################################################################
#                                     Com  RAV
###############################################################################################



# LOGIT


model_c = train(as.factor(crise2) ~  gold + embi + oil + cb + rexc + cdi, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial',
                maxit=200) 


cm_lg2 = confusionMatrix(model_c)


# RF


model_g = train(as.factor(crise2) ~  gold + embi + oil + cb + rexc + cdi, data=df3, 
                trControl = control_train, method='rf'
               ) 

cm_rf2 = confusionMatrix(model_g)


#---------- create dataframe


métricas = data.frame(matrix(, nrow=2, ncol=11))
row.names(métricas) = c('Logit',  'FA')
colnames(métricas) = c("Acurácia", "CPC", "EPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



métricas[1, ] = metrics(cm_lg2)
métricas[2, ] = metrics(cm_rf2)


métricas = round( métricas, 4)

comrav = t(métricas)






###############################################################################################
#                                     Somente  RAV
###############################################################################################

# LOGIT


model_m = train(as.factor(crise2) ~  rexc, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial',
                maxit=200) 


cm_lg3 = confusionMatrix(model_m)




# RF


model_r = train(as.factor(crise2) ~ rexc, data=df3,
                trControl = control_train,
                method='rf') 


cm_rf3 = confusionMatrix(model_r)




#---------- create dataframe


métricas = data.frame(matrix(, nrow=2, ncol=11))
row.names(métricas) = c('Logit',  'FA')
colnames(métricas) = c("Acurácia", "CPC", "EPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



métricas[1, ] = metrics(cm_lg3)
métricas[2, ] = metrics(cm_rf3)


métricas = round( métricas, 4)

sorav = t(métricas)




semrav
comrav
sorav

tt = merge.data.frame(semrav, comrav, by=0, all=T, sort = F)

rownames(tt) = tt$Row.names
tt = tt[,-1]

tab = merge.data.frame(tt, sorav, by=0, all=T, sort = F)
rownames(tab) = tab$Row.names
tab = tab[,-1]



print(xtable(tab, type = "latex", digits=4), file = "tab1.tex")



###########


m1 = glm(crise2~as.numeric(df6$rexc), data=df6, family = 'binomial')

summary(m1)


m2 = glm(crise2~as.numeric(df6$rexc) + gold + cdi + cb + oil + as.numeric(embi), data=df6, family = 'binomial')

summary(m2)





library(randomForest)

rf = randomForest(as.factor(crise2) ~ rexc   + oil +  cdi + cb + embi + gold, data=df6)
rf


importance(rf)
varImpPlot(rf, sort = T)





