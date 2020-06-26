# -*- coding: utf-8 -*-
"""
Created on Sat May 16 00:14:29 2020

@author: Marcos J Ribeiro
"""

import numpy as np
import matplotlib.pyplot as plt

## Question 1

n= 12
mu = 0.3
z = 0.4
theta=0
un = (mu+z)/1.5
u = un
pi = np.zeros(n) 

for i in range(0,n):
    
    if i>=2:
        u = 0.04
        theta = 1
    if i>=9:
        mu = 0.6
    pi[i] = theta*pi[i-1] + (mu + z) - 1.5*u

plt.plot(pi)

pi




# prova 2 - Q4 - A

n= 6
pi = 0.02
u_t = 0.04


for i in range(n):
    pi = 0.8 - u_t + pi
    print(pi)



# Q4 - B

n= 6
pi = 0.02
u_t = 0.04
ind = 0.6    # com indexação de salários



for i in range(n):
    pi = 1/(1-ind)*(0.8 - u_t) + pi
    print(pi)






