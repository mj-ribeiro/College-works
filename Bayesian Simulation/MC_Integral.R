#------------------------------------------------------------------------------------------------
#                                Monte Carlo Integrals
#==============================================================================================

# theta has gamma distribution


setwd("D:/Git projects/college_works/Bayesian Simulation")

  
f = function(a, b){
  theta* b^a/gamma(a) * theta^(a-1)*exp(-b*theta)
}


t_max = 300
t_min = 0
n = 500000

nn = 100
I = c()

for (j in 1:nn) {
  s = 0
  for (i in 1:n) {
    theta = runif(1, min=t_min, max=t_max)
    f_ = f(2, 1/3)
    s = s + f_
  }

  I[j] = (t_max - t_min)/n *s
}


mean(I)
sd(I)


hist(I, breaks = 30, col='lightgreen', main='Histogram of Integral values')




####### Hierarquical model


# simulate phi_i from beta(2,2)
# simulate y_i from binom(10, phi_i)

m = 1e+5

y = numeric(m)
phi = numeric(m)


for(i in 1:m){
  phi[i] = rbeta(1, 2, 2)
  y[i] = rbinom(1, size = 10, phi[i])
  
}



# othe way to do the same thing

#vectorize

phi = rbeta(m, 2, 2)
y = rbinom(m, size = 10, phi)


plot(table(y)/m, main='Beta Binomial distribution of y', ylab='Probability')






# see: https://d3c33hcgiwev3.cloudfront.net/_adadc80290e52a99b282ca9d7c1a41ee_background_MarkovChains.html?Expires=1593216000&Signature=eHP~MD0aQLT7TqSLR7fkmMqS5RjMXGsIGR0PU3HAGv8i-KGlb2Z0T3v8BS5C0GSjZlMbgq5~z26DWUAoCH0RfRloZLsBmTNsWVxnWjjjOjTtIfbIC32bT9rF04TugPv~F99EMtBM20hwjLJE11Y2GrmQgahkdC9EsVBkeSI1-8I_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A







