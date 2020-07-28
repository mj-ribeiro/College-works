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


z1 = pd.read_excel('z1.xlsx') 

z1 = np.array(z1)


x1 = taus2()

obj2(z1)


# L-BFGS-B

cc = 0
def callback(x):
    global cc
    cc += 1
    fobj = obj2(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 5)}, iter: {cc}') 

    
%time sol= minimize(obj2, z1,  method='L-BFGS-B', bounds = Bd, callback=callback, tol=1e-15, options={'maxiter':1e4, 'maxfun':1e1000,  'maxcor': 100, 'eps': 1e-08,})
    
          

sol 
z1 = sol.x 
sol.fun 
sol.success


obj2(z1)


#### Nelder Mead



cc = 0
def callback(x):
    global cc
    cc += 1
    fobj = obj2(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 5)}, iter: {cc}') 




%time sol2 = minimize(obj2, z1,  method='Nelder-Mead', callback=callback, options={'maxiter':1e6})



z1=sol2.x
sol2.fun
sol2.success

obj2(z1)
 

 

kk1 = pd.DataFrame(z1)

kk1.to_excel("z1.xlsx")  



