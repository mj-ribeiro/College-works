# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 20:54:32 2020

@author: Marcos J Ribeiro
"""


import os
os.getcwd()
os.chdir('D:\\Git projects\\college_works\\Thesis')

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize
from math import gamma
import time
import pandas as pd


## Parameters

def par():
    global beta, eta, varphi, theta, rho, i, r, gamma1, phi, kappa, alfa, psi, sig, pi, nu
    beta = 0.69
    eta = 0.25
    varphi = 0.25
    theta = 3.44
    rho = 0.19
    alfa = 0.3
    kappa = np.divide(1, (1- eta) )
    nu = 1 + np.multiply(alfa, np.multiply(varphi, kappa)) - np.divide(kappa, theta)
    pi = 1 - np.multiply(np.multiply( (1 - alfa), varphi), kappa )    
    sig = np.divide(np.multiply(eta, kappa), pi )
    psi = np.multiply(np.power(eta, eta), np.power( (1-eta), (1-eta) ) )
    i = 7
    r = 27
    gamma1 = gamma(   1 - np.multiply( np.divide(1, np.multiply(theta, (1-rho)) ), np.divide(1, (1 - eta) ) ) )   
    phi = np.array([0.138, 0.174, 0.136, 0.1, 0.051, 0.084, 0.168]).reshape(i, 1)
   
    


## Guess


def taus2():
    par()
        
    tau_h = np.random.uniform(low=-0.99, high=40, size=(i,r))
    tau_h[0, :] = 0

    tau_w = np.random.uniform(low=-0.99, high=0.999, size=(i,r))
    tau_w[0, : ] = tau_w[0, 0]
    
    w =np.random.uniform(low=0.001, high=12, size=(i,r))
    w[:, r-1] = 1
    w[0:7, :] = w[0, :] 
    
    x1 = np.array( [tau_w, tau_h, w] )
    
    return x1

x1 = taus2()


# Time spent in school - EQ 14


def sf( ):
    global s
    s = np.power( (1+ np.divide( (1-eta), ( np.multiply(beta, phi) ) ) ), -1 )
    s = s.reshape(i, 1)
    return s


## Fraction of teachers - EQ 28


def p_trf(x1):    
    s = sf( )    
    A = np.divide( (1 - x1[0]) , np.power( (1 + x1[1]), eta) )     
    b = np.power(s, phi ) 
    B = np.multiply(b.reshape(i,1), x1[2] )     
    C = np.power( (1 - s), np.divide((1-eta), beta) )
    d = np.multiply(np.multiply(A, B), C )
    k = np.power(d, theta)
    p_tr = np.divide( k[i-1], np.sum(k, axis=0) )
    return p_tr
 


## Teachers human's capital - EQ 30

  
def H_trf(x1):    
    p_tr = p_trf(x1)  
    A = np.power(np.multiply( np.divide( (1 - x1[0]), (1 + x1[1]) ), x1[2] ), sig )    
    A = A[i-1]     
    P = np.multiply(np.power(p_tr, ( np.divide(nu, pi) )), np.power(eta, sig ) )
    g = np.divide(np.multiply(phi[i-1], kappa ), pi )
    C = np.multiply( np.power(s[i-1], g ), np.power(gamma1, np.divide(1, pi) ) )
    H_tr = np.multiply(np.multiply(P, A), C )       
    return H_tr

 
## Liquid reward - PROPOSITION 1

def w_tilf(x1):
    H_tr = H_trf(x1) 
    p_tr = p_trf(x1)                 
    C = np.power((1 - s), np.divide( (1-eta), beta )).reshape(7, 1)
    pp = np.power(s, phi)        
    A = np.multiply(psi, np.multiply( np.divide( (1 - x1[0]), np.power( (1 + x1[1]), eta ) ), x1[2] ) )    
    b = np.power(np.multiply(np.power(p_tr, alfa), np.power(H_tr, (1-alfa) ) ), varphi )    
    B = np.multiply(b, pp.reshape(7,1))
    w_til =  np.multiply(np.multiply(A, B), C )
    return w_til 





## Fraction of people working in occupation i in region r - EQ 17


def p_irf(x1):    
    w_til = w_tilf(x1)
    w_til2 = np.power(w_til, theta) 
    w_r = w_til2.sum(axis = 0)    
    p_ir = np.divide(w_til2 , w_r ) 
    return np.array(p_ir), np.array(w_r)




## Gross average earnings - EQ 27


def Wf(x1):
    p_ir, w_r = p_irf(x1)         
    z = np.multiply(np.multiply(gamma1, eta), np.power(w_r, np.divide(1, np.multiply(theta, (1 - eta)) ) ) )
    A = np.divide( np.power( (1 - s), (-1/beta) ), ( 1 - x1[0] )  )                
    W = np.multiply(A, z)
    return W, p_ir


## PNAD data


def simul():
    global p_t, W_t
    p_t = pd.read_csv('pt.csv', sep=';')
    p_t = p_t.iloc[0:7]
    p_t.set_index('ocup', inplace=True)
    p_t = np.array(p_t)
    W_t = pd.read_csv('wt.csv', sep=';')
    W_t.set_index('ocup', inplace=True)
    W_t = np.array(W_t)
    
    return p_t, W_t


simul()


## Objective - EQ 31


p_t2 = np.array(p_t[0:6])
    
def obj2(x1):       
    x1 = x1.reshape((3, i, r)) 
    x1[0, 0, : ] = x1[0, 0, 0]    
    x1[1, 0, :] = 0
    x1[2, :, 6] = 1
    x1[2, 0:7, :] = x1[2, 0, :]
    W, p_ir = Wf(x1)    
    p_ir = p_ir[0:6]
    D =   (np.power(np.divide( (W-W_t), W_t ), 2)).sum() + (np.power(np.divide( (p_ir-p_t2), p_t2 ), 2)).sum() 
    D = np.log(D)    
    return D




## h_til

def h_tilf(x1):
    H_tr = H_trf(x1) 
    p_tr = p_trf(x1) 
    A = np.power(np.multiply(np.power(p_tr, alfa), np.power(H_tr, (1-alfa) ) ), varphi )    
    B = np.multiply(np.power(s, phi), np.power(eta, eta) )
    h_til = np.power(np.multiply(A, B), kappa )
    return h_til


## Human capital - EQ 23

def H_irf(x1):
    p_ir = p_irf(x1)[0]
    h_til = h_tilf(x1)
    A = np.multiply(h_til, np.power(p_ir, (1-kappa/theta) ) )
    B = np.power(np.multiply( np.divide( (1 - x1[0]), (1 + x1[1]) ), x1[2] ), np.multiply(eta, kappa ) )       
    H_ir = np.multiply(np.multiply(A, B), gamma1 )
    return H_ir
    



def Y_f(x1):
    H_ir = H_irf(x1) 
    Y = np.multiply(x1[2, 0, :], H_ir)
    return Y




Bd = ((-0.99, 0.999), )*189 + ((-0.99, 40), )*189 + ((0.001, 12), )*189
Bd = np.array(Bd)

