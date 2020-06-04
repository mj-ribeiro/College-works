
setwd("D:/Git projects/college_works/ML_1")

source("D:/Git projects/college_works/ML_1/Nbayes2_work.R")




#---------- census

library('AppliedPredictiveModeling')
library('RColorBrewer')
library(ggplot2)
library(plyr)
library(e1071)



#------ finance    oil x pca
 

twoClassColor <- brewer.pal(3,'Set1')[1:2]
names(twoClassColor) <- c('Class1','Class2')




clas3 = naiveBayes(x=find2[-1], y = as.factor(find2$x))

fits = mutate(find2, prev3 = predict(clas3, newdata = find2[-1]) )





nbp <- 250;
PredA <- seq(min(find2$oil), max(find2$oil), length = nbp)
PredB <- seq(min(find2$pca), max(find2$pca), length = nbp)
Grid <- expand.grid(oil = PredA, pca = PredB)


a = predict(clas3,Grid)


regions = ggplot(data = fits, aes(x=oil, y=pca, color =x)) + 
  geom_tile(data = cbind(Grid, x = a), aes(fill = x)) +
  #scale_fill_manual(name = 'x', values = twoClassColor) +
  ggtitle("Decision region") + 
  theme(legend.text = element_text(size = 10)) +
  scale_colour_manual(name ='x', values =twoClassColor)



show(regions)





#------ finance    vix x inpc



clas4 = naiveBayes(x=find3[-1], y = as.factor(find3$x))

fits = mutate(find3, prev4 = predict(clas4, newdata = find3[-1]) )











