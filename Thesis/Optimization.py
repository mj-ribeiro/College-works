# -*- coding: utf-8 -*-
"""
Created on Fri Jun 19 15:23:08 2020

@author: Marcos J Ribeiro
"""
# see:  https://notes.quantecon.org/submission/5b3db2ceb9eab00015b89f93

import os
os.getcwd()
os.chdir('D:\\Git projects\\college_works\\Thesis')


from Hsieh_model import *
from scipy.optimize import minimize
import pandas as pd



x1 = taus2()
obj(x1)

res = calibration(500, taus2())


#### Nelder Mead



sol = minimize(obj, x1,  method='Nelder-Mead', 
               options={'maxiter':1000})

sol.x
sol.fun


#####  trust-constr 

Bd
# constraints

cons = ({'type': 'eq', 'fun': lambda x1: x1[8:12] - 0},
        {'type': 'eq', 'fun': lambda x1: x1[19] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[23] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[0] - x1[1]},
        {'type': 'eq', 'fun': lambda x1: x1[1] - x1[2]},
        {'type': 'eq', 'fun': lambda x1: x1[2] - x1[3]})


# optimization


print('\033[1;033m')
sol = minimize(obj, x1.flatten(),  method='trust-constr', 
               bounds = Bd, constraints= cons,
               options={'maxiter':10000, 'verbose':3,
                         'xtol': 1e-10, 
                         'gtol': 1e-10, 
                         'barrier_tol': 1e-10})

x1=sol.x
sol.fun

sol.x
sol = minimize(obj, x1,  method='trust-constr', 
               bounds = Bd, constraints= cons,
               options={'maxiter':10000, 'verbose':3,
                         'xtol': 1e-10, 
                         'gtol': 1e-10, 
                         'barrier_tol': 1e-10})








