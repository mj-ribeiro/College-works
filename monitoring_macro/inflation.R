#==============================================================================================
#                             Phillips Curve
#==============================================================================================

setwd("D:/Git projects/college_works/monitoring_macro")


library(GetBCBData)
library('xts')


# inflation

inf = gbcbd_get_series(433, first.date= '1981-01-01', last.date = '2020-04-01',  
                      format.data = "long", be.quiet = FALSE)[ ,1:2]

data = inf$ref.date
inf[,1]=NULL
colnames(inf) = 'inf'
inf = xts(inf, order.by = data)


# diff inflation

dinf = diff(inf)
colnames(dinf) = 'dinf'


# unemployment

des = gbcbd_get_series(24369, first.date= '1981-01-01', last.date = '2020-04-01',  
                       format.data = "long", be.quiet = FALSE)[ ,1:2]


data1 = des$ref.date
des[,1]=NULL
colnames(des) = 'des'
des = xts(des, order.by = data1)




## plots

library(ggplot2)

df = data.frame(des, dinf[index(des)])

windows()
g1 = ggplot(data = df, aes(x = `des`, y =`dinf`), alpha=0.5)

g1 + geom_point(color='blue', size=2) + ggtitle('Phillips Curve')



# reg


reg1 = lm(dinf ~ des, data = df[1:40,])
summary(reg1)









                    





