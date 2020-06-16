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
library('randomForest')



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


m�tricas = data.frame(matrix(, nrow=2, ncol=10))
row.names(m�tricas) = c('Logit',  'Random Forests')
colnames(m�tricas) = c("Acur�cia", "CPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



m�tricas[1, ] = metrics(cm_lg1)
m�tricas[2, ] = metrics(cm_rf1)


m�tricas = round( m�tricas, 4)

semrav = t(m�tricas)







###############################################################################################
#                                     Com  RAV
###############################################################################################



# LOGIT


model_c = train(as.factor(crise) ~  gold + embi + oil + cb + av + cdi, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial') 


cm_lg2 = confusionMatrix(model_c)


# RF


model_g = train(as.factor(crise) ~  gold + embi + oil + cb + av + cdi, data=df3, 
                trControl = control_train, method='rf'
               ) 

cm_rf2 = confusionMatrix(model_g)


#---------- create dataframe


m�tricas = data.frame(matrix(, nrow=2, ncol=10))
row.names(m�tricas) = c('Logit',  'Random Forests')
colnames(m�tricas) = c("Acur�cia", "CPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



m�tricas[1, ] = metrics(cm_lg2)
m�tricas[2, ] = metrics(cm_rf2)


m�tricas = round( m�tricas, 4)

comrav = t(m�tricas)






###############################################################################################
#                                     Somente  RAV
###############################################################################################

# LOGIT


model_m = train(as.factor(crise) ~  av, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial') 


cm_lg3 = confusionMatrix(model_m)




# RF


model_r = train(as.factor(crise) ~ av, data=df3,
                trControl = control_train,
                method='rf') 


cm_rf3 = confusionMatrix(model_r)




#---------- create dataframe


m�tricas = data.frame(matrix(, nrow=2, ncol=10))
row.names(m�tricas) = c('Logit',  'Random Forests')
colnames(m�tricas) = c("Acur�cia", "CPC", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



m�tricas[1, ] = metrics(cm_lg3)
m�tricas[2, ] = metrics(cm_rf3)


m�tricas = round( m�tricas, 4)

sorav = t(m�tricas)




semrav
comrav
sorav

tt = merge.data.frame(semrav, comrav, by=0, all=T, sort = F)

rownames(tt) = tt$Row.names
tt = tt[,-1]

tab = merge.data.frame(tt, sorav, by=0, all=T, sort = F)
rownames(tab) = tab$Row.names
tab = tab[,-1]



print(xtable(tab, type = "latex", digits=4), file = "tab.tex")



###########

#############################

df3$av = -as.numeric(df3$av)


summary(df3$av)

model =glm(as.factor(crise) ~  gold  + oil +  cdi +
             as.numeric(av) + cb +
             as.numeric(embi),
           family = 'binomial',  data=df3[-2,])

summary(model)

plot(-3*as.numeric(df$av), type = 'l')
abline(h=0)
lines(df$crise)


plot(df$vix/100, type = 'l', ylim = c(0,1))
abline(h=0)
lines(df$crise)




library(randomForest)

rf = randomForest(as.factor(crise) ~  gold  + oil +  cdi  + embi + cb + av, data=df3)

importance(rf)
varImpPlot(rf)
