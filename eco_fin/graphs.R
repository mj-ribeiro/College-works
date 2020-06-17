#*********************************************************************************************
#                                     Data 
#**********************************************************************************************


setwd("D:/Git projects/college_works/eco_fin")


library(ggplot2)




# data


df = readRDS('df.rds')

data1 = row.names(df)

df$data1 = data1

#----- Plot CMAX  using ggplot2



 
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






#### comparision 



par(mfrow=(c(1,2)))

plot(as.vector(1-cmts), type='l', ylim=c(0,1), 
     main='CMAX and Crisis VaR 5%', 
     ylab='CMAX and Crisis')
lines(as.vector(crise))


plot(as.vector(1-cmts), type='l', ylim=c(0,1), 
     main='CMAX and Crisis VaR 10%', 
     ylab='CMAX and Crisis')
lines(crise2)




