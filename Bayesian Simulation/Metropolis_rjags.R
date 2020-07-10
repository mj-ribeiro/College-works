#------------------------------------------------------------------------------------------------
#                                Metropolis Hastings
#==============================================================================================

#see: https://d3c33hcgiwev3.cloudfront.net/_caf094bf3db01507bea6305d040883e4_lesson_04.html?Expires=1594252800&Signature=B-XiirBnF2dx1HIxsaxGncbRSB6jldC1ExZ~OSkqMURxzLkh0-7PSLGWQOpzbL-~eEqfAv8~4y91yrKFkQsgZgAYFQSYZdGF7DfleriZCwcnQhme~hf5Ym4Mf1Hvx4AMYMlJ0Sh2fYu4khSLMbuQER6Ej9CqqibkoyBlAlDDJP8_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A


setwd("D:/Git projects/college_works/Bayesian Simulation")



library('rjags')


# specify the model

mod = " model{
  for(i in 1:n){
    y[i] ~ dnorm(mu, 1.0/sig2)
  }
  mu ~ dt(0.0, 1.0/1.0, 1)
  sig2 = 1.0
} "


# set up the model
set.seed(50)

y = c(1.2, 1.4, -0.5, 0.3, 0.9, 2.3, 1.0, 0.1, 1.3, 1.9)

n = length(y)

data_jags = list(y=y, n=n)
params = c('mu')

inits = function(){
  inits = list('mu'= 0.0)
}

mod = jags.model(textConnection(mod), 
                 data = data_jags,
                 inits = inits)



# Run MCMC

update(mod, 500)


mod_sim = coda.samples(model = mod,
                       variable.names = params,
                       n.iter = 1000)


# Post processing
library(coda)


plot(mod_sim)
summary(mod_sim)


