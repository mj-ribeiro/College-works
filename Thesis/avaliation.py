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
ax.set_xlabel('Wage - Model', fontsize=20)
ax.set_ylabel('Wage - PNAD Data', fontsize=20)
ax.plot([1, 4.1], [1, 4.1], 'k-', lw=2, label='45° line')
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
ax.set_xlabel('Proportion of workers - Model', fontsize=20)
ax.set_ylabel('Proportion of workers - PNAD Data', fontsize=20)
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
names2 = np.array(names2)


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

twg = np.array(W).reshape(i, r)[(i-1), :]/np.array(W).reshape(i, r).sum(axis=0)
 


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

  




## increase one unit in tau_h and effect in gpd

dd = np.arange(0,21)

n = len(dd) 
Y_th = np.zeros((n))


for nn in dd: 
    g1 = z1[0] 
    g2 = z1[1] + nn
    g3 = z1[2]
    G = np.array([g1, g2, g3])
    Y_th[nn] = Y_f(G).sum() 
    


plt.plot(dd, Y_th)
plt.xticks(np.arange(min(dd), max(dd)+2, 2.0))
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid()
plt.xlabel(r"Increases in $\tau^h_{ir}$", fontsize=20)
plt.ylabel("GDP - model", fontsize=20)
plt.tight_layout()    





## increase one unit in tau_w and effect in gpd



bb = np.arange(-20, 1)
n = len(bb) 
Y_tw = []



for nn in bb: 
    c1 = z1[0] + nn
    c2 = z1[1] 
    c3 = z1[2]
    C = np.array([c1, c2, c3])
    Y_tw.append(Y_f(C).sum())  
    
plt.plot(bb, Y_tw)
plt.xticks(np.arange(min(bb), max(bb)+2, 2.0))
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid()
plt.xlabel(r"Increases in $\tau^w_{ir}$ ", fontsize=20)
plt.ylabel("GDP - model", fontsize=20)
plt.tight_layout()    




# z1

n = pd.read_csv('pt.csv', sep=';')
n = n.iloc[0:7]
n.set_index('ocup', inplace=True)
names = n.columns.str.strip("'")



tau_w =  pd.DataFrame( z1.reshape(3, i, r)[0] )
tau_w.columns = names


tau_h = pd.DataFrame( z1.reshape(3, i, r)[1] )
tau_h.columns = names

w = pd.DataFrame( z1.reshape(3, i, r)[2] )
w.columns = names



###### exercise 1


gdp2 = Y_f(z1).sum(axis=0)
names2


names2[gdp2.argsort()[-3:][::-1]] # get 3 largest gdps


names2[np.argsort(H_trf(z1))[-3:][::-1]]  # get the 3 largest ATHC


 
# I put the frictions of RO because RO have the largest ATHC
 

jj = np.array(z1, copy=True)

for vv in range(27):
    jj[0, :, vv] = jj[0,:,0]


for vv in range(27):
    jj[1, :, vv] = jj[1,:,0]



gpd_z1 = Y_f(z1).sum(axis=0)
gpd_c = Y_f(jj).sum(axis=0)



plt.scatter(gpd_z1, gpd_c)
plt.yticks(fontsize=20)
plt.xticks(fontsize=20)
for tt, txt in enumerate(names2):
    plt.annotate(txt, (gpd_z1[tt], gpd_c[tt]), size=20)                                                    
plt.grid(True)
plt.xlabel("GDP before change friction - model", fontsize=20)
plt.ylabel("GDP after change friction highest - model", fontsize=20)
plt.tight_layout()    
plt.plot([4.4, 7], [4.4, 7], 'k-', lw=2, label='45° line')
plt.legend(loc="upper left", prop={'size': 20})




Y_f(z1).sum()

Y_f(jj).sum()   # GDP of all states after change 

# Put the distortion of RO the total GDP increase 



################### exercise 2


jj2 = np.array(z1, copy=True)




# the smallest ATHC is SP

names2[np.argmin(H_trf(z1))]



for vv in range(27):
    jj2[0, :, vv] = jj2[0,:,19]


for vv in range(27):
    jj2[1, :, vv] = jj2[1, :, 19]



gpd_z1 = Y_f(z1).sum(axis=0)
gpd_c2 = Y_f(jj2).sum(axis=0)


plt.subplots(figsize=(10,8))  
plt.scatter(gpd_z1, gpd_c2)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
for tt, txt in enumerate(names2):
    plt.annotate(txt, (gpd_z1[tt], gpd_c2[tt]), size=20)                                                    
plt.grid(True)
plt.xlabel("GDP before change friction - model", fontsize=20)
plt.ylabel('GDP after placing state distortions \n with smallest ATHC - model', fontsize=20)
plt.tight_layout()    
plt.plot([4.4, 7], [4.4, 7], 'k-', lw=2, label='45° line')
plt.legend(loc="upper left", prop={'size': 20})



Y_f(z1).sum()

Y_f(jj2).sum()   # GDP of all states after change 




### END

  
