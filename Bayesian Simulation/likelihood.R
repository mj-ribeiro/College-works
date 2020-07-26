#-----------------------------------------------------------------------------------------------------
#                                         Likelihood
#=====================================================================================================


setwd("D:/Git projects/college_works/Bayesian Simulation")



y = c(2.850, 3.105, 5.693, 8.101, 10.387)
x = c(0, 1, 2, 3, 4)

n = length(y)
sig = sd(y)

beta = 1
g = 1/(n*sig) * sum(x*y) - beta/(n*sig)*sum(x^2) 
h = -1/(n*sig) * sum(x^2)


tol = 1/1e5

while (g > tol){
  g = 1/(n*sig) * sum(x*y) - beta/(n*sig)*sum(x^2) 
  h = -1/(n*sig) * sum(x^2)
  beta = beta - g/h
  cat('\033[1;035mbeta:', round(beta, 4), 'gradiente:', round(g, 4), '\n')
}




# other way 

reg = lm(y~x+0)

summary(reg)

(t(x)%*%x)^-1%*%(x)%*%y




