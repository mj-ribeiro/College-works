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


def stat_dist2(pi):
    pos = np.array(np.where(np.linalg.eig(pi)[0] == 1) ).reshape(1)
    eig_vec = np.linalg.eig(pi)[1][:,pos]
    stat_dist = eig_vec/np.sum(eig_vec)
    print(f'Stationary dist. of \pi is given by: \n {stat_dist}')



### outro jeito de fazer

def pi_stat(x, pi):
    pi_100 = pi
    for i in range(x):
        pi_100 = np.dot(pi, pi_100)
    return pi_100[0, :]

pi_stat(100, pi)















