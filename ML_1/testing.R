
setwd("D:/Git projects/college_works/ML_1")

source("D:/Git projects/college_works/ML_1/Nbayes2_work.R")




#---------- libraries

library('AppliedPredictiveModeling')
library('RColorBrewer')
library(ggplot2)
library(e1071)

library("plyr")
library("dplyr")
library("grid")
library("gridExtra")
library("caret")



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


# limits

regions = ggplot(data = fits, aes(x=oil, y=pca, color =x)) + 
  geom_tile(data = cbind(Grid, x = a), aes(fill = x)) +
  #scale_fill_manual(name = 'x', values = twoClassColor) +
  ggtitle("Decision region") + 
  theme(legend.text = element_text(size = 10)) +
  scale_colour_manual(name ='x', values =twoClassColor)

show(regions)


# bounds



bound = ggplot(data = fits, aes(x=oil, y=pca, color =as.factor(x) )) +
  geom_contour(data = cbind(Grid, x = a), aes(z = as.numeric (x) ), 
  color='red', breaks = c(1.5)) + 
  geom_point(size = 4, alpha = .5)  +
  ggtitle("Decision boundaries") +
  theme(legend.text = element_text(size = 10)) 
  

bound

grid.arrange(regions, bound, nrow=2)
  
  



#------ finance    vix x inpc



clas4 = naiveBayes(x=find3[-1], y = as.factor(find3$x))

fits2 = mutate(find3, prev4 = predict(clas4, newdata = find3[-1]) )



nbp <- 250;
PredA <- seq(min(find3$cb), max(find3$cb), length = nbp)
PredB <- seq(min(find3$vix), max(find3$vix), length = nbp)
Grid2 <- expand.grid(cb = PredA, vix = PredB)


b = predict(clas4,Grid2)







regions2 = ggplot(data = fits2, aes(x=cb, y=vix, color =x)) 
  geom_tile(data = cbind(Grid2, x = b), aes(fill = x)) +
  #scale_fill_manual(name = 'x', values = twoClassColor) +
  ggtitle("Decision region") + 
  theme(legend.text = element_text(size = 10)) +
  scale_colour_manual(name ='x', values =twoClassColor)



show(regions2)





