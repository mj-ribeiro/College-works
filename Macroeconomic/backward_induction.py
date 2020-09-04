# -*- coding: utf-8 -*-
"""
Created on Wed Sep  2 17:36:28 2020

@author: Marcos J Ribeiro
"""

import os
import numpy as np
import matplotlib.pyplot as plt

os.chdir('D:/Git projects/college_works/Macroeconomic')



util = lambda c: ( c**(1-delta) - 1 ) / (1-delta)

beta, delta = .9, 2
 
#y_grid = np.array([1, .1])
y_max, y_min, n_y = 0, 2, 5
y_grid = np.linspace(y_max, y_min, n_y)

barA, a_max, n_a = 0, 20, 200
a_grid = np.linspace(-barA, a_max, n_a)


##### Problem in t = 2



obj2 = np.zeros((n_a, n_a))
V3 = np.zeros((n_a))

for i_a2, a2 in enumerate(a_grid):
    for i_aa3, aa3 in enumerate(a_grid):
        c = y_grid[1] + a2 - aa3
        
        if c<=0:
            obj2[i_a2, i_aa3] = -np.inf
        else:
            obj2[i_a2, i_aa3] = util(c) + beta*V3[i_a2]


V2 = np.amax(obj2, axis=1)
V2



### Problem in t = 1


obj1 = np.zeros((n_a, n_a))

for i_a1, a1 in enumerate(a_grid):
    for i_aa2, a2 in enumerate(a_grid):
        c = y_grid[0] + a1 - a2
        
        if c<=0:
            obj1[i_a1, i_aa2] = -np.inf
        else:
            obj1[i_a1, i_aa2] = util(c) + beta*V2[i_a1]


V1 = np.amax(obj1, axis=1)




### Problem in t=10

T=10
y_grid = np.ones(T)
y_grid[-1] = 0
y_grid[-2] = 0
y_grid[-3] = 0



V = np.zeros((T+1, n_a))
iG = np.zeros((T, n_a), dtype=np.int)
obj = np.zeros((n_a, n_a))

for i_y in range(T, 0, -1):
    for i_a, a in enumerate(a_grid):
        for i_aa, aa in enumerate(a_grid):
            c = y_grid[i_y-1] + a - aa
            if c<=0:
                obj[i_a, i_aa] = -np.inf
            else:
                obj[i_a, i_aa] = util(c) + beta*V[i_y, i_aa]
                #print(f'obj = {obj}')
    V[i_y-1] = np.amax(obj, axis=1)
    iG[i_y-1] = np.argmax(obj, axis=1) 

V 


V
iG




for i in range(T):
    plt.plot(a_grid, V[i], label=f'V_{i}')
plt.legend(fontsize=15)
plt.xticks(fontsize=18)
plt.yticks(fontsize=18)


## path

G = a_grid[iG]



for t in range(n_y-1):
    plt.plot(a_grid, G[t, :],label=f'$g_{t+1}(a)$')
plt.plot(a_grid, a_grid, label='45o')
plt.legend(fontsize=15)
plt.xticks(fontsize=18)
plt.yticks(fontsize=18)
plt.show()


T = 10

ia_t = np.zeros( T+1, dtype=np.int )
a_t = np.zeros( T+1 )

ia_t[0] = 0
a_t[0] = a_grid[ ia_t[0] ]


for t in range(1,T):
    print(t)
    ia_t[t] = iG[t-1,  ia_t[t-1]]
    a_t[t] = a_grid[ ia_t[t] ]
    
plt.plot(range(T+1), a_t)

c_t = np.zeros(T)
for i in range(T):
    c_t[i] = y_grid[i] + a_t[i] -a_t[i+1]



figure, ax = plt.subplots()
plt.plot(range(T+1), a_t, label='riqueza')
plt.plot(range(T), y_grid, 'o',label='renda')
plt.plot(range(T), c_t, '--',label='consumo', color='green')
plt.legend(loc='best', fontsize=15)
plt.xticks(fontsize=18)
plt.yticks(fontsize=18)
plt.show()


c_t

