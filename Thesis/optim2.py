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

z1 = taus2()

tt = pd.read_excel('teste.xlsx') 

tt = np.array(tt)

obj2(tt)
obj2(z1)


z1.reshape(3, i, r)[2, 0,:] 

tt.reshape(3, i, r)[2, 0,:] 


z1.reshape(3, i, r)[0, 1,:] 

tt.reshape(3, i, r)[0, 1,:] 


# L-BFGS-B

cc = 0
def callback(x):
    global cc
    cc += 1
    fobj = obj2(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 5)}, iter: {cc}') 

    
%time sol= minimize(obj2, z1,  method='L-BFGS-B', bounds = Bd, callback=callback, tol=1e-20, options={'maxiter':1e4, 'maxfun':1e100,  'maxcor': 100, 'eps': 1e-08,})



sol 
z1 = sol.x 
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

 
%time sol2 = minimize(obj2, tt,  method='Nelder-Mead', tol=1e-2, callback=callback, options={'maxiter':3e5})



tt=sol2.x
sol2.fun
sol2.success

obj2(np.array(z1))
 
 

z1 = pd.DataFrame(z1)

z1.to_excel("MG_8.xlsx")  


tt = pd.DataFrame(tt)
tt.to_excel('teste.xlsx')







