# -*- coding: utf-8 -*-
"""
Created on Wed Aug 26 10:42:12 2020

@author: Marcos J Ribeiro
"""

from time import sleep
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize


# I will define parameters

def pars():
    global beta, sig, y, c_grid, n_c
    beta = 0.25
    sig = 2
    y = 1.0 
    n_c = 30
    c_grid = np.arange(0, y, 0.001)


# Objective function

F = lambda c: c**(-sig) - beta*( (y-c)**(-sig) )


pars()


# plots

plt.plot(c_grid, F(c_grid) )
plt.plot( c_grid, np.zeros(len(c_grid)), 'r--')
plt.title('Optimization in grid search', fontsize=20)
plt.xticks(fontsize = 20)
plt.yticks(fontsize = 20)
plt.grid(True)



# Get c that minimize F

pos = np.argmin(abs(F(c_grid)))
c_grid[pos]


#### Bissection method

c_L, c_H = 0.0, y

norma, tol = 1.0, 1e-10

while norma > tol:
    c_hat = (c_L + c_H)/2
    cpo = F(c_hat)
    if cpo>0:
        c_L = c_hat
    else:
        c_H = c_hat
    norma = abs(c_L - c_H) 
#    sleep(0.5)
    print(f'\033[1;033mInterval [ {c_L:.6}, {c_H:.6} ], norm = {np.around(norma, 6)} ')




F2  = lambda c: abs( c**(-sig) - beta*( (y-c)**(-sig) ) )



## Using scipy


print(f'\033[1;033m {minimize(F2, 0.7)}')




