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
df$rexc = as.numeric(df$rexc)
df$embi = as.numeric(df$embi)


data1 = row.names(df)

data1 = as.Date(data1, format = '%Y-%m-%d')

df$data1 = data1



###### Summary data


kk = mom(df$ret)



keep =  c('oil', 'gold', 'rexc', 'embi', 'cdi', 'cb')
df5 = df[,keep]

df5$cdi = df5$cdi/100


vna = c('Pétroleo', 'Ouro', 'AV', 'EMBI', 'CDI', 'INPC')




sda =data.frame( matrix(, ncol = 6, nrow = 6) )


colnames(sda) = colnames(kk)
rownames(sda) = vna

sda



for (i in 1:6) {
    sda[i,] = mom(df5[,i])  
}


round(sda,4)


print(xtable(sda, type = "latex", digits=4), file = "sda.tex")






