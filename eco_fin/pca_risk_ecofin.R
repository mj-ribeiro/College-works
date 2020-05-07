#**************************************************************************************
#                       PCA with risk aversion index
#****************************************************************************************

setwd("D:/Git projects/Finance/Finance_R")

#--------- Libraries

library(tseries)
library(timeSeries)
library(fGarch)
library(quantmod)



#----------- My function to get data


get_data = function(x, d= "2000-01-01"){
  z = getSymbols(x, src='yahoo', 
                  from= d, 
                  periodicity = "monthly",    
                  auto.assign = F)[,4]
  return(z)
}






#-------  know data availability



ativos = c('ITUB4.SA',
'VALE3.SA',
'BBDC4.SA',
'PETR4.SA',
'B3SA3.SA',
'PETR3.SA',
'ABEV3.SA',
'BBAS3.SA',
'ITSA4.SA',
'LREN3.SA',
'JBSS3.SA',
'BBDC3.SA',
'IRBR3.SA',
'GNDI3.SA',
'MGLU3.SA',
'SUZB3.SA',
'BRFS3.SA',
'UGPA3.SA',
'RENT3.SA',
'RAIL3.SA',
'WEGE3.SA',
'BBSE3.SA',
'RADL3.SA',
'VIVT4.SA',
'EQTL3.SA',
'BRDT3.SA',
'GGBR4.SA',
'CCRO3.SA',
'SBSP3.SA',
'LAME4.SA',
'COGN3.SA',
'SULA11.SA',
'AZUL4.SA',
'SANB11.SA',
'BRML3.SA',
'EMBR3.SA',
'HAPV3.SA',
'HYPE3.SA',
'BPAC11.SA',
'NTCO3.SA',
'PCAR4.SA',
'YDUQ3.SA',
'EGIE3.SA',
'CMIG4.SA',
'VVAR3.SA',
'TIMP3.SA',
'BTOW3.SA',
'KLBN11.SA',
'ELET3.SA',
'QUAL3.SA',
'CSAN3.SA',
'TOTS3.SA',
'CIEL3.SA',
'CRFB3.SA',
'CSNA3.SA',
'FLRY3.SA',
'MULT3.SA',
'ELET6.SA',
'CYRE3.SA',
'BRAP4.SA',
'BRKM5.SA',
'TAEE11.SA',
'ENBR3.SA',
'GOAU4.SA',
'MRVE3.SA',
'CVCB3.SA',
'USIM5.SA',
'GOLL4.SA',
'IGTA3.SA',
'HGTX3.SA',
'MRFG3.SA',
'ECOR3.SA',
'SMLS3.SA')


#  Getting assets with date since 2000


know_data = function(z){
  k= get_data(z)
  s = index(k)[1]
  return(s)
}


t = c()
for (i in ativos) {
#  print(know_data(i))
  t[i] = know_data(i)
}

View(t)


# convert t to a date format

library(zoo)
out = as.Date(t)

out = sort(out)    # sort by date

out = data.frame(out)

View(out)


sort_names = rownames(out)

sort_names[1:23]  # assets that date begin in 2000-01-01



#----------- Getting this assets


assets = sort_names[1:23]
assets

df = data.frame(lapply(assets, get_data))

basicStats(df)


# Replace nas by mean

for(i in 1:length(df)){
  df[ ,i] = ifelse(is.na(df[,i]), 
            (mean(df[,i], na.rm = T)),
             df[,i] )
}

basicStats(df)


nl = sum((df[,1]>0)*1)

df = df[-nl,]

nl = sum((df[,1]>0)*1)


# calculating returs



ret = data.frame(matrix(nrow =(nl-1), ncol=length(assets)))



for(i in 1:length(assets)){
  ret[ ,i] = diff(log(df[,i]))
}

colnames(ret) = assets


#------------- Aplying PCA algorithm


library(caret)  

pca = preProcess(x= ret, method = 'pca', pcaComp = 1)
pca = predict(pca, ret)



# create data sequence

data = seq(as.Date("2000-2-1"), as.Date("2020-4-1"), by = "month")



ret = xts(ret, order.by = data)
pca = xts(pca, order.by = data)


View(assets)
# Plot first component

plot(pca$V1, type='l')


# save in RDS file

saveRDS(pca, 'pca.rds')


  
  
  
  
