# -*- coding: utf-8 -*-
"""
Created on Tue Mar  3 10:18:22 2020

@author: Marcos J Ribeiro
"""
# see this: https://pastebin.com/cvYBvW3B
# The model can be viewed in:  https://mj-ribeiro.github.io/blog/hsieh_model/

import numpy as np
import matplotlib.pyplot as plt
import math as mt
from scipy.optimize import minimize
from math import gamma
import itertools as itl
import time





#----------------------- Defining parameters



def par():
    global beta, eta, varphi, theta, rho, i, r, gamma1, phi, kappa, z, alfa, omg, mu, sig
    beta = 0.69
    eta = 0.25
    varphi = 0.25
    theta = 3.44
    rho = 0.19
    kappa = 1/(1- eta)
    i = 2
    r = 4
    gamma1 = gamma(1 - ( 1/(theta*(1-rho)) * 1/(1 - eta) ) )   
    z = 1 - (varphi/(1 - eta))    
    alfa = 1 - 1/(theta*(1-eta))
    omg = ( theta*alfa + eta*kappa )/ z
    phi = [0.138, 0.174]
    mu = (theta*alfa)/ z
    sig = kappa/z


par()




#----------------------------------------- s - time spent at school   (eq 14)


def sf( ):
    global s
    s = np.zeros((i, 1))
    
    for c in range(i):
        s[c] = (1+ (1-eta)/ (beta*phi[c]) ) ** (-1)                        
    return s

sf()

#-------------------------------------- Human capital of teachers - eq 31

#x1 = np.array( [tau_w, tau_h, w] )


from time import sleep as sl


def H_trf(x1):
    global H_tr
#    taus2( )
    C = sf()[i-1]**phi[i-1]*eta**eta *gamma1**(-z)
    A = np.zeros(r)         
    B = np.zeros(r)
    H_tr = np.zeros(r)
    for j in range(r):
        A[j] = ( (1 - x1[0, i-1 , j]) /( (1 + x1[1, i-1 , j])**eta) * x1[2, i-1 , j] )**omg  
        B[j] = ((1 + np.sum(x1[1], axis=0)[j] ) **eta / (1 - np.sum(x1[0], axis=0)[j] ) * ( 1/x1[2, i-1 , j] ) )**mu
  
        H_tr[j] = A[j]*B[j]*C      
   
    return H_tr
 

taus2()

H_trf()





#----------------------------------------- w tilde  (Proposition 1)


def w_tilf(x1):
    global w_til
    
    par( )
    H_trf(x1)     
        
    w_til = np.zeros((i, r))
    A = np.zeros((i, r))
    B = np.zeros((i, r))
    C = np.zeros((i, r))
    
    for c in range(i):
        for j in range(r):
            A[c, j] = ( (1 - x1[0, c, j]) / ( (1 + x1[1, c, j]) ** eta) ) 
            B[c, j] = x1[2, c, j]*H_tr[j]**varphi*s[c]**phi[c]
            C[c, j] = (1 - s[c])**((1-eta)/beta)
            
            w_til[c, j] = A[c, j]*B[c, j]*C[c, j] 
             
    return w_til 
 
taus2()
w_tilf()

#------------------------------------------ p_ir  (eq 19)
    
        
def p_irf(x1):
    global p_ir, w_r, w_til
    w_tilf(x1)
    
    w_til = w_til ** theta
    w_r = w_til.sum(axis = 0)    
    
    p_ir = np.zeros((i, r))
    
    for c in range(i):
        for j in range(r):
            p_ir[c, j] = w_til[c, j] / w_r[j] 
             
    return p_ir


taus2()
w_tilf()
p_irf( )
w_r


#---------------------------------------  W (eq 27)


def Wf(x1):
    p_irf(x1)
    #taus2( )
    global W
    W = np.zeros((i, r))
    A = np.zeros((i, r))
    B = np.zeros((i, r))
    
    for c in range(i):
        for j in range(r):
                       
            A[c, j] = ((1 - s[c])**(-1/beta))/( 1 - x1[0, c, j] )
            B[c, j] = gamma1*eta*w_r[j]**(1/(theta*(1 - eta)))                    
            W[c, j] = A[c, j]*B[c, j]
    return W


#--------- Simulated data 


def simul():
    global W_t, p_t
    
    W_t = np.array(([0.1, 0.42, 0.33, 0.12], [0.99, 0.22, 0.154, 0.654]))  
    
    p_t = np.array(([0.122, 0.12, 0.132, 0.109], [0.212, 0.453, 0.3524, 0.114]))



#----------------------- Tau's  & w (TPF)



    
def taus2():
    global x1, tau_h, tau_w, w
    par()
        
    tau_h = np.random.uniform(low=-1, high=1, size=(i,r))
    tau_h[0, :] = 0

    tau_w = np.random.uniform(low=-1, high=1, size=(i,r))
    tau_w[0, : ] = tau_w[0, 0]
    
    w =np.random.uniform(low=0, high=1, size=(i,r))
    w[:, r-1] = 1
    
    x1 = np.array( [tau_w, tau_h, w] )
    
    return x1

taus2()   


#--------------------- OBJECTIVE FUNCTION

 

def obj(x1):
    global D
    
    x1 = x1.reshape((3, i, r))    
    
    sf()
    H_trf(x1)
    w_tilf(x1)
    p_irf(x1)
    Wf(x1)
    simul()
    
    D = np.sum((W/W_t - 1)**2 + (p_ir/p_t - 1)**2)

    return D



#----------------------------- OPTIMIZATION Scipy

taus2()
obj(x1)




def calibration(v):
    
    global D
    start = time.time()
    sol = minimize(obj, x1,  method='Nelder-Mead', options={'maxiter':v})
    end = time.time()
            
    print('\033[1;033m=-'*25)
    print('{:*^50}'.format('Hsieh Model'))
    print('=-'*25)
    print('   ')
    
    print('\033[1;033mElapsed time:', (end - start))
    print('   ')
        

    print(f'tau_w is given by: \n {np.around(sol.x[0:8].reshape(i, r), decimals=4)}')
    print('   ')

    print(f'tau_h is given by: \n {np.around(sol.x[8:16].reshape(i, r), decimals=4)}')
    print('   ')

    print(f'w is given by: \n {np.around(sol.x[16:24].reshape(i, r), decimals=4) }')
    print('   ')

    print(f'The minimun value to D is: {sol.fun}')
    print('   ') 
    
    print('{:*^50}'.format('End of calibration'))


calibration(20000)


np.seterr(all='ignore')


























#--------------------------- OPTIMIZATION Marcos's Algorithm



def hsieh(n, t=12):
    global opt, k
    opt = [t]
    k = np.zeros((3, i, r))

    for z in itl.count():
        
        if z < n+1:
            taus2()
            res = obj(x1)
            print(z)
            
            if res < opt[0]:
                opt.remove(opt[0])
                opt.append(res)
                k = x1
        else: 
            break







def calibration2(v, t=12):
    
    start = time.time()
    hsieh(v, t)
    end = time.time()
            
    print('\033[1;033m=-'*25)
    print('{:*^50}'.format('Hsieh Model'))
    print('=-'*25)
    print('   ')
    
    print('\033[1;033mElapsed time:', (end - start))
    print('   ')
        

    print(f'tau_w is given by: \n {k[0]}')
    print('   ')

    print(f'tau_h is given by: \n {k[1]}')
    print('   ')

    print(f'w is given by: \n {k[2]}')
    print('   ')

    print(f'The minimun value to D is: {opt}')
    print('   ') 
    
    print('{:*^50}'.format('End of calibration'))



calibration2(100000, 15)








###################  END