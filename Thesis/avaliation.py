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



z1 = pd.read_excel('z1.xlsx') # i replace z1 by k1 to test

z1 = np.array(z1)

z1 = z1.reshape(3, i, r)


np.exp( obj2(z1) )



# Model

W, p_ir = Wf(z1.reshape(3, i, r))

 
# PNAD data

p_t, W_t = simul()   


# get colnames

n = pd.read_csv('pt.csv', sep=';')
n = n.iloc[0:7]
n.set_index('ocup', inplace=True)
names = n.columns.str.strip("'")
names  = np.array(names).repeat(7) 





### W and W_ir

W_t =  pd.DataFrame(W_t)
W = pd.DataFrame(W)


W = W.values.flatten()
W_t = W_t.values.flatten()


ocn1 = ['oc1','oc2','oc3','oc4','oc5','oc6','oc7']
ocn1 = np.array(ocn1, dtype=object).repeat(27)

dd = pd.DataFrame(dict(x=W, y=W_t, label=ocn1))
groups = dd.groupby('label')


fig, ax = plt.subplots()
ax.margins(0.05) # Optional, just adds 5% padding to the autoscaling
for ocn1, group in groups:
    ax.plot(group.x, group.y, marker='o', linestyle='', ms=12, label=ocn1)
ax.xaxis.set_tick_params(labelsize=20)
ax.yaxis.set_tick_params(labelsize=20)
for ii, txt in enumerate(names):
    ax.annotate(txt, (W[ii], W_t[ii]), size=20) 
ax.set_xlabel('W_ir Model', fontsize=20)
ax.set_ylabel('W_ir PNAD Data', fontsize=20)
ax.plot([1, 4.5], [1, 4.5], 'k-', lw=2, label='45° line')
ax.grid(True)
plt.tight_layout()    
ax.legend( prop={'size': 18})



## p_ir and p_t

p_t =  pd.DataFrame(p_t)
p_ir = pd.DataFrame(p_ir)


p_t = p_t.values.flatten() 
p_ir = p_ir.values.flatten()

ocn = ['oc1','oc2','oc3','oc4','oc5','oc6','oc7']
ocn = np.array(ocn, dtype=object).repeat(27)


ff = pd.DataFrame(dict(x=p_ir, y=p_t, label=ocn))
groups2 = ff.groupby('label')

fig, ax = plt.subplots()
ax.margins(0.05) 
for ocn, group in groups2:
    ax.plot(group.x, group.y, marker='o', linestyle='', ms=12, label=ocn)
ax.xaxis.set_tick_params(labelsize=20)
ax.yaxis.set_tick_params(labelsize=20)
for ii, txt in enumerate(names):
    ax.annotate(txt, (p_ir[ii], p_t[ii]), size=20) 
ax.set_xlabel('p_ir Model', fontsize=20)
ax.set_ylabel('p_ir PNAD Data', fontsize=20)
ax.plot([0, 0.5], [0, 0.5], 'k-', lw=2, label='45° line')
ax.grid(True)
plt.tight_layout()    
ax.legend( prop={'size': 18})


 

## tpf and GDP plots - fig 3

Y = Y_f(z1).sum(axis=0)
tpf = z1[2, 0, :]
names2 = n.columns.str.strip("'")



plt.scatter(tpf, Y, s=10)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
(m, b) = np.polyfit(tpf, Y, 1)
yp = np.polyval([m, b], tpf)
plt.plot(tpf, yp, label='Regression Line')
for tt, txt in enumerate(names2):
    plt.annotate(txt, (tpf[tt], Y[tt]), size=20) 
plt.grid(True)
plt.legend(loc="lower right", prop={'size': 20})
plt.xlabel(" TFP - model", fontsize=20)
plt.ylabel("GDP per worker - model", fontsize=20)
plt.tight_layout()    
 




# gpd per worker and hc - fig5

H_tr = H_trf(z1)
Y = Y_f(z1).sum(axis=0)
names2 = n.columns.str.strip("'")


plt.scatter(H_tr, Y, s=10)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
(m, b) = np.polyfit(H_tr, Y, 1)
yp = np.polyval([m, b], H_tr)
plt.plot(H_tr, yp, label='Regression Line')
for tt, txt in enumerate(names2):
    plt.annotate(txt, (H_tr[tt], Y[tt]), size=20) 
plt.grid(True)
plt.legend(loc="lower right", prop={'size': 20})
plt.xlabel(" Human capital of teachers - model", fontsize=20)
plt.ylabel("GDP per worker - model", fontsize=20)
plt.tight_layout()    
 




## p_ir x teachers wage - fig4


p_tr = p_trf(z1)
twg = np.divide(z1[2, i-1, :], z1[2].sum(axis=0) )


names2 = n.columns.str.strip("'")

 
plt.scatter(twg, p_tr, s=10)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
(m, b) = np.polyfit(twg, p_tr, 1)
yp = np.polyval([m, b], twg)
plt.plot(twg, yp, label='Regression Line')
for tt, txt in enumerate(names2):
    plt.annotate(txt, (twg[tt], p_tr[tt]), size=20) 
plt.grid(True)
plt.legend(loc="upper left", prop={'size': 20})
plt.xlabel(" Teachers wage relative to other occupations - model", fontsize=20)
plt.ylabel("Proportion of teachers - model", fontsize=20)
plt.tight_layout()    

  






# z1

tau_w =  pd.DataFrame( z1.reshape(3, i, r)[0] )
tau_w.columns = names


tau_h = pd.DataFrame( z1.reshape(3, i, r)[1] )
tau_h.columns = names

w = pd.DataFrame( z1.reshape(3, i, r)[2] )
w.columns = names

 