# -*- coding: utf-8 -*-
"""
Created on Fri Jun 26 21:38:08 2020

@author: Marcos J Ribeiro
"""

import os
os.getcwd()
os.chdir('D:\\Git projects\\college_works\\Thesis')

# see this: https://pastebin.com/cvYBvW3B
# The model can be viewed in:  https://mj-ribeiro.github.io/blog/hsieh_model/


#----- Libraries


import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize
from math import gamma
import time
import pandas as pd





#----------------------- Defining parameters



def par():
    global beta, eta, varphi, theta, rho, i, r, gamma1, phi, kappa, z, alfa, sig
    beta = 0.69
    eta = 0.25
    varphi = 0.25
    theta = 3.44
    rho = 0.19
    kappa = np.divide(1, (1- eta) )
    i = 7
    r = 27
    gamma1 = gamma(   1 - (   np.divide(1, (theta*(1-rho)) ) * np.divide(1, (1 - eta) ) ) )   
    z = 1 - np.divide(varphi, (1 - eta))    
    alfa = 1 - 1/(theta*(1-eta))
    sig = (eta*kappa)/z
    phi = np.array([0.138, 0.174, 0.136, 0.1, 0.051, 0.084, 0.168]).reshape(i, 1)


#----------------------- Tau's  & w (TPF)

    
def taus2():
    par()
        
    tau_h = np.random.uniform(low=-0.99, high=40, size=(i,r))
    tau_h[0, :] = 0

    tau_w = np.random.uniform(low=-0.99, high=0.999, size=(i,r))
    tau_w[0, : ] = tau_w[0, 0]
    
    w =np.random.uniform(low=0.001, high=30, size=(i,r))
    w[:, r-1] = 1
    w[1:6, :] = w[0, :] 
    
    x1 = np.array( [tau_w, tau_h, w] )
    
    return x1




#--------------------------- s - time spent at school   (eq 14)

def sf( ):
    global s
    s = np.power( (1+ np.divide( (1-eta), ( np.multiply(beta, phi) ) ) ), -1 )
    s = s.reshape(i, 1)
    return s



#-------------------------------------- p_tr (eq 29)

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


#------------------------------------ Human capital of teachers - eq 31



def H_trf(x1):    
    p_tr = p_trf(x1)  

    A = np.power(np.multiply( np.divide( (1 - x1[0]), (1 + x1[1]) ), x1[2] ), sig )    
    A = A[i-1] 
    
    h = np.multiply(np.power(p_tr, (alfa/z)), np.power(eta, (eta*kappa/z) ) )
    c = np.multiply( np.power(s[i-1], (phi[i-1]*kappa/z) ), np.power(gamma1, 1/z) )
    
    H_tr = np.multiply(np.multiply(h, A), c )       
    return H_tr

#----------------------------------------- w tilde  (Proposition 1)



def w_tilf(x1):
    H_tr = H_trf(x1)     
    m = np.divide( (1-eta), beta )    
    C = np.power((1 - s), (m)).reshape(7, 1)
    A = np.divide( (1 - x1[0]) , ( np.power( (1 + x1[1]), eta) ) ) 
    pp = np.power(s, phi)
    
    b = np.multiply( x1[2], np.power(H_tr, varphi) )
    
    B = np.multiply(b, pp.reshape(7,1))
   
    w_til =  np.multiply(np.multiply(A, B), C )
    
    return w_til 
 


#------------------------------------------ p_ir  (eq 19)



def p_irf(x1):    
    w_til = w_tilf(x1)
    w_til2 = np.power(w_til, theta) 
    w_r = w_til2.sum(axis = 0)    
    p_ir = np.divide(w_til2 , w_r ) 
    return np.array(p_ir), np.array(w_r)


#---------------------------------------  W (eq 27)

def Wf(x1):
    p_ir, w_r = p_irf(x1)         
    z = np.multiply(np.multiply(gamma1, eta), np.power(w_r, np.divide(1, np.multiply(theta, (1 - eta)) ) ) )
    A = np.divide( np.power( (1 - s), (-1/beta) ), ( 1 - x1[0] )  )                
    W = np.multiply(A, z)
    return W, p_ir

   
#--------- PNAD data

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


#--------------------- OBJECTIVE FUNCTION


def obj(x1):
    
    x1 = x1.reshape((3, i, r)) 
    x1[0, 0, : ] = x1[0, 0, 0]    
    x1[1, 0, :] = 0
    x1[2, :, r-1] = 1
    x1[2, 1:6, :] = x1[2, 0, :]
    W, p_ir = Wf(x1)
    
    D =  (np.power(np.divide( (W-W_t), W_t ), 2) + np.power(np.divide( (p_ir-p_t), p_t ), 2) ).sum()
    D = np.log(D)
    
    return D








#------------ constraints


cons = ({'type': 'eq', 'fun': lambda x1: x1[189:215] - 0},        
        {'type': 'eq', 'fun': lambda x1: x1[404] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[431] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[458] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[485] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[512] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[539] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[566] - 1},        
        {'type': 'eq', 'fun': lambda x1: x1[0] - x1[1]},
        {'type': 'eq', 'fun': lambda x1: x1[1] - x1[2]},
        {'type': 'eq', 'fun': lambda x1: x1[2] - x1[3]},
        {'type': 'eq', 'fun': lambda x1: x1[3] - x1[4]},
        {'type': 'eq', 'fun': lambda x1: x1[4] - x1[5]},
        {'type': 'eq', 'fun': lambda x1: x1[5] - x1[6]},
        {'type': 'eq', 'fun': lambda x1: x1[6] - x1[7]},
        {'type': 'eq', 'fun': lambda x1: x1[7] - x1[8]},
        {'type': 'eq', 'fun': lambda x1: x1[8] - x1[9]},
        {'type': 'eq', 'fun': lambda x1: x1[9] - x1[10]},
        {'type': 'eq', 'fun': lambda x1: x1[10] - x1[11]},
        {'type': 'eq', 'fun': lambda x1: x1[11] - x1[12]},
        {'type': 'eq', 'fun': lambda x1: x1[12] - x1[13]},
        {'type': 'eq', 'fun': lambda x1: x1[13] - x1[14]},
        {'type': 'eq', 'fun': lambda x1: x1[14] - x1[15]},
        {'type': 'eq', 'fun': lambda x1: x1[15] - x1[16]},
        {'type': 'eq', 'fun': lambda x1: x1[16] - x1[17]},
        {'type': 'eq', 'fun': lambda x1: x1[17] - x1[18]},
        {'type': 'eq', 'fun': lambda x1: x1[18] - x1[19]},
        {'type': 'eq', 'fun': lambda x1: x1[19] - x1[20]},
        {'type': 'eq', 'fun': lambda x1: x1[20] - x1[21]},
        {'type': 'eq', 'fun': lambda x1: x1[21] - x1[22]},
        {'type': 'eq', 'fun': lambda x1: x1[22] - x1[23]},
        {'type': 'eq', 'fun': lambda x1: x1[23] - x1[24]},
        {'type': 'eq', 'fun': lambda x1: x1[24] - x1[25]},
        {'type': 'eq', 'fun': lambda x1: x1[25] - x1[26]},
        )



# optimization

Bd = ((-0.99, 0.999), )*189 + ((-0.99, 40), )*189 + ((0.001, 30), )*189
Bd = np.array(Bd)



def hessp(x, l):
    return np.zeros((3, i, r))




