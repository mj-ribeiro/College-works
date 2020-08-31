# -*- coding: utf-8 -*-
"""
Created on Mon Aug 31 14:40:56 2020

@author: Marcos J Ribeiro
"""
import os
import numpy as np
import matplotlib.pyplot as plt

os.chdir('D:/Git projects/college_works/Macroeconomic')



def f(x):
    return x**3 - 10*x**2 + 5


x = np.arange(-10, 30, 0.01)

# plot f

plt.plot(x, f(x))
plt.grid(True)


# create bissection function


def bissec(f, x_l, x_h, tol):
    norma = 1.0    
    while norma>tol:
        x_bar = (x_l + x_h)/2 
        
        if f(x_bar)<0:
            x_l = x_bar
        else:
            x_h = x_bar
        norma = abs(x_l - x_h)
        print(f'\033[1;033mNorma = {norma:.6f}, f = {f(x_bar):.6f}')
    

bissec(f, -10, 20, 1e-10)

f(x_h) 



# without while

# FIRST

def bissec2(f, x_l, x_h, tol, step=100):
    norma = 1.0    
    for i in range(step):

        x_bar = (x_l + x_h)/2 
        
        if f(x_bar)<0:
            x_l = x_bar
        else:
            x_h = x_bar
        norma = abs(x_l - x_h)
        print(f'\033[1;033mNorma = {norma:.6f}, f = {f(x_bar):.6f}')

        if norma<tol:
            break
        
bissec2(f, -10, 20, 1e-10)
 

# SECOND


from scipy.optimize import brentq
from scipy.optimize import newton


a = brentq(f, -10, 10)   # brentq find zeros of function


newton(f, 230)   # newton method


 











