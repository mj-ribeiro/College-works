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





# L-BFGS-B


def callback(x):
    fobj = obj(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 4)}') 


if __name__ == '__main__':
    
    %time sol= minimize(obj, x1,  method='L-BFGS-B', bounds = Bd, callback=callback, tol=1e-15, options={'maxiter':4e4, 'maxfun':1e1000})
              
    
    sol 
    z1=sol.x 
    sol.fun 
    sol.success
    
    
    obj(z1)






#### Nelder Mead
#trava no 3.57

cc = 0
def callback(x):
    global cc 
    cc = cc + 1
    fobj = obj(x)
    print(f'\033[1;033mObjetivo: {np.around(fobj, 4)}, Iter:{cc}') 

if __name__ == '__main__':

    %time sol2 = minimize(obj, z1,  method='Nelder-Mead', callback=callback, options={'maxiter':1e6})


    
    z1=sol2.x
    sol2.fun
    sol2.success
    
    obj(z1)
 


    k1 = pd.DataFrame(z1)

    k1.to_excel("k1.xlsx")  












