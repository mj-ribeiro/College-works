# -*- coding: utf-8 -*-
"""
Created on Sat Sep 19 09:21:20 2020

@author: Marcos J Ribeiro
"""
import os
os.chdir('D:/Git projects/college_works/Macroeconomic')

import numpy as np
import matplotlib.pyplot as plt


# Utility function 

def util(c):
    return c


# Define parameters

def pars():
    global N, y, beta, theta, p, b, w_min, w_max, w_grid, s, v
    N = 4
    y = 50
    beta = 0.9
    theta = 0.2
    p = np.array((0, 1/8, 3/8, 3/8, 1/8))
    b = 0   # seguro desemprego
    
    w_min, w_max = 0, 50
    w_grid = [i*y/N for i in range (N+1)]
    
    s = np.zeros(N+1, dtype = np.int)
    v = np.zeros(N+1)


# Objective

pars()


def Bellman_op():
    global s, v
    Tv = np.zeros(N+1)
    norm, tol = 1, 1e-6    
    while norm > tol:
        for i_w, w in enumerate(w_grid):
            
            a = [0, 1]
            accept = util((1-a[0])*w) + beta*( (1-theta)*v[i_w] + theta*v[0] )
            reject = util((1-a[1])*w) + sum([p[i_ww]*v[i_ww] for i_ww in range(N+1)])
            
            if accept>reject:
                s[i_w] = 1
                Tv[i_w] = accept
            else:
                s[i_w] = 0
                Tv[i_w] = reject
            norm = np.abs(np.max(Tv - v))
            v = np.copy(Tv)
    return v, s
           

Bellman_op() 


# plot solution

# w_grid and s            

plt.plot(w_grid, s, 'o', markersize=13, color='red', label='s')       
plt.xlabel('W_grid', fontsize=20)
plt.ylabel('Accept (1) or Reject (0)', fontsize=20) 
plt.xticks(fontsize=18)            
plt.yticks(fontsize=18)            
plt.legend( loc='best', fontsize=18)           
plt.gca().twinx().plot(w_grid, v, label='v(w)')
plt.gca().set_ylabel('$v(w)$', fontsize=20)
plt.gca().tick_params(labelsize=18)
plt.legend(fontsize=18, loc=(0.01, 0.8)) 
plt.tight_layout()          


# w_grid and distribution

plt.plot(w_grid, p)
plt.xlabel('w_grid', fontsize=20)
plt.ylabel('Distribution of w', fontsize=20) 
plt.xticks(fontsize=18)            
plt.yticks(fontsize=18)            















            


            
            






 






















