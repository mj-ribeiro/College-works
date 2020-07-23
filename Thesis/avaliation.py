# -*- coding: utf-8 -*-
"""
Created on Tue Jul 14 18:03:53 2020

@author: Marcos J Ribeiro
"""

#from Optimization import *
import os
os.getcwd()
os.chdir('D:\\Git projects\\college_works\\Thesis')
from Hsieh_V2 import *

taus2()


###### Avaliation



z1 = pd.read_excel('z1.xlsx')

z1 = np.array(z1)

z1 = z1.reshape(3, i, r)


np.exp( obj(z1) )



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
names = n.columns.str.strip("'")




names  = np.array(names).repeat(7) 



p_t = p_t.values.flatten() 
p_ir = p_ir.values.flatten()

W = W.values.flatten()
W_t = W_t.values.flatten()

# plots

fig, ax = plt.subplots(1, 2, figsize=(12,6))
ax[0].scatter(p_ir, p_t, s=0)
ax[0].xaxis.set_tick_params(labelsize=20)
ax[0].yaxis.set_tick_params(labelsize=20)
for i, txt in enumerate(names):
    ax[0].annotate(txt, (p_ir[i], p_t[i]), size=20) 
ax[0].set_xlabel('p_ir Model', fontsize=20)
ax[0].set_ylabel('p_ir PNAD Data', fontsize=20)
ax[0].plot([0, 0.5], [0, 0.5], 'k-', lw=2)
ax[0].grid(True)
ax[1].scatter(W, W_t, s=0)
ax[1].xaxis.set_tick_params(labelsize=20)
ax[1].yaxis.set_tick_params(labelsize=20)
for i, txt in enumerate(names):
    ax[1].annotate(txt, (W[i], W_t[i]), size=20) 
ax[1].set_xlabel('W_ir Model', fontsize=20)
ax[1].set_ylabel('W_ir PNAD Data', fontsize=20)
ax[1].plot([1, 4.5], [1, 4.5], 'k-', lw=2)
ax[1].grid(True)
plt.tight_layout()    

 




## tpf and GDP plots

Y = Y_f(z1)
tpf = z1[2].sum(axis=0) 
names2 = n.columns.str.strip("'")



plt.scatter(tpf, Y, s=10)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
(m, b) = np.polyfit(tpf, Y, 1)
yp = np.polyval([m, b], tpf)
plt.plot(tpf, yp, label='Regression Line')
for i, txt in enumerate(names2):
    plt.annotate(txt, (tpf[i], Y[i]), size=20) 
plt.grid(True)
plt.legend(loc="lower left", prop={'size': 20})
plt.xlabel("Log of TFP - model", fontsize=20)
plt.ylabel("GDP per worker - model", fontsize=20)
plt.tight_layout()    





# z1

tau_w =  pd.DataFrame( z1.reshape(3, i, r)[0] )
tau_w.columns = names


tau_h = pd.DataFrame( z1.reshape(3, i, r)[1] )
tau_h.columns = names

w = pd.DataFrame( z1.reshape(3, i, r)[2] )
w.columns = names

 