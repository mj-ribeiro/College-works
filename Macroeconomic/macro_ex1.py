# -*- coding: utf-8 -*-
"""
Created on Sat Aug 15 12:40:17 2020
@author: Marcos J Ribeiro
"""

import numpy as np
import matplotlib.pyplot as plt



# Define parameters

def pars():
    global sig, beta, pi, a_max, a_min, n_a, a_grid,  y_min, y_max, n_y, y_grid, V
    sig = 2
    beta = 0.99
    pi = np.array(([2/3, 1/3], [1/3, 2/3]))    
    a_min, a_max, n_a =  -0, 5, 5
    a_grid = np.linspace(a_min, a_max, n_a)    
    y_min, y_max, n_y = 10, 20, 2
    y_grid = np.linspace(y_min, y_max, n_y)    
    V = np.zeros( (n_y, n_a) )
    
pars()



## utility function


def util(x):
    return ( x**(1-sig) -1)/(1-sig)


## Quantity of assets

q = 1


## Objective function

def f_obj(V):
    obj = np.zeros( (n_y, n_a, n_a) )
    for i_y in range(n_y):
        y = y_grid[i_y]
        for i_a, a in enumerate(a_grid):
            for i_aa, aa in enumerate(a_grid):
                c =  y + a - q*aa 
                if c <= 0:
                    obj[i_y, i_a, i_aa] = -np.inf
                else:
                    obj[i_y, i_a, i_aa] = util(c) + beta*(np.dot(pi[i_y,:],V[:, i_aa]) )
    return obj



## TV

def TV_TG(obj):
    global T_iG, TV
    TV = np.zeros( (n_y, n_a) )
    T_iG = np.zeros( (n_y, n_a) , dtype=np.int )
    for i_y in range(n_y):
        for i_a in range(n_a):
            TV[i_y, i_a] = np.max(obj[i_y, i_a, :])
            T_iG[i_y, i_a] = np.argmax(obj[i_y, i_a, :])
    return TV, T_iG



## Convergence

def compute_V_and_G():
    global V, iG
    norm, tol = 1, 1e-5
    cont = 0
    while norm>tol:
        F_OBJ = f_obj(V)
        TV, T_iG = TV_TG(F_OBJ)
        norm = np.max(abs(TV-V))
        V = np.copy(TV)
        iG = np.copy(T_iG)
        cont = cont + 1
        
        if cont%10 == 0:
            print(f'\033[1;033mnorma = {np.around(norm, 4)}, iter = {cont}')
            print('  ')
            print('TV= ', np.around(TV, 4))
            print('  ')
    return V, iG



## Run

pars()
%time compute_V_and_G()



## Policy function

"""
a: quantity of assets
g(a): policy function    
"""

    
for ii in range(n_y):
    print('\033[1;033m='*50)
    print(' {:>20} {:>1} '.format('y =', y_grid[ii]) )
    print('='*50)
    for tt, vv in enumerate(T_iG[ii,:]):
        print(f'a = {a_grid[tt]:.<31} g(a) = { np.around(a_grid[vv], 4 )} ')




### Vectorize code



## Objective

def f_obj2(V):   
    
    Tv = np.array(())
    
    a = np.array(a_grid).repeat(n_a).reshape(n_a, n_a)
    aa = np.array(a_grid).repeat(n_a).reshape(n_a, n_a).T
    
    for i_y, kk in enumerate(y_grid):
        y = kk
        c = y + a - np.multiply(q, aa)
        
        obj = util(c) + beta*(np.dot(pi[i_y, :], V ))
        
        max_row = np.amax(obj, axis=1)         
        
        Tv = np.concatenate((Tv, max_row), axis=0 )
    Tv = Tv.reshape(n_y, n_a)
        
    return Tv   



### Solve

pars()

def sol():
    global V
    norma, tol = 1, 1e-5    
    while norma>tol:
        Tv = f_obj2(V)
        norma = np.max(abs(Tv - V))
        V = np.copy(Tv)
        print('norma=', norma)

%time sol()     #more faster









