#***********************************************************************************************
#                                   Algorithms without rav
#***********************************************************************************************

setwd("D:/Git projects/college_works/eco_fin")


# functions


metrics = function(cm){
  acurácia = (cm[["table"]][1,1] + cm[["table"]][2,2])/sum(cm[["table"]])
  sensibilidade = cm[["table"]][1,1] / ( cm[["table"]][1,1] + cm[["table"]][2,1] )  
  especificidade = cm[["table"]][2,2] /( cm[["table"]][2,2] + cm[["table"]][1,2] )
  G = sqrt(sensibilidade*especificidade)
  LP = sensibilidade/(1 - especificidade)
  LR = (1 - sensibilidade)/(especificidade)
  DP = sqrt(3)/pi * ( log(sensibilidade/(1 - sensibilidade) ) + log( especificidade/(1 - especificidade) )  )
  gamma = sensibilidade - (1 - especificidade)
  BA = (1/2) * (sensibilidade + especificidade)
  métricas = data.frame(acurácia, sensibilidade, especificidade, G, LP, LR, DP, gamma, BA)
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
df1$embi = as.numeric(df1$embi)


keep = c('crise2', 'gold',  'embi',  'oil', 'cb', 'rexc',  'cdi')

df6 = df1[,keep]


library(xlsx)
write.xlsx(df6, 'data.xlsx')

### correlation

correl = round(cor(df6[,-1]), 4 )
print(xtable(correl, type = "latex", digits=4), file = "correl.tex")



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


####### ROC


x_h = evalm(model_h)

roc_rf1 = data.frame( x_h$roc$data[,c(2,1)] ) 

roc_lg1$feature="Logit"
roc_rf1$feature="FAs"

m_sav = rbind(roc_lg1, roc_rf1)


roc1 = ggplot(m_sav, aes(FPR, SENS, colour=feature)) +
          geom_line(size=0.8) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
          theme_minimal() +
          theme(axis.text.x = element_text(hjust = 1, size=17), 
                axis.text.y = element_text(size=17), 
                axis.title.x = element_text(colour = 'black', size=17),
                axis.title.y = element_text(colour = 'black', size=17),
                legend.title=element_blank(),
                legend.text = element_text(colour="black", size = 17),
                plot.title = element_text(hjust = 0.5, size=19)) +
          xlab('1 - Especificidade') + 
          ylab('Sensibilidade') +
          ggtitle('Sem AV')







############# create dataframe



metricas = data.frame(matrix(, nrow=2, ncol=9))
row.names(metricas) = c('Logit',  'FA')
colnames(metricas) = c("Acurácia", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



metricas[1, ] = metrics(cm_lg1)
metricas[2, ] = metrics(cm_rf1)


metricas = round( metricas, 4)

semrav = t(metricas)







###############################################################################################
#                                     Com  RAV
###############################################################################################



#----- LOGIT


model_c = train(as.factor(crise2) ~  gold + embi + oil + cb + rexc + cdi, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial',
                maxit=200) 


cm_lg2 = confusionMatrix(model_c)


x_c = evalm(model_c)


roc_lg2 = data.frame( x_c$roc$data[,c(2,1)] ) 



#------- RF



model_g = train(as.factor(crise2) ~  gold + embi + oil + cb + rexc + cdi, data=df3, 
                trControl = control_train, method='rf'
               ) 

cm_rf2 = confusionMatrix(model_g)



################ ROC


x_g = evalm(model_g)

roc_rf2 = data.frame( x_g$roc$data[,c(2,1)] ) 


roc_lg2$feature="Logit"
roc_rf2$feature="FAs"

m_sav2 = rbind(roc_lg2, roc_rf2)


roc2 = ggplot(m_sav2, aes(FPR, SENS, colour=feature)) +
          geom_line(size=0.8) +
          scale_y_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
          scale_x_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
          theme_minimal() +
          theme(axis.text.x = element_text(hjust = 1, size=17), 
                axis.text.y = element_text(size=17), 
                axis.title.x = element_text(colour = 'black', size=17),
                axis.title.y = element_text(colour = 'black', size=17),
                legend.title=element_blank(),
                legend.text = element_text(colour="black", size = 17),
                plot.title = element_text(hjust = 0.5, size=19) )  + 
          xlab('1 - Especificidade') + 
          ylab('Sensibilidade') +
          ggtitle('Com AV')
    

############# create dataframe


metricas = data.frame(matrix(, nrow=2, ncol=9))
row.names(metricas) = c('Logit',  'FA')
colnames(metricas) = c("Acurácia", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



metricas[1, ] = metrics(cm_lg2)
metricas[2, ] = metrics(cm_rf2)


metricas = round( metricas, 4)

comrav = t(metricas)






###############################################################################################
#                                     Somente  RAV
###############################################################################################

#---------- LOGIT


model_m = train(as.factor(crise2) ~  rexc, data=df3, 
                trControl = control_train, 
                method='multinom', 
                family='binomial',
                maxit=200) 


cm_lg3 = confusionMatrix(model_m)



x_m = evalm(model_m)


roc_lg3 = data.frame( x_m$roc$data[,c(2,1)] ) 




#---------- RF


model_r = train(as.factor(crise2) ~ rexc, data=df3,
                trControl = control_train,
                method='rf') 


cm_rf3 = confusionMatrix(model_r)




########### ROC


x_r = evalm(model_r)

roc_rf3 = data.frame( x_r$roc$data[,c(2,1)] ) 


roc_lg3$feature="Logit"
roc_rf3$feature="FAs"

m_sav3 = rbind(roc_lg3, roc_rf3)


roc3 = ggplot(m_sav3, aes(FPR, SENS, colour=feature)) +
  geom_line(size=0.8) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
  scale_x_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
  theme_minimal() +
  theme(axis.text.x = element_text( hjust = 1, size=17), 
        axis.text.y = element_text(size=17), 
        axis.title.x = element_text(colour = 'black', size=17),
        axis.title.y = element_text(colour = 'black', size=17),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size = 17),
        plot.title = element_text(hjust = 0.5, size=19)) + 
  xlab('1 - Especificidade') + 
  ylab('Sensibilidade') +
  ggtitle('Somente AV')



############ create dataframe



metricas = data.frame(matrix(, nrow=2, ncol=9))
row.names(metricas) = c('Logit',  'FA')
colnames(metricas) = c("Acurácia", "Sensibilidade", "Especificidade", "G", "LP", "LR", "DP", "gamma", "BA")          



metricas[1, ] = metrics(cm_lg3)
metricas[2, ] = metrics(cm_rf3)


metricas = round( metricas, 4)

sorav = t(metricas)




######## Join dataframe


semrav
comrav
sorav

tt = merge.data.frame(semrav, comrav, by=0, all=T, sort = F)

rownames(tt) = tt$Row.names
tt = tt[,-1]

tab = merge.data.frame(tt, sorav, by=0, all=T, sort = F)
rownames(tab) = tab$Row.names
tab = tab[,-1]

tab

print(xtable(tab, type = "latex", digits=4), file = "tab1.tex")



########### Join ROC 





library("ggpubr")

g_roc = ggarrange(roc1, roc2, roc3, nrow=1, 
                  common.legend = T, 
                  legend = 'bottom')



saveRDS(g_roc, 'roc_curve.rds')


ggsave(g_roc, file="fig4.eps", device="eps", height=8, width=12)

g_roc


#### Logit traditional


m1 = glm(crise2~as.numeric(df6$rexc), data=df6, family = 'binomial')

summary(m1)

plot(df6$rexc, type = 'l')

m2 = glm(crise2~as.numeric(df6$rexc) + gold + cdi + cb + oil + as.numeric(embi) - 1, data=df6, family = 'binomial')

summary(m2)

print(xtable(m2, type = "latex", digits=4), file = "reg1.tex")


#### Importance plots

library(randomForest)

rf = randomForest(as.factor(crise2) ~ rexc   + oil +  cdi + cb + embi + gold, data=df6, importance=T)
rf

imp = rf$importance

imp[1, 4] = 19.5254
r_names = c('AV', 'Petroleo', 'CDI', 'INPC', 'EMBI', 'Ouro')

length(imp)
length(r_names)

row.names(imp) = r_names

imp = imp[,4]


imp = data.frame(imp)
colnames(imp) = 'variáveis'


vimp = ggplot(imp, aes(variáveis, r_names) ) +
        geom_point(size=2, col='blue') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=17), 
        axis.text.y = element_text(size=17), 
        axis.title.x = element_text(colour = 'black', size=19),
        axis.title.y = element_text(colour = 'black', size=19),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size = 17),
        legend.position="bottom" ) + 
  xlab('Diminuição média no Gini') + 
  ylab('variáveis')  

vimp


#see https://www.youtube.com/watch?v=Zze7SKuz9QQ



df3

