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

np.around(x1,2)

x1

cons1 = x1[8:12] - 0  

cons = ({'type': 'eq', 'fun': lambda x1: x1[8:12] - 0},
        {'type': 'eq', 'fun': lambda x1: x1[19] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[23] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[0] - x1[1]},
        {'type': 'eq', 'fun': lambda x1: x1[1] - x1[2]},
        {'type': 'eq', 'fun': lambda x1: x1[2] - x1[3]})



sol = minimize(obj, x1.flatten(),  method='trust-constr', 
               bounds = Bd, constraints= cons,
               options={'maxiter':10000, 'verbose':3})

sol.x
sol.fun

  
###### NLopt






opt = nlopt.opt(nlopt.LD_SLSQP, 10)

opt.set_min_objective(obj(x1))

x = opt.optimize(x1.flatten())




