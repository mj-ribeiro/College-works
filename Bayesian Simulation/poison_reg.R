#****************************************************************************************
#                                 Poison regression         
#*******************************************************************************************


setwd("D:/Git projects/college_works/Bayesian Simulation")

library('COUNT')

data("badhealth")



head(badhealth)

# check nan

any(is.na(badhealth))


# histogram

hist(badhealth$numvisit, breaks = 20, col = 'lightgreen', probability = T)



# plot

plot(jitter(log(numvisit))~ jitter(age), data=badhealth, subset =badh==0&numvisit>0 )
points(jitter(log(numvisit))~ jitter(age), data=badhealth, subset =badh==1&numvisit>0, col='red' )



# rjags


library(rjags)

mod_string = 'model{
  for (i in 1:length(numvisit)) {
    numvisit[i] ~ dpois(lam[i])
    log(lam[i]) = int + b_badh*badh[i] + b_age*age[i] + b_intx*age[i]*badh[i]
  }
  
  int ~ dnorm(0, 1/1e6)
  b_badh ~ dnorm(0, 1/1e4)
  b_age ~ dnorm(0, 1/1e4)
  b_intx ~ dnorm(0, 1/1e4)
  
}'


set.seed(102)

data_jags = as.list(badhealth)

params = c('int', 'b_badh', 'b_age', 'b_intx')


mod = jags.model(textConnection(mod_string), 
                 data=data_jags, n.chains = 3)


update(mod, 1e3)



mod_sim = coda.samples(model = mod, 
                       variable.names = params,
                       n.iter = 5e3)

mod_csim = as.mcmc(do.call(rbind, mod_sim))


# convergence diagnostics

windows()
plot(mod_sim)


gelman.diag(mod_sim)
gelman.plot(mod_sim)


dic = dic.samples(mod, n.iter = 3)




pmed = apply(mod_csim, 2, median)

pmed











