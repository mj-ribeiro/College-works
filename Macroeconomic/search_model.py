# -*- coding: utf-8 -*-
"""
Created on Thu Sep 17 15:18:09 2020

@author: Marcos J Ribeiro
"""


import numpy as np
import matplotlib.pyplot as plt

###############################################################################
# Funções
###############################################################################
def u(c):
    assert sigma < 1
    return ( c**(1-sigma) - 1 ) / (1-sigma)
###############################################################################
def f_aux(w):
    return ( alpha*w_min**alpha ) / ( w**(alpha+1) )
###############################################################################
def f(w):
    return f_aux(w) / sum([f_aux(x) for x in w_grid])
###############################################################################
def defina_parametros_objetos():
    global beta, sigma, pi, alpha, b, v, g, w_grid, n_w, w_min, w_max
    beta, sigma, b = .9, 1/2, 0
    pi, alpha = .10, 1/2
    
    w_min, w_max, n_w = 1, 10, 15
    w_grid = np.linspace(w_min, w_max, n_w)
    
    v = np.zeros( n_w )
    g = np.zeros( n_w , dtype = int)

###############################################################################

def plot_f():
    grid = np.linspace(w_min, w_max, 100*n_w)
    plt.plot(grid, [f_aux(x) for x in grid])
    plt.bar(w_grid, [f(x) for x in w_grid])
    plt.gca().set_xlabel('$w$')
    plt.gca().set_ylabel('$f(w)$')
    plt.show()

###############################################################################

def calcule_v_g():
    global v, g
    T_v = np.zeros( n_w )
    norm, tol = 2, 1e-5
    while norm>tol:
        for i_w, w in enumerate(w_grid):
            accept = u(w) + beta*( pi*v[0] + (1-pi)*v[i_w] )
            E_v = sum( [v[i_ww]*f(ww) for i_ww, ww in enumerate(w_grid) ] )
            reject = u(b) + beta*E_v
            if accept >= reject:
                g[i_w] = 1
                T_v[i_w] = accept
            else:
                g[i_w] = 0
                T_v[i_w] = reject
            norm = np.max( abs(v-T_v) )
            v = np.copy( T_v )
    return v, g
###############################################################################

plt.plot(np.arange(0, 1, 0.01), f_aux(np.arange(0, 1, 0.01)) )




def plot_v_g():
    plt.plot(w_grid, v,'o',label='$v(w)$')
    plt.legend()
    plt.gca().set_xlabel('$w$')
    plt.gca().set_ylabel('$v(w)$')
    plt.gca().set_ylim(0,)
    plt.gca().twinx().plot(w_grid, g,'x',label='$g(w)$')
    plt.legend()
    plt.show()
###############################################################################

######################
# Transition Function
def construa_M(g):
    M = np.zeros( (n_w, n_w) )
    for i in range(n_w):
        for j, w_j in enumerate(w_grid):
            if g[i]==0:
                M[i, j] = f(w_j)
            elif g[i]==1:
                M[i, j] = pi if j==0 else (1-pi) if j==i else 0
                # if j==0:
                #     M[i, j] = pi
                # else:
                #     M[i, j] = (1-pi) if j==i else 0
                #     # if i==j:
                #     #     M[i, j] = 1-pi
                #     # else:
                #     #     M[i, j] = 0
    return M
#########################
# Invariant distribution
def construa_barM(M):
    barM = np.ones( n_w )/n_w
    norm_barM, tol_barM = 1, 1e-6
    while norm_barM>tol_barM:
        new_barM = np.dot(barM, M)
        norm_barM = np.max( abs(new_barM - barM ) )
        barM = new_barM
    return barM
###############################################################################
defina_parametros_objetos()
calcule_v_g()
plot_v_g()
M = construa_M(g)
barM = construa_barM(M)


plt.bar(w_grid, barM, label='Distribuição salarial')
plt.plot(w_grid, [f(w) for w in w_grid], 'ro',label='Ofertas salariais')
plt.gca().set_xlabel('$w$')
plt.legend()
plt.show()

###############################################################################
def plot_distribuicao_salarial():
    plt.bar(w_grid, barM, label='Distribuição salarial')
    plt.plot(w_grid, [f(w) for w in w_grid], 'ro',label='Ofertas salariais')
    plt.gca().set_xlabel('$w$')
    plt.legend()
    plt.show()
###############################################################################


#########################
# Nível de emprego
tx_emprego = sum( [g[i]*barM[i] for i in range(n_w)] )
# tx_emprego = 0
# for i in range(n_w):
#     tx_emprego += g[i]*barM[i]
#     # if g[i]==1:
#     #     tx_emprego += barM[i]
tx_desemprego = 1-tx_emprego

###############################################################################
def taxa_desemprego():
    tx_emprego = sum( [g[i]*barM[i] for i in range(n_w)] )
    return 1 - tx_emprego


###############################################################################
defina_parametros_objetos()
eps = 1e-2
pi_grid = np.linspace(eps,.4-eps, 20)
w_res = []
for i_pi, pi in enumerate(pi_grid):
    v, g = calcule_v_g()
    M = construa_M(g)
    barM = construa_barM(M)

    i_w_reserva = np.argmax(g)
    w_reserva =  w_grid[ i_w_reserva ]
    w_res.append( w_reserva )

plt.plot(pi_grid, w_res, 'r-s', label='$\\bar w$: salário reserva')
plt.gca().set_xlabel('$\\pi$')
plt.gca().set_ylim(0,)
plt.legend(loc='lower center', fontsize=15)










