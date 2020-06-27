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

#--- My functions

def summary(y):  
    import numpy as np
      
    mean = np.around(np.mean(y), 4)
    mini = np.around(np.min(y), 4)
    maxi = np.around(np.max(y), 4)
    med = np.around(np.median(y), 4)
    std = np.around(np.std(y), 4)
    print(f'\033[1;033mMédia: {mean} \n Std: {std} \n Mínimo: {mini} \n Máximo: {maxi} \n Mediana: {med} ')

#----- Libraries

import numpy as np
import matplotlib.pyplot as plt
import math as mt
from scipy.optimize import minimize
from math import gamma
import itertools as itl
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
    kappa = 1/(1- eta)
    i = 7
    r = 27
    gamma1 = gamma(1 - ( 1/(theta*(1-rho)) * 1/(1 - eta) ) )   
    z = 1 - (varphi/(1 - eta))    
    alfa = 1 - 1/(theta*(1-eta))
    sig = (eta*kappa)/z
    phi = np.array([0.138, 0.174, 0.136, 0.1, 0.051, 0.084, 0.168])
   



#----------------------- Tau's  & w (TPF)

    
def taus2():
    global x1, tau_h, tau_w, w
    par()
        
    tau_h = np.random.uniform(low=-0.99, high=40, size=(i,r))
    tau_h[0, :] = 0

    tau_w = np.random.uniform(low=-0.99, high=0.999, size=(i,r))
    tau_w[0, : ] = tau_w[0, 0]
    
    w =np.random.uniform(low=0.001, high=30, size=(i,r))
    w[:, r-1] = 1
    
    x1 = np.array( [tau_w, tau_h, w] )
    
    return x1




#--------------------------- s - time spent at school   (eq 14)


def sf( ):
    par()
    s = (1+ (1-eta)/ (beta*phi) ) ** (-1)
    return s



#-------------------------------------- p_tr (eq 29)

def p_trf(x1):    
    s = sf( )
    
    A = ( (1 - x1[0]) / ( (1 + x1[1]) ** eta) ) 
    
    b=np.zeros(i)  
    for c in range(i): b[c] = np.power(s[c], phi[c])  
    B = b.reshape(i,1)*x1[2] 
    
    C = np.power( (1 - s),((1-eta)/beta) )
    
    k = np.power((A*B*C), theta)
    
    p_tr = k[i-1]/np.sum(k, axis=0)
    return p_tr
 
 
 

#-------------------------------------- Human capital of teachers - eq 31

def H_trf(x1):
    
    p_tr = p_trf(x1)  

    A = ( (1 - x1[0]) / np.power((1 + x1[1]),eta) )  * np.power(x1[2], sig)     
    A = A[i-1] 
    
    H_tr = np.power(p_tr, (alfa/z)) * (eta**eta * s[i-1]**phi[i-1])*A*gamma1**z    
     
    return H_tr
   
    

#----------------------------------------- w tilde  (Proposition 1)

#    x1 = np.array( [tau_w, tau_h, w] )


def w_tilf(x1):

    H_tr = H_trf(x1)     
             
    C = (1 - s)**((1-eta)/beta)
    A = (1 - x1[0]) / (  np.power( (1 + x1[1]), eta) )   
    
    pp = np.zeros((i))
    for c in range(i): pp[c] = np.power(s[c], phi[c])
    
    B = x1[2]*np.power(H_tr, varphi)*pp.reshape(7,1)
        
    w_til =  A*B*C
             
    return w_til 
 

 
#------------------------------------------ p_ir  (eq 19)


def p_irf(x1):
    
    w_til = w_tilf(x1)
        
    w_til2 = np.power(w_til, theta) 
    w_r = w_til2.sum(axis = 0)    
        
    p_ir = w_til2 / w_r 
             
    return p_ir

 tt= p_irf(x1)


#---------------------------------------  W (eq 27)


def Wf(x1):
    par()
    p_irf(x1)
    sf()
    #taus2( )
    global W
    W = np.zeros((i, r))
    A = np.zeros((i, r))
    B = np.zeros(r)
    
    w_r2 = gamma1*eta*w_r**(1/(theta*(1 - eta)))
    
    for c in range(i):
        for j in range(r):
                       
            A[c, j] = ((1 - s[c])**(-1/beta))/( 1 - x1[0, c, j] )
            
                                 
            W[c, j] = A[c, j]*w_r2[j]
    return W


#--------- PNAD data


def simul():
    global W_t, p_t
    

    p_t = pd.read_csv('pt.csv', sep=';')
    p_t = p_t.iloc[0:7]
    p_t.set_index('ocup', inplace=True)

    W_t = pd.read_csv('wt.csv', sep=';')
    W_t.set_index('ocup', inplace=True)




#--------------------- OBJECTIVE FUNCTION

def obj(x1):
    global D
    x1 = taus2()
    x1 = x1.reshape((3, i, r))    
    
    sf()
    H_trf(x1)
    w_tilf(x1)
    p_irf(x1)
    Wf(x1)
    simul()
    
    D = ( ( (W-W_t)/W_t )**2 + ( (p_ir-p_t)/p_t )**2).sum().sum()
 
    return D


