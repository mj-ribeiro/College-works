#*********************************************************************************************
#                                     Summary
#**********************************************************************************************


setwd("D:/Git projects/college_works/eco_fin")


library(ggplot2)
library(reshape2)
library('moments')



# data


df = readRDS('df.rds')
df$av = as.numeric(df$av)

data1 = row.names(df)

data1 = as.Date(data1, format = '%Y-%m-%d')

df$data1 = data1



###### Summary data


mom = function(x){
  Máximo = max(x)
  Mínimo = min(x)
  Média = mean(x)
  Variância = sd(x)
  Curtose = kurtosis(x)
  Assimetria = skewness(x)
  rmom = data.frame(Máximo, Mínimo, Média, Variância, Curtose, Assimetria)
  return(rmom)
}

mom(df$ret)


keep =  c('oil', 'gold', 'av', 'embi', 'cdi', 'cb')
df5 = df[,keep]



