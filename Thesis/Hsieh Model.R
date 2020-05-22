#======================================================================================
#                               Hsieh Model
#======================================================================================

setwd("D:/Git projects/Finance/Finance_R")

#------------------ defining parameters

beta = 0.69
eta = 0.25
varphi = 0.25
theta = 3.44
rho = 0.19
kappa = 1/(1- eta)
i = 2
r = 4
gamma1 = gamma(1 - ( (theta*(1-rho)) **(-1) )   * (1 - eta)**(-1)  )    
phi = c(0.138, 0.174)



#--------------------------- s - time spent at school   (eq 14)

sf = function(){
  s = matrix(0, i, 1)
  
  for (c in 1:i){
    print(c)
    s[c] = (1 + (1-eta)/ (beta*phi[c]) ) ** (-1)                        
}
  return(s)
}



#------------------------ h_til

s = sf()

h_tilf = function( ){

  h_til = matrix(0, i, r)

  for (c in 1:i){
    for (j in 1:r){    
      h_til[c, j] = ( 1 ** varphi * s[c]**phi[c] * eta**eta )**(1 - eta)**(-1) 
}
}
  return (h_til)
}


#----------------------------------------- Human capital of teachers



w = runif(i*r, 0, 1)
tau_w =  runif(i*r, -1, 1)
tau_h = runif(i*r, -1, 1)

x1 = array( c(tau_w, tau_h, w), dim = c(i, r, 3))



H_trf = function(x1){
  s = sf()
  P = matrix(0, 1, r)
  Ti = matrix(0, i, r)
  S = matrix(0, i, 1)
  N = matrix(0, i, r)
  H = matrix(0, i, r)
  
  for (c in 1:i){
    for (j in 1:r){
    
      S[c] = ( s[c]**phi[c]*eta**eta ) ** kappa
      P[j] = ( ( ( 1 - colSums(x1[ , ,1])[j] ) / ( ( 1 + colSums(x1[ , ,2])[j] )**eta) ) * ( colSums(x1[ , ,3])[j] ) ) ** (theta - kappa)
      Ti[c, j] = ( ( 1 - x1[c, j, 1] ) * x1[c, j, 3] ) ** ( theta - kappa +kappa*eta) 
      N[c, j] = ( 1 + x1[c, j, 2]) ** (eta*theta) 
      
      H[c, j] = ( ( Ti[c, j] * S[c] * gamma1 ) / ( N[c, j] * P[j]) ** (1/(1-varphi*kappa)))  
      
      H_tr = H[i-1, ]
}
}
  return (H_tr)
}


H_tr = matrix(1, nrow = i, ncol = r)


#----------------------------------------- w tilde  (Proposition 1)


w_tilf = function(x1){
  
  w_til = matrix(0, i, r)
  
  for (c in 1:i){
    for (j in 1:r){
      w_til[c, j] = ( (1 - x1[c, j, 1]) / ( (1 + x1[c, j, 2]) ** eta) ) * H_tr[j]**varphi * x1[c, j, 3] * s[c]**phi[c] * (1 - s[c]) ** ( (1- eta) /beta )           
}
}
  return (w_til) 
}





#--------------------------- w_r


w_til = w_tilf(x1)

w_rf = function(){
  w_r = w_til**theta
  w_r = colSums(w_r)
  return(w_r)
}

w_r = w_rf()


#------------------------------------------ p_ir  (eq 19)



p_irf = function(){
    
  p_ir = matrix(0, i, r)
  
  for (c in 1:i){
    for (j in 1:r){
      p_ir[c, j] =( ( w_til[c, j] ) ^ theta ) / w_r[j]
    
}
}
  p_i = colSums(p_ir)
  return (p_ir)
}  


#---------------------------------------  W (eq 27)


Wf = function(x1){
  
  W = matrix(0, i, r)
  
  for (c in 1:i){
    for (j in 1:r){
      W[c, j] = ((1 - s[c])**(-1/beta))/( 1 - x1[c, j, 1] )*gamma1*eta*(w_r[j])**(1/(theta*(1 - eta)))    
}
}
  return (W)

}



#--------- Simulated data 

W_t = rbind(c(0.1, 0.42, 0.33, 0.12), c(0.99, 0.22, 0.154, 0.654))

p_t = rbind(c(0.122, 0.12, 0.132, 0.109), c(0.212, 0.453, 0.3524, 0.114))



# library(readxl)
# 
# W_t = read_excel("W_t.xlsx")
# W_t[1] = NULL
# 
# W_t = as.matrix(W_t)
# 
# #col = colnames(W_t)
# 
# 
# p_t = read_excel("p_t.xlsx")
# p_t[1] = NULL
# 
# p_t = as.matrix(p_t)
# 

#--------------------- OBJECTIVE FUNCTION


p_ir = p_irf()



w =  matrix(runif(i*r, 0, 1), nrow = i, ncol = r)
tau_w = matrix( runif(i*r, -1, 1), nrow = i, ncol = r)
tau_h =  matrix(runif(i*r, -1, 1), nrow = i, ncol = r) 

x1 = array( c(tau_w, tau_h, w), dim = c(i, r, 3))


obj(x1)


obj = function(x1){
  
  x1 = array(x1, dim = c(i, r, 3))
  
  s = sf()
  h_til = h_tilf()
  w_til = w_tilf(x1)
  w_r = w_rf()
  p_ir = p_irf()
  #H_tr = H_trf(x1)
  W = Wf(x1)
    
    g = ( (W - W_t)/ W_t ) ^ 2 + ( (p_ir - p_t)/p_t ) ^ 2
    D = sum(g)
    
    return(D)
}



obj(x1)


sum(g)




#-------------------------- Solve

library('Rsolnp')
library('optimx')



res = optim(x1,      #starting values 
            obj,
            method = 'Nelder-Mead')   #function to optimize
           


x1==res$par

res$par
res$value


#x1 = array( c(tau_w, tau_h, w), dim = c(i, r, 3))



#--------  Bounds


lb_tau_w = matrix( rep(-1000, i*r), nrow = i, ncol = r)
lb_tau_h = matrix( rep(-1000, i*r), nrow = i, ncol = r)
lb_w = matrix( rep(0, i*r), nrow = i, ncol = r)
LB = array(c(lb_tau_h, lb_tau_w, lb_w), dim = c(i, r, 3))


ub_tau_w = matrix( rep(1000, i*r), nrow = i, ncol = r)
ub_tau_h = matrix( rep(1000, i*r), nrow = i, ncol = r)
ub_w = matrix( rep(1000, i*r), nrow = i, ncol = r)
UB = array(c(ub_tau_h, ub_tau_w, ub_w), dim = c(i, r, 3))


eeq = function(x1){
  x1[1, ,1] = x1[1, 1, 1]
  x1[1, ,2] = 0   # tau_h
  x1[ ,r,3] = 1   # w
  
}





res = solnp(x1,      
            obj,
            UB=UB,
            LB=LB)





res$values

res$pars



