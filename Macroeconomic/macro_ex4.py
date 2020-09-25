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
    global r, tau, T, sig, beta, delta, alpha, pi, n_y, n_a, y_grid, a_grid, V, iG
    
    r = 0.05
    tau, T = 0, 0
    sig, beta, delta, alpha = 3, 0.95, 0.08, 0.44
    pi = np.array(([2/3, 1/3],
                   [1/3, 2/3]))
    
    y_min, y_max, n_y = 1e-2, 2, len(pi)
    y_grid = np.linspace(y_max, y_min, n_y)
    
    a_min, a_max, n_a = 0, 20, 15
    a_grid = np.linspace(a_max, a_min, n_a)
    
    V = np.zeros((n_y, n_a))
    iG = np.zeros((n_y, n_a), dtype=np.int)


pars()
    
### Utility function

util = lambda x: (x**sig - 1)/ (1 - sig)




### capital por trabalhador

def compute_k(r):
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
    global w, T, tau
    F_obj = np.zeros((n_y, n_a, n_a))
    k = compute_k(r)
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
    Tv = np.zeros((n_y, n_a))
    Tg = np.zeros((n_y, n_a), dtype=np.int)
    
    for i_y in range(n_y):
        for i_a in range(n_a):
            Tv[i_y, i_a] = np.max(obj[i_y, i_a, :])
            Tg[i_y, i_a] = np.argmax(obj[i_y, i_a, :])
    return Tv, Tg
    

   
                
                    
### Solve

def solve1():
    global V
    norm, tol = 1, 1e-6
    while norm>tol:
    
        obj = obj_f(V, r)
        Tv, Tg = Tv_f(obj)
        norm = np.max(np.abs(Tv - V))
        
        V = np.copy(Tv)
        iG = np.copy(Tg)
    
    return V, iG




# Transition matrix

def M_f(iG):
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




### barM

def barM_f(M):
    barM = M
    for i in range(100):
        barM = np.dot(M, barM)
    return barM[0, :]



## Poupança agregada


def Ea_f(barM):
    Ea = 0
    for i_y in range(n_y):
        for i_a in range(n_a):
            s_ind = iG[i_y, i_a]
            poup = a_grid[s_ind]            
            t_ind = i_y*n_a + i_a           
            dist = barM[t_ind]           
            Ea = Ea + dist*poup
    return Ea






# Trabalho


def L_f(barM):
    E_y = 0 
    
    for i_y in range(n_y):
        for i_a in range(n_a):
            trabalho = y_grid[i_y]
            
            t_ind = i_y*n_a + i_a
            dist = barM[t_ind]
            
            E_y += dist*trabalho
    return E_y
            
            
### Solve 2 - Find r

def main(r):
    k = compute_k(r)
    w = compute_w(k)        
    
    V, iG = solve1()
    M = M_f(iG)
    barM = barM_f(M)
    Ea = Ea_f(barM)
    L = L_f(barM)        
    T = tau*r*k*L
    
    K = k*L
    
    d = K - Ea
    
    return d



def solve2():
    global V, k, w
    norm2, tol2 = 1, 1e-8
    r_l, r_h = -delta, beta**(-1) - 1

    while norm2 > tol2:

        r_bar = 0.5*(r_l + r_h)
        if main(r_bar)>0:
            r_l = r_bar
        else:
            r_h = r_bar
        norm2 = abs(r_l - r_h)
        
        print(f'\033[1;033mnorma={norm2:.4f}, d={main(r_bar):.4f}, r_l = {r_l:.4f}')





########### Main code

## SS inicial

pars()

V_0 = np.copy(V)
Phi_0 = np.copy(barM)
iG_0 = np.copy(iG)
r_0 = np.copy(r)
w_0 = np.copy(w)
T_0 = np.copy(T)

K_0 = Ea_f(Phi_0)

plt.plot(a_grid,V_0[0,:])
plt.plot(a_grid,V_0[1,:])
plt.show()

G_0 = a_grid[iG_0]
plt.plot(a_grid,G_0[0,:])
plt.plot(a_grid,G_0[1,:])
plt.plot(a_grid, a_grid)
plt.show()



##  SS final


print('\nCalculando o SS final')
tau = 0.05
solve2()
Phi_inf = np.copy(barM)
V_00 = np.copy(V)
iG_00 = np.copy(iG)
r_00 = np.copy(r)
w_00 = np.copy(w)
T_00 = np.copy(T)
K_inf = Ea_f(Phi_inf)

plt.plot(a_grid,V_00[0,:])
plt.plot(a_grid,V_00[1,:])
plt.show()
 

G_inf = a_grid[iG_00]
plt.plot(a_grid,G_inf[0,:])
plt.plot(a_grid,G_inf[1,:])
plt.plot(a_grid, a_grid)
plt.show()























 























            
            
            
    
    
    
    
    
    
    















 




                    












# Utility funtion

def util(c, sig):
    return (c**sig - 1)/ (1 - sig)

















