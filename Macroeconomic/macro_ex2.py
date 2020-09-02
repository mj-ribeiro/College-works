# -*- coding: utf-8 -*-
"""
Created on Wed Aug 26 17:34:28 2020

@author: Marcos J Ribeiro
"""

# get libraries


import numpy as np
from scipy.optimize import minimize
import matplotlib.pyplot as plt

import os
os.chdir('D:/Git projects/college_works/Macroeconomic')




# define parameters

def pars():
    global pi, beta, r, sig, gamma, alpha, n_a, n_y, V, iG, y_grid, a_grid, w
    
    pi = np.array(([2/3, 1/3], [1/3, 2/3]))
    beta, r, sig = 0.95, 0.05, 2
    w = 1
    gamma, alpha = 0.04, 0.3
    
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

def Obj(V):
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

np.around(Obj(V), 4)


# def Tv_TG(obj):
#     Tv = np.array(())
#     for i_y in range(n_y):
#         max_row = np.amax(obj[i_y], axis=1)
#         Tv = np.concatenate((Tv, max_row), axis=0)
#     Tv = Tv.reshape(n_y, n_a)
#     return Tv
# Tv_TG(Obj())


# get max and his position

def Tv_TG2(obj):
    Tv = np.zeros((n_y, n_a))
    Tg = np.zeros((n_y, n_a), dtype=np.int)
    
    for i_y in range(n_y):
        for i_a in range(n_a):
            Tv[i_y, i_a] = np.max(obj[i_y, i_a, :])
            Tg[i_y, i_a] = np.argmax(obj[i_y, i_a, :])
    return Tv, Tg
    
Tv_TG2(Obj())
    

## solve problem

def solve():
    global V
    norma, tol = 1, 1e-5
    while norma>tol:    
        obj = Obj(V)
        Tv, Tg = Tv_TG2(obj)        
        norma = abs(np.max(Tv-V))    
        V = np.copy(Tv)
        iG = np.copy(Tg)
    return V, iG

solve()

  
  
## M function


def M_f():                           # Q do modelo
    M = np.zeros((n_y*n_a, n_y*n_a))
    for i_y in range(n_y):
        for i_a in range(n_a):
            c_state = i_y*n_a + i_a
            for i_yy in range(n_y):
                for i_aa in range(n_a):
                    n_state = i_yy*n_a + i_aa
                    if iG[i_y, i_a] == i_aa:
                        M[c_state, n_state] = pi[i_y, i_yy]
    return M
       


## Bar M

def barM_f(M):            # distribuição estacionária de pessoas
    barM = np.ones(n_y*n_a)/(n_y*n_a)
    norma, tol = 1, 1e-5
    while norma>tol:
        T_barM = np.dot(barM, M)
        norma = np.max( abs(T_barM - barM) )
        barM = np.copy(T_barM)
    return barM


 

## poupança agregada

def Ea_f():
    Ea = 0
    for i_y in range(n_y):
        for i_a in range(n_a):
            s_index = iG[i_y, i_a]
            poupanca = a_grid[ s_index ]
            t_index = i_y*n_a + i_a
            tamanho = barM[ t_index ]
            Ea += poupanca*tamanho
    return Ea




## trabalho

def L_f():
    L = 0
    for i_y in range(n_y):
        for i_a in range(n_a):
            oferta_trabalho = y_grid[ i_y ]
            t_index = i_y*n_a + i_a
            tamanho = barM[ t_index ]
            L += oferta_trabalho*tamanho
    return L




## main code

rho = 1/beta - 1
r_grid = np.linspace(-gamma, rho, 10)
d_grid = []
for r in r_grid:

    k = ( alpha/(r+gamma) )**(1/(1-alpha))
    w = (1-alpha)*( k**alpha )
    
    V, iG = solve()
    M = M_f()
    barM = barM_f(M)
    
    Ea = Ea_f()
    L = L_f()
        
    K = k*L    
    d = K - Ea
    d_grid.append( d )




# here I use scipy optimize


def main(r):
    k = ( alpha/(r+gamma) )**(1/(1-alpha))
    w = (1-alpha)*( k**alpha )
    
    V, iG = solve()
    M = M_f()
    barM = barM_f(M)
    
    Ea = Ea_f()
    L = L_f()
        
    K = k*L    
    d = np.abs(K - Ea)
    return d

main(0.03)


minimize(main, 0.5, method='Nelder-Mead')



# graphs

plt.plot(r_grid, d_grid)







    
    
    