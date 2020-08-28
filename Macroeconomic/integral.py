# -*- coding: utf-8 -*-
"""
Created on Fri Aug 28 14:51:07 2020

@author: Marcos J Ribeiro
"""

import os
import numpy as np
from numpy import linalg as la

os.chdir('D:/Git projects/college_works/Macroeconomic')

n_a = 3
a_grid = np.linspace(0, 1, n_a)

n_y = 2
y_grid = np.linspace(0, 1, n_y)

 
P = np.array(([0.1, 0.1, 0.1], [0.2, 0.2, 0.3]))


Ea = 0
for i_y, y in enumerate(y_grid):
    for i_a, a in enumerate(a_grid):
        Ea +=  a*P[i_y, i_a]
        print(P[i_y, i_a])
        
Ea








