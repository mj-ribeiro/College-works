# -*- coding: utf-8 -*-
"""
Created on Mon Aug 31 15:26:22 2020

@author: Marcos J Ribeiro
"""

import os
import numpy as np
import matplotlib.pyplot as plt

os.chdir('D:/Git projects/college_works/Macroeconomic')



# parameters

def pars():
    global beta, sig, delta, alfa, gamma, r, w, pi, n_a, n_y, a_grid, y_grid, V
    beta = 0.98
    sig = 2
    delta = 0.08
    alfa, gamma = 0.44, 0.04
    r, w = 0.05, 1
    pi = np.array(([0.4, 0.5, 0.1],
                   [0.3, 0.2, 0.5],
                   [0.2, 0.4, 0.4]))
    barA, a_max, n_a = 0, 5, 3
    a_grid = np.linspace(barA, a_max, n_a)
    
    y_min, y_max, n_y = 1, 3, 3
    y_grid = np.linspace(y_min, y_max, n_y)
    V = np.zeros((n_y, n_a))

pars()

# Utility Function

util = lambda x: (x**sig - 1)/(1-sig)


## Objective

def obj_f():
    global V
    obj = np.zeros((n_y, n_a, n_a))
 
    for i_y, y in enumerate(y_grid):
        for i_a, a in enumerate(a_grid):
            for i_aa, aa in enumerate(a_grid):    
                c = w*y + a - aa/(1+r)
                if c<=0:
                    obj[i_y, i_a, i_aa] = -np.inf
                else:
                    obj[i_y, i_a, i_aa] = util(c) + beta*np.dot(pi[i_y,:], V[:,i_aa]) 
    return np.around(obj, 1)


## Tv , iG

def Tv_f(obj):
    Tv = np.zeros((n_y, n_a))
    Tg = np.zeros((n_y, n_a), dtype=np.int)
    
    for i_y in range(n_y):
        for i_a in range(n_a):
    
            Tv[i_y, i_a] = np.max(obj[i_y, i_a])
            Tg[i_y, i_a] = np.argmax(obj[i_y, i_a])
            
    return Tv, Tg

obj_f()

Tv_f(obj_f())


a_grid


## Solver


def solve():
    global V
    norma, tol = 1.0, 1e-6    
    while norma>tol:
        obj = obj_f()
        Tv, Tg = Tv_f(obj)
        norma = np.max(abs(Tv-V))
        V = np.copy(Tv)
        iG = np.copy(Tg)
#        print(f'\033[1;033m norma={norma}' )
    return V, iG

 
V, iG = solve()

 

##  Q function

    # States values
    # [ (y_0, a_0), (y_0, a_1), (y_0, a_2),
    #   (y_1, a_0), (y_1, a_1), (y_1, a_2), 
    #   (y_2, a_0), (y_2, a_1), (y_2, a_2) ]

def M_f(iG):
    M = np.zeros((n_y*n_a, n_y*n_a))
    for i_y in range(n_y):
        for i_a in range(n_a):
            c_state = i_y*n_a + i_a
            for i_yy in range(n_y):
                for i_aa, aa in enumerate(a_grid):
                    n_state = i_yy*n_a + i_aa
                    if a_grid[iG[i_y, i_a] ] == aa:  
                        M[c_state, n_state] = pi[i_y, i_yy]
    return M

M = M_f(iG)
M



## BarM

def barM_f(M):
    barM  = np.ones(n_a*n_y)/(n_a*n_y)
    norma_m, tol_m = 1, 1e-6
    
    while norma_m>tol_m:    
        TbarM = np.dot(barM, M)
        norma_m = np.max(abs(TbarM-barM))
        barM = np.copy(TbarM)
    return barM
 


barM = barM_f(M)


## Poupança agregada média da economia

def poup_f():
    Ea = 0 
    for i_y in range(n_y):
        for i_a in range(n_a):
            s_ind = iG[i_y, i_a]
            poup = a_grid[s_ind]
            t_ind = i_y*n_a + i_a
            size = barM[t_ind]
            Ea += poup*size     #
    return Ea





## trabalho

def L_f():
    L = 0
    for i_y in range(n_y):
        for i_a in range(n_a):
            oferta_trabalho = y_grid[ i_y ]
            t_index = i_y*n_a + i_a
            size = barM[ t_index ]
            L += oferta_trabalho*size   
    return L


# solve 
 


def main(r):
    k = ( alfa/(r+gamma) )**(1/(1-alfa))
    w = (1-alfa)*( k**alfa )
    
    V, iG = solve()
    M = M_f(iG)
    barM = barM_f(M)
    
    Ea = poup_f()  # poup. agregada média da economia
    L = L_f()      # oferta de trabalho  
        
    K = k*L       # demanda de capital da firma
    d = abs(K - Ea)
    return d


from scipy.optimize import minimize


sol = minimize(main, 5, method='BFGS')

## bissec  - My algorithm


def main2(r):
    global w
    k = ( alfa/(r+gamma) )**(1/(1-alfa))
    w = (1-alfa)*( k**alfa )
    
    V, iG = solve()
    M = M_f(iG)
    barM = barM_f(M)
    
    Ea = poup_f()
    L = L_f()
        
    K = k*L    
    d = K - Ea
    return d

 

pars()
norma2, tol2 = 1.0, 1e-6
r_l, r_h = 0, 70

while norma2>tol2:
    r_bar = (r_l+r_h)*0.5
    
    if main2(r_bar)>0:
        r_l = r_bar    
    else:
        r_h = r_bar  
        
    norma2 = abs(r_l - r_h)
    print(f'norma2 = {norma2}')
    


main2(r_l)


 
 
 
# plots


r_grid = np.linspace(0, 70,50)
d_grid = main2(r_grid)

 
plt.plot(d_grid, r_grid)
plt.plot(sol.fun, sol.x, marker='o', color='red', markersize=20)
plt.xlabel('Distância', fontsize=20)
plt.ylabel('Juros', fontsize=20)
plt.xticks(fontsize=18)
plt.yticks(fontsize=18)
plt.grid(True)

