# -*- coding: utf-8 -*-
"""
Created on Fri Jun 19 15:23:08 2020

@author: Marcos J Ribeiro
"""
# see:  https://notes.quantecon.org/submission/5b3db2ceb9eab00015b89f93

import os
os.getcwd()
os.chdir('D:\\Git projects\\college_works\\Thesis')


from H_test import *
from scipy.optimize import minimize
import pandas as pd



x1 = taus2()
obj(x1)


res = calibration(500, taus2())


#### Nelder Mead

def callback(x):
    fobj = obj(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 4)}') 


sol = minimize(obj, x1,  method='Nelder-Mead', callback=callback,
               options={'maxiter':1e5})


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



def hessp(x, l):
    return np.zeros((3, i, r))



print('\033[1;033m')
sol = minimize(obj, x1.flatten(),  method='trust-constr',
               constraints= cons, bounds=Bd, hessp=hessp,
               options={'maxiter':10000, 'verbose':3,
                         'xtol': 1e-4, 
                         'gtol': 1e-4, 
                         'barrier_tol': 1e-4})





# L-BFGS-B
 
opt = 50
z1=x1

c = 0
while opt>2:
    start = time.time()
    sol= minimize(obj, z1,  method='L-BFGS-B', bounds = Bd, options={'maxiter':20000, 'maxfun':1000})
    end = time.time()
    opt = sol.fun
    z1 = sol.x 
    c = c +  1
    print(f'\033[1;033mIteração:{c}, Objetivo: {np.around(opt, 4)}, sucesso: {sol.success}, Elapsed time: {np.around((end - start), 2)}')

 

sol 
z1=sol.x 
sol.fun
sol.success

z1
x1.reshape((3, 7, 27))[2, :, 26] 
taus2()
obj(z1)

obj2(z1) 


#see: https://stackoverflow.com/questions/38648727/scipy-optimize-minimize-is-taking-too-long



print('\033[1;033m')
sol= minimize(obj, z1,  method='SLSQP', bounds = Bd,
                    options={'maxiter':20000, 'iprint':2,'disp': True})









