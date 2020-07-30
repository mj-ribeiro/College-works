#------------------------------------------------------------------------------------------------
#                                
#==============================================================================================

#see: https://d3c33hcgiwev3.cloudfront.net/_d181a1c584869f3756752c70046374d3_lesson_05.html?Expires=1594512000&Signature=Fn0KJ01ZI7P69g6I9dYF46eNSLnm8HUigGUKxG7Txw9uYTE7Ci1WKHU17RLrLvR1SoLoYaGp9whG0olHOkpxGNltyKd7GyAJMKcsl~PFQcgRi4vr-3gKZHED6PSIzue3ldu3CBywKvsR9DT1l1yDZw~4RPWMHx9wltLyC82FYpk_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A

setwd("D:/Git projects/college_works/Bayesian Simulation")


data('PlantGrowth')
attach(PlantGrowth)

# summary data

head(PlantGrowth)

tail(PlantGrowth)

table(PlantGrowth$group)

PlantGrowth$group = as.factor(PlantGrowth$group)

by(weight, group, summary)


# boxplot

boxplot(weight~group, col='lightgreen')


# regression 


reg =  lm(weight ~ group)
summary(reg)

anova(reg)


# bayesian model


library(rjags)




mod_str = "model{
  for(i in 1:length(y)){
    y[i] ~ dnorm(mu[grp[i]], prec)
  }
  for(j in 1:3){
    mu[j] ~ dnorm(0.0, 1.0/1.0e6)
  }
  prec ~ dgamma(5/2.0, 5*1.0/2.0)
  sig = sqrt(1.0/ prec)
}"


set.seed(82)

str(PlantGrowth)
data_jags = list(y= PlantGrowth$weight,
                 grp=as.numeric(PlantGrowth$group))


params = c('mu', 'sig')


inits = function(){
  inits = list('mu'=rnorm(3,0, 100), 
               'prec'=rgamma(1, 1, 1))
}


mod = jags.model(textConnection(mod_str),
                 data=data_jags,
                 inits = inits,
                 n.chains = 3)


mod_sim = coda.samples(model=mod,
                       variable.names = params,
                       n.iter = 5e4)


mod_csim = as.mcmc(do.call(rbind, mod_sim))


# diagnostics

windows()
plot(mod_csim)



gelman.diag(mod_sim)

autocorr.diag(mod_sim)

effectiveSize(mod_sim)


# compare models 


parm = colMeans(mod_csim)

reg$coefficients



yhat = parm[1:3][data_jags$grp]

resid = data_jags$y - yhat



plot(resid, col='blue', pch=19)


plot(yhat, resid, col='lightgreen', pch=19)



# summary model


summary(mod_sim)

HPDinterval(mod_csim)

