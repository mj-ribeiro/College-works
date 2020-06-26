#------------------------------------------------------------------------------------------------
#                                Markov Chain
#==============================================================================================

# theta has gamma distribution


setwd("D:/Git projects/college_works/Bayesian Simulation")


#----- Discrete MC


# Randon walk is a Markov process


set.seed(34)

n = 100000
x = numeric(n)
phi = -0.6

for (i in 2:n) {
  x[i] = rnorm(1, mean=x[i-1]*phi, sd=1.0)
}

plot.ts(x)


hist(x, freq = F, col = 'lightgreen', ylim = c(0,0.5))
curve(dnorm(x), add=T)
legend(2, 0.6, legend = 'Theoretical\n Stationary Dist.', col='red', lty=1, bty="n")


#----- Continuous MC

# Q is a Markov matrix



Q = matrix(c(0.0, 0.5, 0.0, 0.0, 0.5,
             0.5, 0.0, 0.5, 0.0, 0.0,
             0.0, 0.5, 0.0, 0.5, 0.0,
             0.0, 0.0, 0.5, 0.0, 0.5,
             0.5, 0.0, 0.0, 0.5, 0.0), 
           nrow=5, byrow=TRUE)



# probability of secret number being 3 given the current value is 1  (Two step ahead)


(Q%*%Q)[1,3]



#probability distribution of the your secret number in the distant future, 
#say p(Xt+h|Xt) where h is a large number.


Q5 = Q %*% Q %*% Q %*% Q %*% Q # h=5 steps in the future
round(Q5, 3)



# h=30


Q20 = Q


for(i in 1:20){
  Q20 = Q20%*%Q
  
}

round(Q20, 3)






# h=100


Q100 = Q


for(i in 1:100){
  Q100 = Q100%*%Q
  
}

round(Q100, 3)




# Markov chain has estationary distribution















