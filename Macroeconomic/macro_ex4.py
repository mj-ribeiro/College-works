# -*- coding: utf-8 -*-
"""
Created on Tue Sep 22 09:56:51 2020

@author: Marcos J Ribeiro
"""

import os
os.chdir('D:/Git projects/college_works/Macroeconomic')

import numpy as np
import matplotlib.pyplot as plt




def pars():
    global tau, T, sig, beta, delta, alpha, pi, n_y, n_a, y_grid, a_grid, V, iG
    
    tau, T = 0, 0
    sig, beta, delta, alpha = 3, 0.95, 0.08, 0.44
    pi = np.array(([2/3, 1/3],
                   [1/3, 2/3]))
    
    y_min, y_max, n_y = 1e-2, 2, len(pi)
    y_grid = np.linspace(y_max, y_min, n_y)
    
    a_min, a_max, n_a = 0, 20, 15
    a_grid = np.linspace(a_max, a_min, n_a)
    
    V = np.zeros((n_y, n_a))
    iG = np.zeros((n_y, n_a))


pars()
    
### Utility function

util = lambda x: (x**sig - 1)/ (1 - sig)




### capital por trabalhador

def compute_k():
    return (alpha/(r + delta) )**(1/(1-alpha))


### salário

def compute_w(k):
    return (1-alpha)*(k**alpha) 


### tx de juros

def compute_r(K):
    global L
    return alpha*((K/L)**(alpha-1)) - delta


### Obj

def obj_f(V, r):
    
    F_obj = np.zeros((n_y, n_a, n_a))
    k = compute_k()
    w = compute_w(k)    
    
    for i_y, y in enumerate(y_grid):
        for i_a, a in enumerate(a_grid):
            for i_aa, aa in enumerate(a_grid):
                
                c = w*y  + (1 + (1 - tau)*r)*a + T - aa 
                
                if c<=0:
                    F_obj[i_y, i_a, i_aa] = -np.inf
                
                else: 
                    F_obj[i_y, i_a, i_aa] = util(c) + beta*(np.dot(pi[i_y, :], V[:, i_aa] ))
    return F_obj
                    
                    
### Tv & iG
                
def Tv_f(obj):
    Tv = np.amax(obj, axis=1)
    Tg = np.argmax(obj, axis=1)
    
    return Tv, Tg
                    
                
                    
### Solve

def solve1():
    norm, tol = 1, 1e-6
    while norm>tol:
    
        obj = obj_f(V, r)
        Tv, Tg = Tv_f(obj)
        norm = np.max(np.abs(Tv - V))
        
        V = np.copy(Tv)
        iG = np.copy(Tg)
    
    return V, iG




# Transition matrix

def compute_M(iG):
    # States values
    # [ (y_0, a_0), (y_0, a_1), (y_0, a_2), (y_0, a_3), (y_0, a_4) ,
    #   (y_1, a_0), (y_1, a_1), (y_1, a_2), (y_1, a_3), (y_1, a_4) ]
    M = np.zeros( (n_y*n_a, n_y*n_a) )
    
    for i_y in range(n_y):
        for i_a in range(n_a):
            c_state = i_y*n_a+i_a
            for i_yy in range(n_y):
                for i_aa in range(n_a):
                    n_state = i_yy*n_a+i_aa
                    if iG[i_y,i_a] == i_aa:
                        M[c_state, n_state] += pi[i_y,i_yy]
    return M






 




                    












# Utility funtion

def util(c, sig):
    return (c**sig - 1)/ (1 - sig)

















