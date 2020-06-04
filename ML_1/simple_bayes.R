#--------------------------------------------------------------------------------------------
#                                 Simple Bayes
#--------------------------------------------------------------------------------------------



setwd("D:/Git projects/college_works/ML_1")





teste <- read.csv("teste.csv")


attach(teste)


fator = as.factor(sex)


# I want classifier the height=6, weight=130, foot=8

#---------- Male

pm = 0.5



m1 = by(teste$height,fator,mean)[2]
v1 = by(height,fator,sd)[2]


phm = dnorm(6, m1, v1)

m2 = by(weight,fator,mean)[2]
v2 = by(weight,fator,sd)[2]

pwm = dnorm(130, m2, v2)



m3 = by(foot,fator,mean)[2]
v3 = by(foot,fator,sd)[2]

pfm = dnorm(8, m3, v3)



PM = pm*phm*pwm*pfm


PM
#------ Female

pf = 0.5



m1f = by(height,fator,mean)[1]
v1f = by(height,fator,sd)[1]


phf = dnorm(6, m1f, v1f)


m2f = by(weight,fator,mean)[1]
v2f = by(weight,fator,sd)[1]

pwf = dnorm(130, m2f, v2f)



m3f = by(foot,fator,mean)[1]
v3f = by(foot,fator,sd)[1]

pff = dnorm(8, m3f, v3f)



PF = pf*phf*pwf*pff




PF/sum(PM,PF)   # This new individual is female




#-----------


m1 = by(teste$height,fator,mean)[2]
v1 = by(height,fator,sd)[2]


phm = dnorm(6, m1, v1)

m2 = by(weight,fator,mean)[2]
v2 = by(weight,fator,sd)[2]

pwm = dnorm(130, m2, v2)



PM = pm*phm*pwm














