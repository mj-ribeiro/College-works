# -*- coding: utf-8 -*-
"""
Created on Fri Jun 19 15:23:08 2020

@author: Marcos J Ribeiro
"""
import nlopt 
from Hsieh_model import *
from scipy.optimize import minimize


x1 = taus2()
obj(x1)

res = calibration(5000, taus2())


#### Nelder Mead



sol = minimize(obj, x1,  method='Nelder-Mead',bounds = Bd, 
               options={'maxiter':1000})

sol.x
sol.fun


#####  trust-constr 


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

sol = minimize(obj, x1,  method='trust-constr', 
               bounds = Bd, constraints= cons,
               options={'maxiter':10000, 'verbose':3,
                         'xtol': 1e-10, 
                         'gtol': 1e-10, 
                         'barrier_tol': 1e-10})


###### NLopt





