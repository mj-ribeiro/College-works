# -*- coding: utf-8 -*-
"""
Created on Wed Aug 26 17:34:28 2020

@author: Marcos J Ribeiro
"""

# get libraries


import numpy as np



# define parameters

def pars():
    global pi, beta, r, sig, n_a, n_y, V, iG, y_grid, a_grid, w
    
    pi = np.array(([2/3, 1/3], [1/3, 2/3]))
    beta, r, sig = 0.95, 0.05, 2
    w = 1
    
    bar_A, a_max, n_a = 0, 10, 4
    a_grid = np.linspace(bar_A, a_max, n_a)
    
    y_min, y_max, n_y = 1e-3, 1, len(pi) 
    y_grid = np.linspace(y_min, y_max, n_y)     

    V = np.zeros((n_y, n_a))
    iG = np.zeros((n_y, n_a), dtype=np.int)
    
    
pars()
    
# define utility function

util = lambda c: c**(1-sig) / (1 - sig)


## Objetive function

def Obj():
    F_obj = np.zeros((n_y, n_a, n_a))
    
    for i_y, y in enumerate(y_grid):
        for i_a, a in enumerate(a_grid):
            for i_aa, aa in enumerate(a_grid):
                c = w*y + a - aa/(1+r)
                if c<0:
                    F_obj[i_y, i_a, i_aa] = -np.inf
                else:
                    F_obj[i_y, i_a, i_aa] = util(c) + beta*np.dot(pi[i_y,:], V[:, i_aa])
    return F_obj

np.around(Obj(), 4)


def Tv_TG(obj):
    
    Tv = np.amax(obj, axis=1)
    return Tv

Tv_TG(Obj())



def Tv_TG2(obj):
    Tv = np.zeros((n_y, n_a))
    Tg = np.zeros((n_y, n_a), dtype=np.int)
    
    for i_y in range(n_y):
        for i_a in range(n_a):
            Tv[i_y, i_a] = np.max(obj[i_y, i_a, :])
            Tg[i_y, i_a] = np.argmax(obj[i_y, i_a, :])
    return Tv, Tg
    
Tv_TG2(Obj())
    





    
    
    
    
    