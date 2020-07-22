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
    kappa = np.divide(1, (1- eta) )
    nu = 1 + np.multiply(alfa, np.multiply(varphi, kappa))
    pi = 1 - np.multiply(np.multiply( (1 - alfa), varphi), kappa )
    alfa = 1
    sig = (eta*kappa)/pi
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
    
    w =np.random.uniform(low=0.001, high=30, size=(i,r))
    w[:, r-1] = 1
    
    x1 = np.array( [tau_w, tau_h, w] )
    
    return x1

taus2()



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
    m = np.divide(np.multiply(eta, kappa), pi )
    h = np.multiply(np.power(p_tr, (nu/pi)), np.power(eta, m ) )
    g = np.divide(np.multiply(phi[i-1], kappa ), pi )
    C = np.multiply( np.power(s[i-1], g ), np.power(gamma1, 1/pi) )
    H_tr = np.multiply(np.multiply(h, A), C )       
    return H_tr




## Liquid reward - PROPOSITION 1


def w_tilf(x1):
    H_tr = H_trf(x1) 
    p_tr = p_trf(x1)     
    m = np.divide( (1-eta), beta )        
    C = np.power((1 - s), (m)).reshape(7, 1)
    pp = np.power(s, phi)        
    A = np.multiply(psi, np.multiply( np.divide( (1 - x1[0]), (1 + x1[1]) ), x1[2] ) )    
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


## Objective - EQ 31


def obj(x1):
    
    x1 = x1.reshape((3, i, r)) 
    x1[0, 0, : ] = x1[0, 0, 0]    
    x1[1, 0, :] = 0
    x1[2, :, r-1] = 1
            
    W, p_ir = Wf(x1)
    
    D =  (np.power(np.divide( (W-W_t), W_t ), 2) + np.power(np.divide( (p_ir-p_t), p_t ), 2) ).sum()
    D = np.log(D)
    
    return D

