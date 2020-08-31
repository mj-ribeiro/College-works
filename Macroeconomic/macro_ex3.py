# -*- coding: utf-8 -*-
"""
Created on Mon Aug 31 15:26:22 2020

@author: Marcos J Ribeiro
"""
import os
import numpy as np
import matplotlib.pyplot as plt

os.chdir('D:/Git projects/college_works/Macroeconomic')





# parameters

def pars():
    global beta, sig, delta, alfa, pi
    beta = 0.98
    sig = 2
    delta = 0.08
    alfa = 0.44
    pi = np.array(([0.4, 0.5, 0.1],
                   [0.3, 0.2, 0.5],
                   [0.2, 0.4, 0.4]))





# Utility Function

util = lambda x: (x**sig - 1)/(1-sig)



# Production function


def prod(k, l):
    return k**alfa*l**(1-alfa)








