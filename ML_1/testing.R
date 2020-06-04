
setwd("D:/Git projects/college_works/ML_1")

source("D:/Git projects/college_works/ML_1/Nbayes2_work.R")




#---------- census


library(e1071)

census$education = factor(census$education, levels = c(' 10th', ' 11th', ' 12th', ' 1st-4th', ' 5th-6th', ' 7th-8th', ' 9th', ' Assoc-acdm', ' Assoc-voc', ' Bachelors', ' Doctorate', ' HS-grad', ' Masters', ' Preschool', ' Prof-school', ' Some-college'), labels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16))
census$income = factor(census$income, levels = c(' <=50K', ' >50K'), labels = c(0, 1))
census$occupation = factor(census$occupation, levels = c(' Adm-clerical', ' Armed-Forces', ' Craft-repair', ' Exec-managerial', ' Farming-fishing', ' Handlers-cleaners', ' Machine-op-inspct', ' Other-service', ' Priv-house-serv', ' Prof-specialty', ' Protective-serv', ' Sales', ' Tech-support', ' Transport-moving'), labels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14))


trc = census[1:28000, ]
tstc = census[28001:30162, ] 


clas2 = naiveBayes(x=trc[-3], y = as.factor(trc$income))
prev2 = predict(clas2, newdata = tstc[-3]) 
prev2 = as.factor(prev2)
print(prev2) 






nbp <- 250;
PredA <- seq(min(tstc$education), max(tstc$education), length = nbp)
PredB <- seq(min(tstc$occupation), max(tstc$occupation), length = nbp)
Grid <- expand.grid(PredictorA = PredA, PredictorB = PredB)




  

library('AppliedPredictiveModeling')
library(RColorBrewer)



#------ finance
twoClassColor <- brewer.pal(3,'Set1')[1:2]
names(twoClassColor) <- c('Class1','Class2')


trc2 = find2[1:210, ]
tstc2 = find2[210:231, ] 

library(plyr)


clas3 = naiveBayes(x=find2[-1], y = as.factor(find2$x))

fits = mutate(find2, prev3 = predict(clas3, newdata = find2[-1]) )





nbp <- 250;
PredA <- seq(min(find2$oil), max(find2$oil), length = nbp)
PredB <- seq(min(find2$pca), max(find2$pca), length = nbp)
Grid <- expand.grid(oil = PredA, pca = PredB)


a = predict(clas3,Grid)

library(ggplot2)

regions = ggplot(data = fits, aes(x=oil, y=pca, color =x)) + 
  geom_tile(data = cbind(Grid, x = a), aes(fill = x)) +
  scale_fill_manual(name = 'x', values = twoClassColor) +
  ggtitle("Decision region") + 
  theme(legend.text = element_text(size = 10)) +
  scale_colour_manual(name = 'x', values = twoClassColor)



show(regions)









