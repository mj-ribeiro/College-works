# -*- coding: utf-8 -*-
"""
Created on Tue Mar  3 10:18:22 2020

@author: Marcos J Ribeiro
"""
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





#----------------------- Defining parameters



def par():
    global beta, eta, varphi, theta, rho, i, r, gamma1, phi, kappa, z, alfa, sig
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
    sig = (eta*kappa)/z
    phi = [0.138, 0.174]
   

par()




#----------------------------------------- s - time spent at school   (eq 14)


def sf( ):
    global s
    s = np.zeros((i, 1))
    
    for c in range(i):
        s[c] = (1+ (1-eta)/ (beta*phi[c]) ) ** (-1)                        
    return s

sf()





#-------------------------------------- p_tr (eq 29)

def p_trf(x1):
    global  k
    
    A = np.zeros((i,r))
    B = np.zeros((i,r))
    C = np.zeros((i,r))
    k = np.zeros((i,r))
    
    for c in range(i):
        for j in range(r):
            A[c, j] = ( (1 - x1[0, c, j]) / ( (1 + x1[1, c, j]) ** eta) ) 
            B[c, j] = x1[2, c, j]*s[c]**phi[c]
            C[c, j] = (1 - s[c])**((1-eta)/beta)
            k[c, j] = (A[c, j]*B[c, j]*C[c, j] )**theta
    
    p_tr = k[i-1]/np.sum(k, axis=0)
    return p_tr
   

taus2()
np.around(p_trf(x1), 4 )






#-------------------------------------- Human capital of teachers - eq 31

#x1 = np.array( [tau_w, tau_h, w] )




def H_trf(x1):
    global H_tr
    
    p_tr = p_trf(x1)  
    A = np.zeros((i,r))        
    H_tr = np.zeros(r)    

    for c in range(i):
        for j in range(r):
            A[c, j] = ( (1 - x1[0, c, j]) / ( (1 + x1[1, c, j]) ** eta) ) * x1[2, c, j]**sig 
    
    A = A[i-1]
    
    for j in range(r):
        H_tr[j] = p_tr[j]**(alfa/z) * (eta**eta * s[i-1]**phi[i-1])*A[j]*gamma1**z
    
    return H_tr
 

taus2()






#----------------------------------------- w tilde  (Proposition 1)

#    x1 = np.array( [tau_w, tau_h, w] )


def w_tilf(x1):
    global w_til, A, B 
    
    par( )
    H_trf(x1)     
        
    w_til = np.zeros((i, r))
    A = np.zeros((i, r))
    B = np.zeros((i, r))
    C = np.zeros(i)
    
    for c in range(i):
        C[c] = (1 - s[c])**((1-eta)/beta)
        for j in range(r):
            A[c, j] = (1 - x1[0, c, j]) / ( (1 + x1[1, c, j]) ** eta)  
            B[c, j] = x1[2, c, j]*(H_tr[j]**varphi)*s[c]**phi[c]
        
            w_til[c, j] =  A[c, j]*B[c, j]*C[c]
             
    return w_til 
 
taus2()

w_tilf(x1)
A
B


#------------------------------------------ p_ir  (eq 19)
    
        
def p_irf(x1):
    global p_ir, w_r 
    w_tilf(x1)
        
    w_til2 = w_til**theta 
    w_r = w_til2.sum(axis = 0)    
    
    p_ir = np.zeros((i, r))
    
    for c in range(i):
        for j in range(r):
            p_ir[c, j] = w_til2[c, j] / w_r[j] 
             
    return p_ir

 
taus2()
#w_tilf()
np.around(p_irf(x1), 2)

w_r


#---------------------------------------  W (eq 27)


def Wf(x1):
    p_irf(x1)
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

w_r

taus2()
Wf(x1)

#--------- Simulated data 


def simul():
    global W_t, p_t
    
    W_t = np.array(([2.71, 2.81, 3.07, 2.7], [2.76, 2.85, 2.89, 2.8]))  
    W_t = np.exp(W_t)    
    p_t = np.array(([0.55, 0.4, 0.35, 0.77], [0.45, 0.6, 0.65, 0.23]))


#----------------------- Tau's  & w (TPF)


    
def taus2():
    global x1, tau_h, tau_w, w
    par()
        
    tau_h = np.random.uniform(low=-0.99, high=40, size=(i,r))
    tau_h[0, :] = 0

    tau_w = np.random.uniform(low=-0.99, high=0.999, size=(i,r))
    tau_w[0, : ] = tau_w[0, 0]
    
    w =np.random.uniform(low=0.001, high=20, size=(i,r))
    w[:, r-1] = 1
    
    x1 = np.array( [tau_w, tau_h, w] )
    
    return x1

taus2()   


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
    
    D = np.sum((W/W_t - 1)**2 + (p_ir/p_t - 1)**2)
 
    return D



#----------------------------- OPTIMIZATION Scipy

taus2()
obj(x1)




def calibration(v):
    
    global D, s
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
    s = sol.x
    D = sol.fun
    
    return D


res = calibration(5000)


sol = minimize(obj, x1,  method='Nelder-Mead', options={'maxiter':500000})
sol.


#--------- Multiple calibration


def hsieh(n, v, t=12):
    global opt, k, tt
    opt = [t]
    tt = np.zeros(n+1)
    for z in itl.count():
        
        if z < n+1:

            sol = minimize(obj, x1,  method='Nelder-Mead', options={'maxiter':v})
            res = sol.fun
            print(f'\033[1;033mTentativa: {z}, D = {res} ')

            k = sol.x
            tt[z] = res
            
            if res < opt[0]:
                opt.remove(opt[0])
                opt.append(res)
                
                a = k                
        else: 
            break
    return opt, a


hsieh(100, 5000, t=5)




len(tt)

import seaborn as sns

fig, ax = plt.subplots(1, 2)
ax[0].hist(tt)
ax[1].plot(tt)



summary(tt)


#--------------- NLopt


def obj2(x1):
    global D
    x1 = taus2()
    #x1 = x1.reshape((1, i*3, 1))    
    
    sf()
    H_trf(x1)
    w_tilf(x1)
    p_irf(x1)
    Wf(x1)
    simul()
    
    D = np.sum((W/W_t - 1)**2 + (p_ir/p_t - 1)**2)
 
    return D


obj2(x2)







import nlopt 


opt = nlopt.opt(nlopt.LD_SLSQP, 1)
opt.set_min_objective(obj)
x = opt.optimize(x1)




##------------------------ tests




def taus3():
    global x2
    par()
        
    tau_h = np.random.uniform(low=-0.99, high=40, size=(i,r))
    tau_h[0, :] = 0

    tau_w = np.random.uniform(low=-0.99, high=0.999, size=(i,r))
    tau_w[0, : ] = tau_w[0, 0]
    
    w =np.random.uniform(low=0.001, high=20, size=(i,r))
    w[:, r-1] = 1
    
    x2 = np.array( [tau_w, tau_h, w] )
        
    x2 = np.concatenate((tau_w, tau_h, w), axis=0)
    x2 = x2.reshape(24)
    
    return x2







b0 = [-0.99, 0.999]
b1 = [-0.99, 40]
b2 = [0.001, 20]

bounds = np.array([b0, b1, b2])



sol2 = minimize(obj, x2, method='trust-constr')

sol2

















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