#------------------------------------------------------------------------------------------------
#                                Gibbs sampler
#==============================================================================================

#see: https://d3c33hcgiwev3.cloudfront.net/_d181a1c584869f3756752c70046374d3_lesson_05.html?Expires=1594512000&Signature=Fn0KJ01ZI7P69g6I9dYF46eNSLnm8HUigGUKxG7Txw9uYTE7Ci1WKHU17RLrLvR1SoLoYaGp9whG0olHOkpxGNltyKd7GyAJMKcsl~PFQcgRi4vr-3gKZHED6PSIzue3ldu3CBywKvsR9DT1l1yDZw~4RPWMHx9wltLyC82FYpk_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A

setwd("D:/Git projects/college_works/Bayesian Simulation")



update_mu = function(n, ybar, sig2, mu_0, sig2_0){
  sig2_1 = 1/ (n/sig2 + 1/sig2_0)
  mu_1 = sig2_1 * (n * ybar/sig2 + mu_0/ sig2_0)
  rnorm(n=1, mean = mu_1, sd= sqrt(sig2_1))
}




update_sig2 = function(n, y, mu, nu_0, beta_0){
  nu_1 = nu_0 + n / 2
  sumsq = sum( ( y - mu )^2 )
  beta_1 = beta_0 + sumsq / 2
  out_gamma = rgamma(n=1, shape = nu_1, rate=beta_1)
  1 / out_gamma
}




gibbs = function(y, n_iter, init, prior){
  ybar = mean(y)
  n = length(y)
  
  mu_out = numeric(n_iter)
  sig2_out = numeric(n_iter)
  
  mu_now = init$mu
  
for (i in 1:n_iter) {
  
  sig2_now = update_sig2(n=n, y=y, mu=mu_now, nu_0=prior$nu_0, beta_0=prior$beta_0)
  mu_now = update_mu(n=n, ybar=ybar, sig2 = sig2_now, mu_0 = prior$mu_0, sig2_0 = prior$sig2_0)
  
  sig2_out[i] = sig2_now
  mu_out[i] = mu_now
}
  cbind(sig2=sig2_out, mu=mu_out)
  
}




# data

y = c(1.2, 1.4, -0.5, 0.3, 0.9, 2.3, 1.0, 0.1, 1.3, 1.9)

n = length(y)

ybar = mean(y)



# prior


prior = list()

prior$mu_0 = 0.0 
prior$sig2_0 = 1.0

prior$n_0 = 2.0
prior$s2_0 = 1.0

prior$nu_0 = prior$n_0/2
prior$beta_0 = prior$n_0*prior$s2_0 / 2



### histogram 


hist(y, col='lightgreen', xlim=c(-1, 3), freq = F)
curve(dnorm(x=x, mean=prior$mu_0, sd=sqrt(prior$sig2_0)), lty=2, add=T)
points(y, rep(0, n), pch=1)
points(ybar, 0, pch=19)




# simulation


set.seed(53)

init = list()

init$mu = 0.0


post= gibbs(y=y, n_iter = 1e4, init=init, prior=prior)

head(post)
tail(post)


library(coda)

plot(as.mcmc(post))

summary(as.mcmc(post))





# autocorrelation


autocorr.plot(as.mcmc(post[,2]))


autocorr.diag(as.mcmc(post[,2]))


# effective size of chain

effectiveSize(as.mcmc(post[,2]))


raftery.diag(as.mcmc(post[,2]))







