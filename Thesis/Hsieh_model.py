# -*- coding: utf-8 -*-
"""
Created on Tue Mar  3 10:18:22 2020

@author: Marcos J Ribeiro
"""
# see this: https://pastebin.com/cvYBvW3B
# The model can be viewed in:  https://drive.google.com/drive/u/0/folders/1MOOHg2woM6B2MCLohTPk-kbIgO5RLbVZ


import numpy as np
import matplotlib.pyplot as plt
import math as mt
from scipy.optimize import minimize
from math import gamma
import itertools as itl
import time





#----------------------- Defining parameters



def par():
    global beta, eta, varphi, theta, rho, i, r, gamma1, phi, kappa
    beta = 0.69
    eta = 0.25
    varphi = 0.25
    theta = 3.44
    rho = 0.19
    kappa = 1/(1- eta)
    i = 2
    r = 4
    gamma1 = gamma(1 - ( (theta*(1-rho)) **(-1) )   * (1 - eta)**(-1)  )    
    phi = [0.138, 0.174]



par()
gamma1

#------------------------ h_til



def h_tilf( ):
    global h_til
    
    sf( )

    h_til = np.zeros((i, r))
    for c in range(i):
        for j in range(r):    
            h_til[c, j] = ( 1 ** varphi * s[c]**phi[c] * eta**eta )**(1 - eta)**(-1) 

    return h_til





#------------------------ Agregate Human capital   (eq 23)

 
#
#def Hf( ):
#    taus2()
#    global H, E, c1, g, b, a 
#    h_tilf( )
#    
#    a = 1/ theta* ( 1 - rho )
#    b = 1/ ( 1 - eta )
#    
#    g = gamma(1 - a * b)
#                  
#    H = np.zeros((i, r))
#    #c1 = np.zeros(i)
#    c1 = ( 1/1 )**(b / eta)
#    #E = np.zeros(i)
#    E = c1 * g
#    
#    for c in range(i):               
#            
#        #c1[c] = ( 1/p_i[c] )**(b / eta)
#        
#            
#        for j in range(r): 
#            
#            H[c, j] = p_ir[c, j]*h_til[c, j] * ( ( (1 - x1[0, c, j])/(1 + x1[1, c, j]) ) * x1[2, c, j] ) ** (eta/(1 - eta)) * E
#          
#    return H



#----------------------------------------- s - time spent at school   (eq 14)




def sf( ):
    global s
    s = np.zeros((i, 1))
    
    for c in range(i):
        s[c] = (1+ (1-eta)/ (beta*phi[c]) ) ** (-1)                        
    return s

sf()

#----------------------------------------- Human capital of teachers

#Numpy parece não permitir potências fracionárias de números negativos,
#mesmo que a potência não resulte em um número complexo.




def H_trf():
    global H_tr, T, P, S, N, H
        
    par( )
    taus2()    
    sf()
    
    P = np.zeros(r)
    T = np.zeros((i, r))
    S = np.zeros(i)
    N = np.zeros((i, r))
    H = np.zeros((i, r))
        
    for c in range(i):
        for j in range(r):
            
            S[c] = ( s[c]**phi[c]*eta**eta ) ** kappa
            P[j] = ( ( ( 1 - x1[0].sum(axis=0)[j] ) / ( ( 1 + x1[1].sum(axis=0)[j] )**eta) ) * ( x1[2].sum(axis=0)[j] ) ) ** (theta - kappa)
            T[c, j] = ( ( 1 - x1[0, c, j] ) * x1[2, c, j] ) ** ( theta - kappa +kappa*eta) 
            N[c, j] = ( 1 + x1[1, c, j]) ** (eta*theta) 
            
            H[c, j] = ( ( T[c, j] * S[c] * gamma1 ) / ( N[c, j] * P[j]) ** (1/(1-varphi*kappa)))  

    H_tr = H[i-1, :]
    return H_tr



#---------------- p_ir (other aproach)
#
#def pf2():
#    global ps
#    
#    #taus2()
#    q1 = np.zeros((i, r))
#    q2 = np.zeros(r)
#    ps = np.zeros((i, r))
#    for c in range(i):
#        for j in range(r):
#            q1[c, j] = ( ( (1 - x1[0, c, j]) / (1 + x1[1, c, j])**eta ) * (x1[2, c, j]) ) **theta 
#            q2[j] = ( ( (1 - x1[0].sum(axis=0)[j]) / (1 + x1[1].sum(axis=0)[j] )**eta ) * ( x1[2].sum(axis=0)[j] ) ) ** theta
#            ps[c, j] = ( (q1[c, j] ) / (q2[j] ) ) 
#    return ps
#
#
#pf2() 
#
#ps.sum(axis=0)

#----------------------------------------- w tilde  (Proposition 1)

x1

def w_tilf( ):
    
    par( )
    taus2( )
    H_trf = np.ones((i, r))
    
    global w_til
    
    w_til = np.zeros((i, r))
    
    for c in range(i):
        for j in range(r):
            w_til[c, j] = ( (1 - x1[0, c, j]) / ( (1 + x1[1, c, j]) ** eta) ) * 1**varphi * x1[2, c, j] * s[c]**phi[c] * (1 - s[c]) ** ( (1- eta) /beta )           
            #w_til[c, j] = ( (1 - x1[0, c, j]) / ( (1 + x1[1, c, j]) ** eta) ) * (np.sign(H_tr[j])* np.abs(H_tr[j])**varphi)  * x1[2, c, j] * s[c]**phi[c] * (1 - s[c]) ** ( (1- eta) /beta )           

    return w_til 

taus2()
w_tilf()

#------------------------------------------ p_ir  (eq 19)
    
        
def p_irf( ):
    global p_ir, p_i, w_r
    w_tilf( )
        
    #w_r = np.sign(w_til)*np.abs(w_til)**theta
    w_r = w_til**theta
    w_r = w_r.sum(axis = 0) 
     
    p_ir = np.zeros((i, r))
    
    for c in range(i):
        for j in range(r):
            p_ir[c, j] = (( w_til[c, j] )) ** theta / w_r[j]
             #p_ir[c, j] = ((np.sign(w_til[c, j])* np.abs(w_til[c, j])**theta) ) / w_r[j]            
    #p_i = np.sum(p_ir)

    p_i = np.sum(p_ir, axis =0)  
    return p_ir



#---------------------------------------  W (eq 27)




def Wf():
    p_irf( )
    taus2( )
    global W
    W = np.zeros((i, r))
    
    for c in range(i):
        for j in range(r):
            W[c, j] = ((1 - s[c])**(-1/beta))/( 1 - x1[0, c, j] )*gamma1*eta*(w_r[j])**(1/(theta*(1 - eta)))     #        (eq 27)
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
   


#--------------------- OBJECTIVE FUNCTION

 

def obj(tau):
    global D, tau_w, tau_h, w
    
    tau = tau.reshape((3, i, r))
    tau_w = tau[0]
    tau_h = tau[1]
    w = tau[2]
    
    sf()
    w_tilf()
    p_irf()
#    H_trf()
    H_trf = np.ones((i, r))
    Wf()
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


calibration(3000)




























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