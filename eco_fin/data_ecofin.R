#**************************************************************************************
#                              Volatility index
#****************************************************************************************

setwd("D:/Git projects/college_works/eco_fin")


#------------- CMAX Function

# w é o tamanho da janela
# n é a quantidade de janelas
# s é o vetor que vou passar a função


CMAX = function(w, n, s){
  
  l = matrix(nrow=n,ncol = (w+1))
  max = matrix(nrow=n, ncol = 1)
  cmax = matrix(nrow=n, ncol = 1)
  
  for (j in 1:n){
    
    l[j, 1:(w+1)] = s[j:(w+j)]
    max[j] = max(l[j, 1:(w+1)])
    
    cmax[j] = l[j, (w+1)]/max(max[j])
  }
  return(cmax)
}



#### get first day

firstDayMonth=function(x)
{           
  x=as.Date(as.character(x))
  day = format(x,format="%d")
  monthYr = format(x,format="%Y-%m")
  y = tapply(day,monthYr, min)
  first=as.Date(paste(row.names(y),y,sep="-"))
  #as.factor(first)
  as.Date(first)
}




# Libraries

library(lubridate)
library(tseries)
library(timeSeries)
library(quantmod)
library(fGarch)
library(GetBCBData)

library(ipeadatar)
library(knitr);
library(tidyr);
library(dplyr);
library(DT);
library(magrittr)
library(data.table)




# Get data

ibov = getSymbols('^BVSP', src='yahoo', 
                  from= '1999-01-01', 
                  to = '2020-05-01',
                  periodicity = "monthly",    # IBOV mensal
                  auto.assign = F)[,4]


colnames(ibov) = 'ibov'
ibov = ibov[is.na(ibov)==F]



# VIX

vix = getSymbols('^VIX', src='yahoo', 
                 periodicity = "monthly",
                 from= '2000-01-01', 
                 to = '2020-05-01',
                 auto.assign = F)[,4]

colnames(vix) = 'vix'


# Oil price


oil = getSymbols('CL=F', src='yahoo', 
                 periodicity = "monthly",
                 from= '2000-01-01', 
                 to = '2020-05-01',
                 auto.assign = F)[,4]

colnames(oil) = 'oil'



# Gold price


gold = getSymbols('GC=F', src='yahoo', 
                 periodicity = "monthly",
                 from= '2000-01-01', 
                 to = '2020-05-01',
                 auto.assign = F)[,4]

colnames(gold) = 'gold'




# 11768 - Índice da taxa de câmbio real (INPC)


cb = gbcbd_get_series(11768, first.date= '2000-01-01', last.date = '2020-05-01',  
                      format.data = "long", be.quiet = FALSE)[ ,1:2]

data = cb$ref.date
cb[,1]=NULL
cb = xts(cb, order.by = data)

rownames(cb) = data    # colocar a data como índice

colnames(cb) = 'cb'


# cdi


cdi = gbcbd_get_series(4391, first.date= '2000-01-01', last.date = '2020-05-01',  
                       format.data = "long", be.quiet = FALSE)[ ,1:2]

data = cdi$ref.date
cdi[,1]= NULL
cdi = xts(cdi, order.by = data)

rownames(cdi) = data    # colocar a data como índice

colnames(cdi) = 'cdi'


## EMBI


embi_search = as.data.frame(search_series(terms = c('EMBI'), fields = c("name"),language = c("br")))
embi_search %<>% dplyr::slice(1:500L)
datatable(embi_search)


embi = ipeadata(c('JPM366_EMBI366'))[,2:3]
colnames(embi) = c('date', 'embi')

embi$date = as.Date(embi$date)
mday(embi$date) = 1



k= firstDayMonth(embi$date)
k = as.Date(k)




mday(k) = 1   # transformar os dias do vetor de datas k em 1 (lubridate)


k = as.data.frame(k)

colnames(k) = 'date'



setDT(embi)
setDT(k)


embi = embi[k, on = c('date')]


embi = xts(embi, order.by = embi$date)
embi = embi[,-1]





# returns



ret = diff(log(ibov))


ret = ret[is.na(ret)==F]
colnames(ret) = 'ret'



#------ Using CMAX function


cm2 = CMAX(12,(length(ibov)-12), ibov )

var1 = quantile(cm2, 0.05)
var2 = quantile(cm2, 0.1)


hist(cm2, breaks = 15, col='lightgreen', 
     probability = T,
     main='Histograma para o CMAX diário \n com 24 janelas')
abline(v=var1)


lim = mean(cm2)-2*sd(cm2)


cm2[cm2<lim]
sum((cm2<lim)*1)   # count 


# get the data of ibov

data = index(ibov)
data1 = data[13:length(ibov)]



# transform cmax in xts object

cmts = xts(x=cm2, order.by = data1) 



#----- Plot CMAX  using ggplot2



library(ggplot2)

windows()


g1 = ggplot(data=cmts, aes(y=`cmts`, x=`data1`))+geom_line(size=1)+
  scale_x_date(date_labels="%Y",date_breaks  ="1 year")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=17), 
      axis.text.y = element_text(size=17) ) + 
  ylim(0.4, 1) +
  xlab('Anos') + ylab('CMAX') + 
  #ggtitle('Evolução do CMAX do Ibovespa mensal')+
  theme(axis.title.x = element_text(colour = 'black', size=19),
        axis.title.y = element_text(colour = 'black', size=19))
        #plot.title = element_text(hjust = 0.5, size = 17))




g2 = g1 +
        annotate(geom='text', x=as.Date('2008-10-10'), y=0.47, label= 'Crise \n de 2008', size=6) +
        annotate(geom='text', x=as.Date('2020-03-10'), y=0.58, label = 'Crise do \n COVID-19', size=6) + 
        #annotate(geom='text', x=as.Date('2000-03-10'), y=0.6, label = 'Bolha da \n internet') +
        annotate(geom='text', x=as.Date('2001-9-13'), y=0.58, label = '11 de \n setembro', size=6) +
        geom_hline(yintercept =var2, size=1)
        


g2 



plot(as.vector(cmts), type='l')
abline(h=var2)



#----- Create Dummy

# var1

crise = matrix(nrow = length(cmts))

crise = ifelse(cm2<var1, 1, 0)

pos = which(crise==1)   # pegar a posição onde crise== 1
pos


for(i in 2:length(pos)){
  crise[(pos[i]-12):pos[i]] = 1
}


table(crise)
prop.table(table(crise))



crise = xts(crise, order.by = data1)



# var2


crise2 = matrix(nrow = length(cmts))

crise2 = ifelse(cm2<var2, 1, 0)

pos2 = which(crise2==1)   # pegar a posição onde crise== 1
pos2


for(i in 2:length(pos2)){
  crise2[(pos2[i]-12):pos2[i]] = 1
}



pos2

table(crise)

par(mfrow=(c(1,2)))

plot(as.vector(1-cmts), type='l', ylim=c(0,1))
lines(as.vector(crise))


plot(as.vector(1-cmts), type='l', ylim=c(0,1))
lines(crise2)



#---- create data frame

data = index(cmts)

crise = xts(crise, order.by = data)
crise2 = xts(crise, order.by = data)

cb = cb[data]
vix = vix[data]


data = index(cb)
oil =oil[data]
vix = vix[data]
crise = crise[data] 
cdi = cdi[data]
ret = ret[data]
gold = gold[data]
embi = embi[data]



# transform data in data frame

df = data.frame(ret, vix, cb, crise, cdi, embi, crise2)

df = merge(df, gold, by='row.names')
d = df$Row.names

df$Row.names = NULL

row.names(df) = d


df = merge(df, oil, by='row.names')

d = df$Row.names

df$Row.names = NULL

row.names(df) = d




#df = data.frame(date=index(index(cb)), coredata(df))

#df$date = NULL


### save in rds file

saveRDS(df, 'df.rds')





