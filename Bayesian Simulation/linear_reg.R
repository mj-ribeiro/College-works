#------------------------------------------------------------------------------------------------
#                                Metropolis Hastings
#==============================================================================================

#see: https://d3c33hcgiwev3.cloudfront.net/_caf094bf3db01507bea6305d040883e4_lesson_04.html?Expires=1594252800&Signature=B-XiirBnF2dx1HIxsaxGncbRSB6jldC1ExZ~OSkqMURxzLkh0-7PSLGWQOpzbL-~eEqfAv8~4y91yrKFkQsgZgAYFQSYZdGF7DfleriZCwcnQhme~hf5Ym4Mf1Hvx4AMYMlJ0Sh2fYu4khSLMbuQER6Ej9CqqibkoyBlAlDDJP8_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A


setwd("D:/Git projects/college_works/Bayesian Simulation")


library(car)

data('Leinhardt')

head(Leinhardt)

str(Leinhardt)


# plots

pairs(Leinhardt)

plot(infant ~ income, data=Leinhardt)

hist(Leinhardt$infant)

hist(Leinhardt$income)


# log 

Leinhardt$linfant = log(Leinhardt$infant)
Leinhardt$lincome = log(Leinhardt$income)

plot(linfant ~ lincome, data=Leinhardt)

hist(Leinhardt$linfant)



# regression

reg = lm(linfant ~ lincome, data=Leinhardt)
summary(reg)


library('olsrr')
reg0 = ols_regress(linfant ~ lincome, data=Leinhardt)


dat = na.omit(Leinhardt)



# using rjags

library("rjags")


mod1_string = "model{
  for(i in 1:n){
    y[i] ~ dnorm(mu[i], prec)
    mu[i] = b[1] + b[2]*log_income[i]
  }
  for(j in 1:2){
    b[j] ~ dnorm(0, 1.0/1.0e6)
  }
  prec ~ dgamma(5/2, 5*10/2)
  sig2 = 1.0/prec
  sig = sqrt(sig2)
}"


set.seed(72)

data1_jags = list(y=dat$linfant, n=nrow(dat), log_income= dat$lincome)


params1 = c("b", "sig")


inits1 = function(){
  inits = list("b"=rnorm(2, 0.0, 100.0), "prec"=rgamma(1, 1.0, 1.0))
}


mod1 = jags.model(textConnection(mod1_string), data = data1_jags, 
                   inits = inits1, n.chains = 3)



update(mod1, 1000)


mod1_sim = coda.samples(model=mod1,
                        variable.names = params1,
                        n.iter = 5e3)


mod1_csim = do.call(rbind, mod1_sim)





# plots' model

windows()
plot(mod1_sim)


# diagnostics

gelman.diag(mod1_sim)

autocorr.diag(mod1_sim)


effectiveSize(mod1_sim)

summary(mod1_sim)


