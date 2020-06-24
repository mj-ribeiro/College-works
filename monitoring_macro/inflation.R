#==============================================================================================
#                                  Phillips Curve
#==============================================================================================

setwd("D:/Git projects/college_works/monitoring_macro")

# see : https://www.scielo.br/scielo.php?script=sci_arttext&pid=S0101-41612017000100039


library(GetBCBData)
library('xts')


# inflation - Índice nacional de preços ao consumidor-amplo (IPCA)  (variação % )


inf = gbcbd_get_series(433, first.date= '1981-01-01', last.date = '2020-04-01',  
                      format.data = "long", be.quiet = FALSE)[ ,1:2]

data = inf$ref.date
inf[,1]=NULL
colnames(inf) = 'inf'
inf = xts(inf, order.by = data)

plot(inf)


# unemployment  - Taxa de desocupação - PNADC


des = gbcbd_get_series(24369, first.date= '1981-01-01', last.date = '2020-04-01',  
                       format.data = "long", be.quiet = FALSE)[ ,1:2]


data1 = des$ref.date
des[,1]=NULL
colnames(des) = 'des'
des = xts(des, order.by = data1)


plot(des)

## plots

library(ggplot2)



df = data.frame(des, inf[index(des)])



windows()
g1 = ggplot(data = df[1:40,], aes(x = `des`, y =`inf`), alpha=0.5)

g1 + geom_point(color='blue', size=2) + 
  ggtitle('Phillips Curve') + 
  geom_smooth(method = 'lm',formula = y~x, color='black') +
  xlab('Unemployment') +
  ylab('Rate of change in inflation') +
  theme(axis.title.x = element_text(colour = 'black', size=13),
        axis.title.y = element_text(colour = 'black', size=13),
        plot.title = element_text(hjust = 0.5))



# reg

df/100

reg1 = lm(inf ~ des, data = (df/100))
summary(reg1)






                    





