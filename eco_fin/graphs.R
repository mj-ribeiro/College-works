#*********************************************************************************************
#                                     Graphs
#**********************************************************************************************


setwd("D:/Git projects/college_works/eco_fin")

library(latex2exp)
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


 

g1 = ggplot(data=df, aes(y=cmts, x=data1))+
  geom_line(size=0.4) +
  scale_x_date(date_labels="%Y",date_breaks  ="1 year") +
  scale_y_continuous(labels=function(x) 
    format(x, big.mark = ".",
          decimal.mark = ",", 
          scientific = FALSE),
    breaks = seq(0.1, 1, 0.1), 
    limits = c(0.4, 1)) +
  theme_minimal() +
  xlab('Anos') + 
  ylab('CMAX') +
  #ylim(0.4, 1) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=20), 
        axis.text.y = element_text(size=20), 
        axis.title.x = element_text(colour = 'black', size=21),
        axis.title.y = element_text(colour = 'black', size=21) ) 
   

g1



g2 = g1 +
  annotate(geom='text', x=as.Date('2008-10-10'), y=0.47, label= 'Crise \n de 2008', size=8) +
  annotate(geom='text', x=as.Date('2020-02-10'), y=0.58, label = 'Crise do \n COVID-19', size=8) + 
  annotate(geom='text', x=as.Date('2016-03-10'), y=0.68, label = 'Instabilidade \n política', size=8) +
  annotate(geom='text', x=as.Date('2001-9-13'), y=0.58, label = '11 de \n setembro', size=8) +
  geom_hline(yintercept =var2, size=1)



windows()
g2 

ggsave(g2, file="fig1.eps", device="eps", width = 12, height = 8)



quantile(df$cmts, 0.1)




#### CMAX and crisis 




ggplot() +
  theme_minimal() +
  geom_line(data=df, aes(y=(1-cmts), x = data1), color='red') +
  geom_line(data=df, aes(y=crise, x = data1), color='blue')  






### crise and AV

date = function(x){
  format(as.Date(x, format="%d/%m/%Y"),"%Y")
}



t = function(x){
  return (ifelse(x<1.06, x-0.08, x )-1.05)
}


df4 = df[, c('crise2', 'rexc', 'data1')]


df4$rexc = as.numeric(df4$rexc)

df4$rexc = t(df4$rexc)



df4[date(df4$data1)==2015,'rexc' ] = ifelse(
  df4[date(df4$data1)==2015,'rexc' ] < 0,
  -1*df4[date(df4$data1)==2015,'rexc' ],
  df4[date(df4$data1)==2015,'rexc' ])


df$rexc = df4$rexc

plot(df4$rexc, type='l' )
abline(h=0)


df4 <- melt(data = df4, id.vars = "data1")




# plot, using the aesthetics argument 'colour'

g4 = ggplot(data = df4, aes(x = data1, y = value, colour = variable)) +
  geom_line(size=0.8) +
  scale_x_date(date_labels="%Y",date_breaks  ="1 year") +
  scale_y_continuous(labels=function(x) 
    format(x, big.mark = ".",
           decimal.mark = ",", 
           scientific = FALSE)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=20), 
        axis.text.y = element_text(size=20), 
        axis.title.x = element_text(colour = 'black', size=21),
        axis.title.y = element_text(colour = 'black', size=21),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size = 21),
        legend.position="bottom" ) + 
  xlab('Anos') + 
  ylab('')  


g5 = g4  + scale_colour_discrete(name="Variáveis",
                         breaks=c("crise2", "rexc"),
                         labels= unname( TeX(c("D_t", "AV"))) )

windows()
g5




ggsave(g5, file="fig2.eps", device="eps", width = 12, height = 8)





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




### Selected variables 


df$rexc = as.numeric(df$rexc)

# AV

d1 = ggplot(data=df, aes(x = data1, y = rexc)) + 
      geom_line()  +
      scale_x_date(date_labels="%Y",date_breaks  ="2 year") +
     scale_y_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size=18), 
            axis.text.y = element_text(size=18), 
            axis.title.x = element_text(colour = 'black', size=18),
            axis.title.y = element_text(colour = 'black', size=18),
            legend.title=element_blank(),
            legend.text = element_text(colour="black", size=18)) + 
      xlab('Anos') + 
      ylab('AV')  

d1

# CB       

d2 = ggplot(data=df, aes(x = data1, y = cb)) + 
  geom_line()  +
  scale_x_date(date_labels="%Y",date_breaks  ="2 year") +
  scale_y_continuous(breaks = seq(60, 213, by = 20)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=18), 
        axis.text.y = element_text(size=18), 
        axis.title.x = element_text(colour = 'black', size=18),
        axis.title.y = element_text(colour = 'black', size=18),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size=18)) + 
  xlab('Anos') + 
  ylab('INPC')  




# Cdi       

d3 = ggplot(data=df, aes(x = data1, y = cdi)) + 
  geom_line()  +
  scale_x_date(date_labels="%Y",date_breaks  ="2 year") +
  scale_y_continuous(breaks = seq(0.2, 3, by = 0.3), 
                     labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=18), 
        axis.text.y = element_text(size=18), 
        axis.title.x = element_text(colour = 'black', size=18),
        axis.title.y = element_text(colour = 'black', size=18),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size=18)) + 
  xlab('Anos') + 
  ylab('CDI (mensal)')  

d3

# EMBI

df$embi = as.numeric(df$embi)

d4 = ggplot(data=df, aes(x = data1, y = embi)) + 
  geom_line()  +
  scale_x_date(date_labels="%Y",date_breaks  ="2 year") +
  scale_y_continuous(breaks = seq(100, 2300, by = 300)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=18), 
        axis.text.y = element_text(size=18), 
        axis.title.x = element_text(colour = 'black', size=18),
        axis.title.y = element_text(colour = 'black', size=18),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size = 18)) + 
  xlab('Anos') + 
  ylab('EMBI')  


d4

# OIL


d5 = ggplot(data=df, aes(x = data1, y = oil)) + 
  geom_line()  +
  scale_x_date(date_labels="%Y",date_breaks  ="2 year") +
  scale_y_continuous(breaks = seq(10, 130, by = 20)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=18), 
        axis.text.y = element_text(size=18), 
        axis.title.x = element_text(colour = 'black', size=18),
        axis.title.y = element_text(colour = 'black', size=18),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size=18)) + 
  xlab('Anos') + 
  ylab('Petróleo')  


# GOLD


d6 = ggplot(data=df, aes(x = data1, y = gold)) + 
  geom_line()  +
  scale_x_date(date_labels="%Y",date_breaks  ="2 year") +
  scale_y_continuous(breaks = seq(250, 1850, by = 250)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=18), 
        axis.text.y = element_text(size=18), 
        axis.title.x = element_text(colour = 'black', size=18),
        axis.title.y = element_text(colour = 'black', size=18),
        legend.title=element_blank(),
        legend.text = element_text(colour="black", size=18)) + 
  xlab('Anos') + 
  ylab('Ouro')  



library("ggpubr")

G = ggarrange(d5, d6, d1, d4, d3, d2, nrow=3, ncol=2)


ggsave(G, file="fig3.eps", device="eps", height=14, width=12)

G

s =0.8025
e = 0.8311

(sqrt(3)/3.14)*(log(s/(1-s)) + log(e/(1-e)) )








