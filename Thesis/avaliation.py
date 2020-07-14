# -*- coding: utf-8 -*-
"""
Created on Tue Jul 14 18:03:53 2020

@author: Marcos J Ribeiro
"""

from Optimization import *




###### Avaliation


# Model

W, p_ir = Wf(z1.reshape(3, i, r))
W = pd.DataFrame(W)
p_ir = pd.DataFrame(p_ir)


# PNAD data

p_t, W_t = simul()   
W_t =  pd.DataFrame(W_t)
p_t =  pd.DataFrame(p_t)


# get colnames

n = pd.read_csv('pt.csv', sep=';')
n = n.iloc[0:7]
n.set_index('ocup', inplace=True)
names = list(n)

# set colnamens

W.columns = names
p_ir.columns = names

W_t.columns = names
p_t.columns = names


# plots

fig, ax = plt.subplots(1, 2, figsize=(12,6))
ax[0].scatter(p_ir, p_t)
ax[0].set_xlabel('p_ir Model')
ax[0].set_ylabel('p_ir PNAD Data')
ax[1].scatter(W, W_t)
ax[1].set_xlabel('W_ir Model')
ax[1].set_ylabel('W_ir PNAD Data')







# z1

tau_w =  pd.DataFrame( z1.reshape(3, i, r)[0] )
tau_w.columns = names


tau_h = pd.DataFrame( z1.reshape(3, i, r)[1] )
tau_h.columns = names

w = pd.DataFrame( z1.reshape(3, i, r)[2] )
w.columns = names




