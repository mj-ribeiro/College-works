#-----------------------------------------------------------------------------------------------------
#                                         Likelihood
#=====================================================================================================


# see: https://rpubs.com/YaRrr/MLTutorial

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






## with intercept


y2 = c(2.850, 3.105, 5.693, 8.101, 10.387, 3, 44, 5.5, 0.8)
x2 = c(3, 6, 12, 3, 1.4, 0.9, -1, 22, 4.3)



mv_reg = function(y2, x2){
  
  sig2 = sd(y2)
  T = length(x2)
  
  beta1 = 1
  beta2 = 0.2
  B = rbind(beta1, beta2)
  
  g1 = 1/(T*sig2) *sum(y2 - beta1 - beta2*x2)
  h1 = -1/(sig2)
  
  g2 = 1/(T*sig2) * sum(y2*x2 - beta1*x2 - beta2*x2^2) 
  h2 = -1/(T*sig2) * sum(x2^2)
  
  G = rbind(g1, g2)
  H = matrix(c(h1, 0, 0, h2), nrow = 2, ncol = 2)
  
  
  tol = 1/1e4
  l = 0.1
  
  while (tol < max(G)){
    beta1 = B[1]
    beta2 = B[2]
    
    L = 1/2*log(2/pi) - 1/2*log(sig2) - 1/(2*sig2*T)*sum( (y2 - beta1 - beta2*x2)^2)
    
    
    g1 = 1/(T*sig2) *sum(y2 - beta1 - beta2*x2)
    h1 = -1/(sig2)
    
    g2 = 1/(T*sig2) * sum(y2*x2 - beta1*x2 - beta2*x2^2) 
    h2 = -1/(T*sig2) * sum(x2^2)
    
    G = rbind(g1, g2)
    
    H = matrix(c(h1, 0, 0, h2), nrow = 2, ncol = 2)
  
    B = B - l*solve(H)%*%G
    
    cat('G:', G, 'L:', L, '\n')
    
  }
  cat('\n')
  cat('The gradient is given by:\n', G)
  cat('\n Hessian is given by: \n', H)
  cat('\n The parameters are given by: \n', B)
}



mv_reg(y, x)



reg2 = lm(y~x)
reg2




  