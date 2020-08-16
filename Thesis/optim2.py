# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 21:17:43 2020

@author: Marcos J Ribeiro
"""

import os
os.getcwd()
os.chdir('D:\\Git projects\\college_works\\Thesis')
from Hsieh_V2 import *
from scipy.optimize import minimize
import pandas as pd


z1 = pd.read_excel('MG_8.xlsx') 

z1 = np.array(z1)


tt = pd.read_excel('teste.xlsx') 

tt = np.array(tt)

obj2(tt)
obj2(z1)



z1.reshape(3, i, r)[2, 0,:] 

tt.reshape(3, i, r)[2, 0,:] 


z1.reshape(3, i, r)[0, 1,:] 

tt.reshape(3, i, r)[0, 1,:] 


# L-BFGS-B

z1 = taus2()

cc = 0
def callback(x):
    global cc
    cc += 1
    fobj = obj2(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 5)}, iter: {cc}') 

    
%time sol= minimize(obj2, z1,  method='L-BFGS-B', bounds = Bd, callback=callback, tol=1e-20, options={'maxiter':1e4, 'maxfun':1e100,  'maxcor': 100, 'eps': 1e-08,})




sol 
ff = sol.x 
sol.fun 
sol.success

z1.reshape(3, i, r)[2, 0, :].sum()
 

obj2(z1)

z1.reshape(3, i, r)[2, 0,:] 


#### Nelder Mead

 
cc = 0
def callback(x):
    global cc
    cc += 1
    fobj = obj2(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 6)}, iter: {cc}') 

 
%time sol2 = minimize(obj2, ff,  method='Nelder-Mead', callback=callback, options={'maxiter':1e6})

  
ff=sol2.x
sol2.fun
sol2.success


obj2(np.array(z1))
obj2(tt)    
 
 

z1 = pd.DataFrame(z1)

z1.to_excel("MG_8.xlsx")  


tt = pd.DataFrame(tt)
tt.to_excel('teste.xlsx')



####

    
def obj3(x1):
    x1 = x1.reshape((3, i, r)) 
    x1[2] = x1[2]
    M = -1*Y_f(x1).sum()
    return M


cc = 0
def callback(x):
    global cc
    cc += 1
    fobj = obj2(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 5)}, iter: {cc}') 


%time sol= minimize(obj3, xx, bounds=Bd, method='L-BFGS-B', callback=callback, options={'maxiter':1e4, 'maxfun':1e100})


xx = sol.x


# tau_h

xx.reshape(3, i, r)[1, i-1,:]

# tau_w

xx.reshape(3, i, r)[0, i-1,:]

# value of max GDP

Y_f(xx.reshape(3, i, r)).sum()

xx = pd.DataFrame(xx)

xx.to_excel("xx.xlsx")  










