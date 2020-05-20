#--------------------------------------------------------------------------------------------
#                                  Happiness panel
#---------------------------------------------------------------------------------------------

# see: http://www.sthda.com/english/wiki/be-awesome-in-ggplot2-a-practical-guide-to-be-highly-effective-r-software-and-data-visualization


setwd("D:/Git projects/college_works/monitoring_macro")

library(ggplot2)
library(haven)


df <- read_dta("happy.dta")



attach(df)

f1 = df[year>2010, ]
#f1 = na.omit(f1)

#--------------------------- GRAPHS


g1 = ggplot(data = f1, aes(x= hc, y=cresppc, 
          colour=rendacod, size=lld, 
          alpha=I(0.5)))+geom_point()
g1

g2 = g1+facet_grid(.~year)+
  scale_color_gradientn(colours = rainbow(4))+
  labs(color='Classificação \nde renda', size='Cantril \nLadder', 
       x='Capital Humano', y= 'Taxa de crescimento do PIB per capita')+
  theme(axis.title.x= element_text(colour = 'black', size = 10),
       axis.title.y = element_text(colour = 'black', size =10) )

  
windows()
g2



## Happiness and GPD



f2 = df[year==2011, ]

g3 = ggplot(data = f2, aes(x=ppc/10000, y=lld, 
                    alpha=I(0.5)))+
                    geom_text(aes(label=CountryCode), size=4)


                        
g4 = g3 + geom_smooth(method = 'lm',formula = y~x, color='black', se=F) +
          ggtitle('Happiness and GPD per capita') + 
          xlab('GPD per capita') +
          ylab('Cantrill Ladder') +
          theme(axis.title.x = element_text(colour = 'black', size=13),
                axis.title.y = element_text(colour = 'black', size=13),
                plot.title = element_text(hjust = 0.5))

windows()
g4


##### using gini

f3 = df[year==2011 & ginigallup <=0.5, ]


g5 = ggplot(data = f3, aes(x=ginigallup, y=lld, 
                           alpha=I(0.5)))+
  geom_text(aes(label=CountryCode), size=4)



g6 = g5 + geom_smooth(method = 'lm',formula = y~x, color='black', se=F) +
  ggtitle('Happiness and Gini') + 
  xlab('Gini') +
  ylab('Cantrill Ladder') +
  theme(axis.title.x = element_text(colour = 'black', size=13),
        axis.title.y = element_text(colour = 'black', size=13),
        plot.title = element_text(hjust = 0.5))

windows()
g6




##### using HC



f2 = df[year==2011, ]


g7 = ggplot(data = f3, aes(x=hc, y=lld, 
                           alpha=I(0.5)))+
  geom_text(aes(label=CountryCode), size=4)



g8 = g7 + geom_smooth(method = 'lm',formula = y~x, color='black', se=F) +
  ggtitle('Happiness and HC') + 
  xlab('HC') +
  ylab('Cantrill Ladder') +
  theme(axis.title.x = element_text(colour = 'black', size=13),
        axis.title.y = element_text(colour = 'black', size=13),
        plot.title = element_text(hjust = 0.5))

windows()
g8


### PPC and HC


f2 = df[(year==2015)&(ppc/10000>=0.08)&(rendacod==1|rendacod==4), ]



g9 = ggplot(data = f2, aes(x=hc, y=ppc/10000))+
          ylim(-0.001, 10.2) +
          geom_smooth(method = 'lm',formula = y~x, color='black', se=F) +
          geom_text(aes(label=CountryCode), size=4)


g10 = g9 + 
  ggtitle('PIB per capita and HC') + 
  xlab('Human capital') +
  ylab('PIB per capita') +
  theme(axis.title.x = element_text(colour = 'black', size=13),
        axis.title.y = element_text(colour = 'black', size=13),
        plot.title = element_text(hjust = 0.5))

windows()
g10


##### PPC and Institutional quality


g11 = ggplot(data = f2, aes(x=qinst, y=ppc/10000))+
  geom_smooth(method = 'lm',formula = y~x, color='black', se=F) +
  geom_text(aes(label=CountryCode), size=4)


g12 = g11 + 
  ggtitle('PIB per capita and Institutional Quality') + 
  xlab('Institutional Quality') +
  ylab('PIB per capita') +
  theme(axis.title.x = element_text(colour = 'black', size=13),
        axis.title.y = element_text(colour = 'black', size=13),
        plot.title = element_text(hjust = 0.5))

windows()
g12


##### PPC and population growth


g13 = ggplot(data = f2, aes(x=crespop, y=ppc/10000))+
  xlim(-0.009, 0.04) +
  geom_smooth(method = 'lm',formula = y~x, color='black', se=F) +
  geom_text(aes(label=CountryCode), size=4)


g14 = g13 + 
  ggtitle('PIB per capita and Population Growth') + 
  xlab('Population Growth') +
  ylab('PIB per capita') +
  theme(axis.title.x = element_text(colour = 'black', size=13),
        axis.title.y = element_text(colour = 'black', size=13),
        plot.title = element_text(hjust = 0.5))

windows()
g14


##### PPC and FBCF



g15 = ggplot(data = f2, aes(x=lld, y=ppc/10000))+
  ylim(-0.001, 10.2) +
  geom_smooth(method = 'lm',formula = y~x, color='black', se=F) +
  geom_text(aes(label=CountryCode), size=4)


g16 = g15 + 
  ggtitle('PIB per capita and Life Satisfaction') + 
  xlab('Life Satisfaction') +
  ylab('PIB per capita') +
  theme(axis.title.x = element_text(colour = 'black', size=13),
        axis.title.y = element_text(colour = 'black', size=13),
        plot.title = element_text(hjust = 0.5))

windows()
g16

library("ggpubr")


ggarrange(g10, g12, g14, g16)




























