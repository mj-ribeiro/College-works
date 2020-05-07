#***********************************************************************************************
#                                     GARCH-Volatility
#***********************************************************************************************

setwd("D:/Git projects/Finance/Finance_R")


#--- Libraries


library(tseries)
library(timeSeries)
library(forecast)   # auto.arima
library(quantmod)
library(fGarch)
library(rugarch)

#---- Get data


ibov = getSymbols('^BVSP', src='yahoo', 
                  from= '1999-12-01', 
                  to = '2020-04-01',
                  periodicity = "monthly",    # IBOV mensal
                  auto.assign = F)[,4]


#----- returns


ret = diff(log(ibov))
colnames(ret) = c('ret')

ret = ret[is.na(ret)==F]  # Drop na to work



#---- GARCH Model

spec1 = ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(3,4)), 
                   mean.model=list(armaOrder=c(0,0), include.mean=TRUE),  
                   distribution.model="norm")


garch2 = ugarchfit(spec = spec1, data= ret)

garch2

ts.plot(sigma(garch2))


plot(ret**2)



