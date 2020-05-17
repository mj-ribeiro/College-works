#--------------------------------------------------------------------------------------------
#                                  Happiness panel
#---------------------------------------------------------------------------------------------




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







f2 = df[year==2014, ]

g3 = ggplot(data = f2, aes(x=ppc/10000, y=lld, 
                    alpha=I(0.5)))+
                    geom_text(aes(label=CountryCode), size=4)


                        
g4 = g3 + geom_smooth(method = 'lm',formula = y~x, color='black', se=F) +
          ggtitle('Happiness and Economic Growth') + 
          xlab('GPD per capita') +
          ylab('Cantrill Ladder') +
          theme(axis.title.x = element_text(colour = 'black', size=13),
                axis.title.y = element_text(colour = 'black', size=13),
                plot.title = element_text(hjust = 0.5))

windows()
g4











