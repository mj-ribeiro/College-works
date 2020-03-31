# -*- coding: utf-8 -*-
"""
Created on Tue Jan 28 20:43:43 2020

@author: Marcos J Ribeiro
"""



        
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd



def ar(x, phi):    
    y_0 = 0   
    lt = []
    for i in range(x):
        e_t = np.random.random()

        y_t =  phi*y_0 + e_t
        y_0 = y_t
        #print(f'\033[1;033m {y_t[i]:.<30} {y_0[i]:.4f}')
        lt.append(y_t)
         
    fig, ax = plt.subplots()
    ax.plot(lt)
    ax.set_xlabel('time')
    ax.set_ylabel('y_t')
    ax.set_title('Autorregressive process')

ar(100, 0.8)


