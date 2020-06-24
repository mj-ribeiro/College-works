#------------------------------------------------------------------------------------------------
#                                Monte Carlo Integrals
#==============================================================================================

# theta has gamma distribution

  
f = function(a, b){
  theta* b^a/gamma(a) * theta^(a-1)*exp(-b*theta)
}


t_max = 300
t_min = 0
n = 500000

s = 0

for (i in 1:n) {
  theta = runif(1, min=t_min, max=t_max)
  f_ = f(2, 1/3)
  s = s + f_
}


I = (t_max - t_min)/n *s




