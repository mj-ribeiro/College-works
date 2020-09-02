# -*- coding: utf-8 -*-
"""
Created on Wed Sep  2 17:36:28 2020

@author: Marcos J Ribeiro
"""

import os
import numpy as np
import matplotlib.pyplot as plt

os.chdir('D:/Git projects/college_works/Macroeconomic')



u = lambda c: ( c**(1-delta) - 1 ) / (1-delta)

beta, delta = .9, 2

y_grid = np.array([1, .1])
barA, a_max, n_a = 0, 20, 200
a_grid = np.linspace(-barA, a_max, n_a)








