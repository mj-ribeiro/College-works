# -*- coding: utf-8 -*-
"""
Created on Fri Jun 19 15:23:08 2020

@author: Marcos J Ribeiro
"""
import nlopt 
from Hsieh_model import *
from scipy.optimize import minimize


x1 = taus2()

res = calibration(5000, taus2())

#### Nelder Mead



sol = minimize(obj, x1,  method='Nelder-Mead', options={'maxiter':1000})

sol.x
sol.fun


#####  trust-constr 

sol = minimize(obj, x1.flatten(),  method='trust-constr', 
               bounds = Bd, 
               options={'maxiter':1000})

sol.x
sol.fun


###### NLopt





opt = nlopt.opt(nlopt.LD_SLSQP, 10)

opt.set_min_objective(obj(x1))

x = opt.optimize(x1.flatten())




