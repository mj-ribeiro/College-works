# -*- coding: utf-8 -*-
"""
Created on Tue Aug 18 20:39:49 2020

@author: Marcos J Ribeiro
"""

import numpy as np
from math import log as log

k_grid = np.array( [0.04, 0.08, 0.12, 0.16, 0.2] )
n_k = len(k_grid)
alpha, beta = 0.3, 0.6

## Contruindo uma 'lista' para armazenar a sequencia de funções valor 
v_n = [np.zeros( n_k )]
print('v_n = ',v_n)

## construindo a matriz que armzena a função objetivo para cada (k,k')
f_obj = np.zeros( (n_k,n_k) )
##print('V = \n',V)

for i in range(n_k):
    for j in range(n_k):
        f_obj[i,j] = log(k_grid[i]**alpha - k_grid[j]) + beta*v_n[0][j]
##    print('V = \n',V)
##    print()


## fazendo a otimização (aplicando o operador de Bellman) para obter $v_{n+1}$
Tv = np.zeros ( n_k )
for i in range(n_k):
    Tv[i] = max(f_obj[i,:])
v_n.append(Tv)


##print('v_n = ',v_n)
#### não ficou muito bom. Vamos imprimir de novo a $v_n$
print('v_n = ')
for i in range(2):
    print(v_n[i])

## Iteração até a convergência ##
""" Agora vamos repetir a aplicação do operador de Bellman até a
    convergência"""

v_n = [np.zeros( n_k )]

norma, tol_n = 1.0, 1e-2
it, tol_it = 0, 7

while norma>tol_n:
    ## Construindo a função objetivo
    f_obj = np.zeros( (n_k,n_k) )
    for i in range(n_k):
        for j in range(n_k):
            f_obj[i,j] = log(k_grid[i]**alpha - k_grid[j]) + beta*v_n[it][j]

    ## Aplicando o operador de Bellman e armazenando a nova $v$ em v_n
    Tv = np.zeros ( n_k )
    for i in range(n_k):
        Tv[i] = max(f_obj[i,:])
    v_n.append(Tv)
    
    norma = max(abs(Tv-v_n[it]))
    print(f'\033[1;033mNorma = {np.around(norma,4)}, it = {it}')
    it = it + 1



###### vamos visualizar a sequência de funções
import matplotlib.pyplot as plt
ab = alpha*beta
A = (1/(1-beta))*(ab/(1-ab)*log(ab) + log(1-ab))
B = alpha/(1-ab)
v = np.zeros( n_k )
for i in range(n_k):
    v[i] = A+B*log(k_grid[i])

fig, ax = plt.subplots()
for i in range( len(v_n) ):
    ax.plot(k_grid,v_n[i],'-o',label='$v_{}$'.format(i))
##ax.plot(k_grid,v,'-o',label='v')
### vamos deixar a função verdadeira mais evidente
ax.plot(k_grid,v,'-',lw=5,label='v')
ax.legend()
plt.show()


v_n
