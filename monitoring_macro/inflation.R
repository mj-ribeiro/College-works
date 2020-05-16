#==============================================================================================
#                             Phillips Curve
#==============================================================================================

setwd("D:/Git projects/college_works/monitoring_macro")

# see : https://www.scielo.br/scielo.php?script=sci_arttext&pid=S0101-41612017000100039


library(GetBCBData)
library('xts')


# inflation - Índice nacional de preços ao consumidor-amplo (IPCA)


inf = gbcbd_get_series(433, first.date= '1981-01-01', last.date = '2020-04-01',  
                      format.data = "long", be.quiet = FALSE)[ ,1:2]

data = inf$ref.date
inf[,1]=NULL
colnames(inf) = 'inf'
inf = xts(inf, order.by = data)


# diff inflation

dinf = diff(inf)
colnames(dinf) = 'dinf'



# unemployment  - Taxa de desocupação - PNADC


des = gbcbd_get_series(24369, first.date= '1981-01-01', last.date = '2020-04-01',  
                       format.data = "long", be.quiet = FALSE)[ ,1:2]


data1 = des$ref.date
des[,1]=NULL
colnames(des) = 'des'
des = xts(des, order.by = data1)




## plots

library(ggplot2)

df = data.frame(des, dinf[index(des)],inf[index(des)])


data3 = index(inf)
dfinf = data.frame(data3, inf)
ggplot(data=dfinf, aes(y=`inf`, x=`data3`), alpha=0.5)+geom_line()



windows()
g1 = ggplot(data = df[1:40,], aes(x = `des`, y =`dinf`), alpha=0.5)

g1 + geom_point(color='blue', size=2) + 
  ggtitle('Phillips Curve') + 
  geom_smooth(method = 'lm',formula = y~x, color='black') +
  xlab('Unemployment') +
  ylab('Rate of change in inflation') +
  theme(axis.title.x = element_text(colour = 'black', size=13),
        axis.title.y = element_text(colour = 'black', size=13),
        plot.title = element_text(hjust = 0.5))



# reg


reg1 = lm(dinf ~ des, data = df[1:40,])
summary(reg1)



# arima

reg2 = arima(inf, order=c(1,1,0))
reg2





                    





