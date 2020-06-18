#*********************************************************************************************
#                                     Graphs
#**********************************************************************************************


setwd("D:/Git projects/college_works/eco_fin")


library(ggplot2)
library(reshape2)



# data


df = readRDS('df.rds')
df$av = as.numeric(df$av)

data1 = row.names(df)

data1 = as.Date(data1, format = '%Y-%m-%d')

df$data1 = data1




#----- Plot CMAX  using ggplot2

var2 = quantile(df$cmts, 0.1)


 
windows()


g1 = ggplot(data=df, aes(y=cmts, x=data1))+geom_line(size=0.4) +
  scale_x_date(date_labels="%Y",date_breaks  ="1 year") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=17), 
        axis.text.y = element_text(size=17), 
        axis.title.x = element_text(colour = 'black', size=19),
        axis.title.y = element_text(colour = 'black', size=19) ) + 
  ylim(0.4, 1) +
  xlab('Anos') + 
  ylab('CMAX')  




g2 = g1 +
  annotate(geom='text', x=as.Date('2008-10-10'), y=0.47, label= 'Crise \n de 2008', size=6) +
  annotate(geom='text', x=as.Date('2020-03-10'), y=0.58, label = 'Crise do \n COVID-19', size=6) + 
  #annotate(geom='text', x=as.Date('2000-03-10'), y=0.6, label = 'Bolha da \n internet') +
  annotate(geom='text', x=as.Date('2001-9-13'), y=0.58, label = '11 de \n setembro', size=6) +
  geom_hline(yintercept =var2, size=1)



g2 






#### CMAX and crisis 




ggplot() +
  theme_minimal() +
  geom_line(data=df, aes(y=(1-cmts), x = data1), color='red') +
  geom_line(data=df, aes(y=crise, x = data1), color='blue')  






### crise and AV



df4 = df[, c('crise', 'rexc', 'data1')]

df4$rexc = as.numeric(df4$rexc)
df4$rexc = df4$rexc/100 


df4 <- melt(data = df4, id.vars = "data1")



# plot, using the aesthetics argument 'colour'

g4 = ggplot(data = df4, aes(x = data1, y = value, colour = variable)) +
  geom_line(size=0.4) +
  scale_x_date(date_labels="%Y",date_breaks  ="1 year") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=17), 
        axis.text.y = element_text(size=17), 
        axis.title.x = element_text(colour = 'black', size=19),
        axis.title.y = element_text(colour = 'black', size=19),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size = 17)) + 
  xlab('Anos') + 
  ylab('')  


g5 = g4  + scale_colour_discrete(name="Variáveis",
                         breaks=c("crise", "rexc"),
                         labels=c(expression(D[t]), "AV"))

windows()
g5






### crise2 and AV




df5 = df[, c('crise2', 'rexc', 'data1')]

df5$rexc = as.numeric(df5$rexc)
df5$rexc = df5$rexc/100 


df5 <- melt(data = df5, id.vars = "data1")



g6 = ggplot(data = df5, aes(x = data1, y = value, colour = variable)) +
  geom_line(size=1.0) +
  scale_x_date(date_labels="%Y",date_breaks  ="1 year") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=17), 
        axis.text.y = element_text(size=17), 
        axis.title.x = element_text(colour = 'black', size=19),
        axis.title.y = element_text(colour = 'black', size=19),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size = 17)) + 
  xlab('Anos') + 
  ylab('')  


g7 = g6  + scale_colour_discrete(name="Variáveis",
                                 breaks=c("crise2", "rexc"),
                                 labels=c(expression(D[t]), "AV"))

windows()
g7











