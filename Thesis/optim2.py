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



x1 = taus2()

obj(x1)





# L-BFGS-B


def callback(x):
    fobj = obj2(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 4)}') 


    
%time sol= minimize(obj2, z1,  method='L-BFGS-B', bounds = Bd, callback=callback, tol=1e-15, options={'maxiter':1e5, 'maxfun':1e1000})

          

sol 
z1 = sol.x 
sol.fun 
sol.success


obj(z1)




#### Nelder Mead


def callback(x):
    fobj = obj(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 4)}') 


%time sol2 = minimize(obj, z1,  method='Nelder-Mead', callback=callback, options={'maxiter':1e6})



z1=sol2.x
sol2.fun
sol2.success

obj(z1)
 
 

k1 = pd.DataFrame(z1)

k1.to_excel("z1.xlsx")  



