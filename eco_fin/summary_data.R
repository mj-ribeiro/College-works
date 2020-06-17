#*********************************************************************************************
#                                     Summary
#**********************************************************************************************

setwd("D:/Git projects/college_works/eco_fin")


#### My functions


mom = function(x){
  Máximo = max(x)
  Mínimo = min(x)
  Média = mean(x)
  Variância = sd(x)
  Curtose = kurtosis(x)
  Assimetria = skewness(x)
  rmom = data.frame(Máximo, Mínimo, Média, Variância, Assimetria, Curtose)
  
}


#### Libraries


library(ggplot2)
library(reshape2)
library(moments)
library(xtable)


#### Get  Data


df = readRDS('df.rds')
df$av = as.numeric(df$av)

data1 = row.names(df)

data1 = as.Date(data1, format = '%Y-%m-%d')

df$data1 = data1



###### Summary data


kk = mom(df$ret)



keep =  c('oil', 'gold', 'av', 'embi', 'cdi', 'cb')
df5 = df[,keep]
df5$embi = as.numeric(df5$embi)


vna = c('Pétroleo', 'Ouro', 'AV', 'EMBI', 'CDI', 'INPC')




sda =data.frame( matrix(, ncol = 6, nrow = 6) )


colnames(sda) = colnames(kk)
rownames(sda) = vna

sda



for (i in 1:6) {
    sda[i,] = mom(df5[,i])  
}


sda


print(xtable(sda, type = "latex", digits=4), file = "sda.tex")






summary(df5$embi)
plot(df5$embi, type='l')




k = c('cdi', 'ret')
d = df[ ,k]

d$cdi = d$cdi/100





write.csv(d, file = "retcdi.csv")

