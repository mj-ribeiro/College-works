# -*- coding: utf-8 -*-
"""
Created on Wed Jun 24 16:15:29 2020

@author: Marcos J Ribeiro
"""

# Libraries

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sn
import statsmodels.formula.api as sm


# function to get data 

def get_bcb(cod_bcb):
    url = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.{}/dados?formato=json'.format(cod_bcb)
    df = pd.read_json(url)
    df['data'] = pd.to_datetime(df['data'], dayfirst=True)
    df.set_index('data', inplace=True)
    return df 


# get unenployment

des = get_bcb(24369)/100  # 24369 is the code of PNADC

pd.DataFrame.head(des)  # head of data


# plot PNADC
 
fig, ax = plt.subplots(figsize=(8,6))
ax.plot(des)
plt.title('Evolution of Unenployment in Brazil')
plt.xlabel('Year')
plt.ylabel('Unenployment')


# variation in Unenployment

ddes = des.diff()



# get GDP

GDP = get_bcb(4385)

pd.DataFrame.head(GDP)

pd.DataFrame.describe(GDP)


GDP = GDP['20120301':'20200401']



# plot GDP


fig, ax = plt.subplots(figsize=(8,6))
ax.plot(GDP)
plt.title('Evolution of GDP')
plt.xlabel('Year')
plt.ylabel('GDP')


# GPD Growth

gy = GDP.pct_change() 


fig, ax = plt.subplots(figsize=(8,6))
ax.plot(gy)
plt.title('Evolution of GDP Growth rate')
plt.xlabel('Year')
plt.ylabel('GDP Growth rate')


gy.describe()

# Scatter


plt.scatter(ddes, -gy)


# OLS

ddes.columns = ['ddes']   # change colnames
gy.columns = ['gy']

dt = pd.concat([ddes, -gy], axis=1)  # concatenate two dfs


reg = sm.ols('ddes ~ gy', data=dt).fit()

print(f'\033[1;033m{reg.summary()}')













