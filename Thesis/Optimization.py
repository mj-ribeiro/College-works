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

pd.DataFrame(x1[2])

#### Nelder Mead



sol = minimize(obj, x1,  method='Nelder-Mead', 
               options={'maxiter':50})

sol.x
sol.fun
sol.success

#####  trust-constr 


# constraints

 
cons = ({'type': 'eq', 'fun': lambda x1: x1[189:215] - 0},        
        {'type': 'eq', 'fun': lambda x1: x1[404] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[431] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[458] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[485] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[512] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[539] - 1},
        {'type': 'eq', 'fun': lambda x1: x1[566] - 1},        
        {'type': 'eq', 'fun': lambda x1: x1[0] - x1[1]},
        {'type': 'eq', 'fun': lambda x1: x1[1] - x1[2]},
        {'type': 'eq', 'fun': lambda x1: x1[2] - x1[3]},
        {'type': 'eq', 'fun': lambda x1: x1[3] - x1[4]},
        {'type': 'eq', 'fun': lambda x1: x1[4] - x1[5]},
        {'type': 'eq', 'fun': lambda x1: x1[5] - x1[6]},
        {'type': 'eq', 'fun': lambda x1: x1[6] - x1[7]},
        {'type': 'eq', 'fun': lambda x1: x1[7] - x1[8]},
        {'type': 'eq', 'fun': lambda x1: x1[8] - x1[9]},
        {'type': 'eq', 'fun': lambda x1: x1[9] - x1[10]},
        {'type': 'eq', 'fun': lambda x1: x1[10] - x1[11]},
        {'type': 'eq', 'fun': lambda x1: x1[11] - x1[12]},
        {'type': 'eq', 'fun': lambda x1: x1[12] - x1[13]},
        {'type': 'eq', 'fun': lambda x1: x1[13] - x1[14]},
        {'type': 'eq', 'fun': lambda x1: x1[14] - x1[15]},
        {'type': 'eq', 'fun': lambda x1: x1[15] - x1[16]},
        {'type': 'eq', 'fun': lambda x1: x1[16] - x1[17]},
        {'type': 'eq', 'fun': lambda x1: x1[17] - x1[18]},
        {'type': 'eq', 'fun': lambda x1: x1[18] - x1[19]},
        {'type': 'eq', 'fun': lambda x1: x1[19] - x1[20]},
        {'type': 'eq', 'fun': lambda x1: x1[20] - x1[21]},
        {'type': 'eq', 'fun': lambda x1: x1[21] - x1[22]},
        {'type': 'eq', 'fun': lambda x1: x1[22] - x1[23]},
        {'type': 'eq', 'fun': lambda x1: x1[23] - x1[24]},
        {'type': 'eq', 'fun': lambda x1: x1[24] - x1[25]},
        {'type': 'eq', 'fun': lambda x1: x1[25] - x1[26]},
        )




# optimization

Bd = ((-0.99, 0.999), )*189 + ((-0.99, 40), )*189 + ((0.001, 30), )*189
Bd = np.array(Bd)



print('\033[1;033m')
sol = minimize(obj, x1.flatten(),  method='trust-constr', 
               constraints= cons, bounds=Bd,
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








