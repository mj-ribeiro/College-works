# -*- coding: utf-8 -*-
"""
Created on Thu Aug 27 21:25:32 2020

@author: Marcos J Ribeiro
"""

import os
import numpy as np
from numpy import linalg as la

os.chdir('D:/Git projects/college_works/Macroeconomic')



# create Markov Chain


# Exercise 1 A

def markov(x):
    pi = np.array(([2/3, 1/3], [1/3, 2/3]))
    PI_0 = np.array(([5/6, 1/6]))
    for i in range(x):
        PI_1 = np.dot(pi, PI_0)
        PI_0 = PI_1
        print(f'\033[1;033m {PI_0}')

markov(15)


# Exercise 1 B


# function to normalize vectors

def normalize(v):
    a = la.eig(v)[1]
    norm = la.norm(a)
    if norm == 0: 
       return a
    return a / norm



def markov2(x, pi):
    g = normalize(pi)
    PI_0 = np.array(([5/6, 1/6]))
    for i in range(x):
        PI_1 = np.dot(g[:,0], PI_0)
        PI_0 = PI_1
        print(f'\033[1;033m {PI_0}')
    return PI_0

    
markov2(200, pi)













