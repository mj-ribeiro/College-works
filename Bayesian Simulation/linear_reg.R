#------------------------------------------------------------------------------------------------
#                                Linear reg
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



## Add oil variable


mod2_string = "model{
  for(i in 1:length(y)){
    y[i] ~ dnorm(mu[i], prec)
    mu[i] = b[1] + b[2]*log_income[i] + b[3]*is_oil[i]
  }
  for(j in 1:3){
    b[j] ~ dnorm(0.0, 1.0/1.0e6)
  }
  prec ~ dgamma(5/2, 5*10/2)
  sig = sqrt(1/prec)
}"



set.seed(75)

data2_jags = list(y=dat$linfant, 
                  log_income= dat$lincome,
                  is_oil=as.numeric(dat$oil=="yes"))



params2 = c("b", "sig")


inits2 = function(){
  inits = list("b"=rnorm(3, 0.0, 100.0), 
               "prec"=rgamma(1, 1.0, 1.0))
}


mod2 = jags.model(textConnection(mod2_string), 
                  data = data2_jags, 
                  inits = inits2, 
                  n.chains = 3)





update(mod2, 1000)


mod2_sim = coda.samples(model=mod2,
                        variable.names = params2,
                        n.iter = 5e3)


mod2_csim = do.call(rbind, mod2_sim)




# plots' model

windows()
plot(mod2_sim)


# diagnostics

gelman.diag(mod2_sim)

autocorr.diag(mod2_sim)


effectiveSize(mod2_sim)

summary(mod2_sim)





dic.samples(mod1, n.iter = 1e3)

dic.samples(mod2, n.iter = 1e3)  # better model has a lower DIC






