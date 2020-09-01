#**************************************************************************************
#                                     Logit         
#**************************************************************************************

#see: https://d3c33hcgiwev3.cloudfront.net/_d181a1c584869f3756752c70046374d3_lesson_05.html?Expires=1594512000&Signature=Fn0KJ01ZI7P69g6I9dYF46eNSLnm8HUigGUKxG7Txw9uYTE7Ci1WKHU17RLrLvR1SoLoYaGp9whG0olHOkpxGNltyKd7GyAJMKcsl~PFQcgRi4vr-3gKZHED6PSIzue3ldu3CBywKvsR9DT1l1yDZw~4RPWMHx9wltLyC82FYpk_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A

setwd("D:/Git projects/college_works/Bayesian Simulation")



library(boot)


# get data

data('urine')


df = na.omit(urine)


dim(df)


# plot

pairs(df)



# scale dataset

X = scale(df[,-1], scale = T, center = T)


colMeans(X)



# model


library(rjags)


mod1_string = 'model{
  for (i in 1:length(y)){
    y[i] ~ dbern(p[i])
    logit(p[i]) = int + b[1]*gravity[i] +
      b[2]*ph[i] + b[3]*osmo[i] + b[4]*cond[i]+
      b[5]*urea[i] + b[6]*calc[i]
  }
  int ~ dnorm(0.0, 1.0/25)
  for (j in 1:6){
    b[j] ~ ddexp(0.0, sqrt(2.0))
  }
}'


set.seed(92)

data_jags =list(y=df$r, gravity=X[,'gravity'], 
                ph=X[,'ph'], osmo=X[,'osmo'], cond=X[,'cond'],
                urea=X[,'urea'], calc =X[,'calc'])


params = c('int', 'b')

mod1 = jags.model(textConnection(mod1_string), data=data_jags,
                  n.chains = 3)

update(mod1, 1e3)



mod1_sim =  coda.samples(model=mod1, variable.names = params, n.iter = 5e3)

model_csim = as.mcmc(do.call(rbind, mod1_sim))



# diagnostic

windows()
plot(mod1_sim, ask = T)

gelman.diag(mod1_sim)

autocorr.diag(mod1_sim)
autocorr.plot(mod1_sim)
effectiveSize(mod1_sim)


summary(mod1_sim)





# frequentist estimation

reg = glm(r ~ X, data=df, family=binomial(link = 'logit'))
summary(reg)



# prediction


coef =  colMeans(model_csim)

y_hat = 1/(1 + exp(-coef['int'] - X%*%coef[-7]) )    




plot(y_hat, jitter(df$r))


tab = table(y_hat>0.5, df$r)

sum(diag(tab))/sum(tab)











