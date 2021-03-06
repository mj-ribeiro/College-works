#------------------------------------------------------------------------------------------------
#                                    Naive Bayes
#------------------------------------------------------------------------------------------------
##############################################################################################
#                                     Boundaries
##############################################################################################

library(ggplot2)
library(plyr)
library(e1071)
library('AppliedPredictiveModeling')
library('RColorBrewer')
library(quantmod)



# Defining my work diretory

setwd("D:/Git projects/college_works/ML_1")


# import data

df = read.csv('naive_base.csv')

df$garantias =NULL
df$renda =NULL



## import data to non-categorical independent variable


teste <- read.csv("teste.csv")


teste$foot = NULL
df2 = teste[,'sex'] 
teste[,'sex']=NULL
teste$sex = df2


teste = data.frame(teste)



## Import financial data


find = readRDS('findata.rds')

keep = c('x', 'oil', 'pca')
find2 = find[,keep]


library(ROSE)

tst = find2[232:241, ]


find2 = find2[1:231, ]

find2 = ovun.sample(as.factor(x)~., data=find2, method="both", p=0.5,
                    subset=options("subset")$subset,
                    na.action=options("na.action")$na.action, seed=1)

find2 = find2$data

tr = find2

tr = as.data.frame(tr)


##

keep2 = c('x', 'cb', 'vix')
find3 = find[,keep2]


tst2 = find3[232:241, ]


find3 = find3[1:231, ]

find3 = ovun.sample(as.factor(x)~., data=find3, method="both", p=0.5,
                    subset=options("subset")$subset,
                    na.action=options("na.action")$na.action, seed=1)

find3 = find3$data

tr2 = find3

tr2 = as.data.frame(tr2)






## census data

census = readRDS('census.rds')

keep2 = c('education', 'occupation', 'income')
census = census[ ,keep2]

addToDF <- function(df, v){
  nRow <- nrow(df)
  lngth <- length(v)
  if(nRow > lngth){
    length(v) <- nRow
  }else if(nRow < lngth){
    df[(nRow+1):lngth, ] <- NA
  }
  cbind(df,v)
}


a = levels(as.factor(census$education))
a = data.frame(a)


b = levels(as.factor(census$occupation))
a = addToDF(a, b)


c = levels(as.factor(census$income))
a = addToDF(a, c)

a[is.na(a)] = ' '
names = c('education', 'occupation', 'income')
colnames(a) = names



tst1 = census[28001:30162, ]
census = census[1:28000, ]




census = ovun.sample(as.factor(income)~., data=census, method="both", p=0.5,
            subset=options("subset")$subset,
            na.action=options("na.action")$na.action, seed=1)

#census = data.frame(census$data)

tr1 = data.frame(census$data)

census = data.frame(census$data)



#------------------------------------------------------------------------------------------
#                            categorical independent variable
#------------------------------------------------------------------------------------------


naive_marcos = function(k, df){
  
  a = prop.table(table(df[ ,k]))
  ta = length(a)
  nm = rownames(a)
  print(strrep('=-', 27))
  
  print('Marcos Naive Bayes Classifier for Discrete Predictors')
  
  print(strrep('=-', 27))
  
  cat('A-priori probabilities:\n')
  print(a)
  # simple trick to get names of variables without class variable
  
  df2 = df[ , k]
  df[ , k] = NULL 
  
  col_n = colnames(df)
  df$k = df2
  
  # defining lengths
  
  t_b1 =length( prop.table(table(df[ ,col_n[1]])))
  t_c1 =length( prop.table(table(df[ ,col_n[2]])))
  
  # probabilities array
  
  M1 = array(0, dim=c(t_b1, t_c1, ta) )
  
  for (k in 1:ta) {
    f1 = df['k'] == nm[k]

    b1 = prop.table(table(df[f1,col_n[1]]))
    c1 = prop.table(table(df[f1,col_n[2]]))
    
    
    for(j in 1:length(c1)){
      for ( i in 1:length(b1) ) {
        
        M1[i, j, k] = a[k]*b1[i]*c1[j] 
        
      }
    }
    
  }
  dimnames(M1) = list(rownames(prop.table(table(df[ ,col_n[1]]))),rownames( prop.table(table(df[ ,col_n[2]]))), nm )
  cat('Conditional Probabilities: \n')
  
  return(M1) 
}




cl = naive_marcos('risco', df)
cl


#-------- Classifying new data



pred_marcos = function(k, df, df_n, cl, cclas=0){
  # k -> class
  # df -> data to training algorithm
  # df_n -> new data vectors
  # cclas -> to get classification (1) or probabilities (0)
  # cl -> classifier
  
  a = prop.table(table(df[,k]))
  ta = length(a)
  nm = rownames(a)
  
  tvv = length(df_n[,1])
  cnewd = c()
  pmax = c()
  
  v = matrix(0, tvv, ta)
  for(i in 1:tvv){
  
    v[i, ] =  cl[df_n[i, 1], df_n[i, 2],  ]
    
    v[i, ] = v[i, ]/sum(v[i, ])
    
    pmax[i] = which.max(v[i, ])
    cnewd[i] = nm[pmax[i]]
  }
  colnames(v) = nm
  if(cclas==0){
    return(v)
  }else{
    return(cnewd)
}
}


# new data

historia = c('boa',    'boa',  'ruim', 'ruim', 'desconhecida', 'desconhecida')
divida = c('baixa', 'alta', 'baixa', 'alta',    'baixa', 'alta')

df_teste = data.frame(historia, divida)


d = pred_marcos('risco',  df, df_teste, cl, cclas = 1)








###########################################################################################
#                     Non Categorical independent variables
###########################################################################################


namedf = colnames(find)


naive_marcos2 = function(k, df){
  df = as.data.frame(df)
  
  namedf = colnames(df)        #reorder columns
  n1= which(namedf!= k)[1]
  n2 = which(namedf!= k)[2]
  n3 = which(namedf== k)
  df = df[ ,c(n1, n2, n3)]  
  
  a = prop.table(table(df[ ,k]))
  ta = length(a)
  nm = rownames(a)
  print(strrep('=-', 27))
  
  print('Marcos Naive Bayes Classifier for Discrete Predictors')
  
  print(strrep('=-', 27))
  
  cat('A-priori probabilities:\n')
  
  print(a)
  
  M = array(0, dim = c(2,2, ta))
  m = matrix(0, 2, 2)
  
  for(g in 1:ta){
    m1 = as.matrix(tapply(df[,1], df[,k], mean)[g])
    v1 = as.matrix(tapply(df[,1], df[,k], sd)[g])
    
    m2 = tapply(df[,2], df[,k], mean)[g]
    v2 = tapply(df[,2], df[,k], sd)[g]
    
    m = matrix(c(m1, m2, v1, v2)  )
    M[, ,g] = m
    #cat(nm[g], '\n')
    
  }
  dimnames(M) = list(c(), c('mean', 'variance'), nm)
  return(M)
}

cc = naive_marcos2('sex', teste)


################  predict function


# essa fun��o serve apenas para uma linha. Ent�o tenho que expandir para um dataframe (prev)

p = function(k, df, cl, b, c, cclas=0){
  t = prop.table(table(df[,k]))
  ta = length(t)
  nm = rownames(t)
  
  P = array(0, dim = c(2, 1, ta))
  
  pm = matrix(0, nrow = ta, ncol = 1)
  
  for(i in 1:ta){
    a =dnorm(b, mean=cl[1, 1 ,i] , sd=cl[1, 2 ,i]) 
    d = dnorm(c, mean=cl[2, 1 ,i] , sd=cl[2, 2 ,i])
    m = matrix(c(a,d))
    P[, ,i] = m
    
    pm[i] = t[i]*P[1,1,i]*P[2,1,i]
    
  }
  pm = pm/sum(pm) 
  pm = t(pm)
  colnames(pm) = nm
  
  paa = which.max(pm)
  cnewd = colnames(pm)[paa]
  
  if(cclas==0){
    return(pm)
  }else{
    return(cnewd)
  }
  
}


o = p('sex', teste, cc, 5, 188, cclas = 0)
o



# --- prev

pred_marcos2 = function(k, df, df_n, cl, cclas=1){  
  t = prop.table(table(df[,k]))
  ta = length(t)
  nm = rownames(t)
  
  if(cclas==1){
    p_new = matrix(0, nrow = length(df_n[,1]))
    
    for(i in 1:length(df_n[,1])){
      p_new[i] = p(k, df, cl, df_n[i, 1], df_n[i, 2], cclas=1) 
      
    }
    
  }else if(cclas==0){
    p_new = matrix(0, nrow = length(df_n[ , 1]), ncol=2)
    
    for(i in 1:length(df_n[,1])){
      
      p_new[i, ] = p(k, df, cl, df_n[i, 1], df_n[i, 2], cclas=0) 
      
    }
    colnames(p_new) = nm
  }
  
  return(p_new)
}





height = c(5.4, 5.8, 6, 5)
weight = c(170, 183, 188, 188)

dfn = data.frame(height, weight)


oo = pred_marcos2('sex', teste, dfn, cc, cclas = 1)
oo


#############################################################################################
#                                        Single function
#############################################################################################


#----- single inductor

naivef = function(k, df, cd=1){
    if(cd == 1){
      naive_marcos(k, df)
    }else if (cd == 0){
      naive_marcos2(k, df)
    }else{
      cat('Type cd = 1 for categorical dependent variables, \n and cd = 0 for non-categorical dependent variables.')
      
    }
    
  } 






#----- single predict


predf = function(k, df, df_n, cl, cclas=0, cd=1){
  if(cd == 1){
    pred_marcos(k, df, df_n, cl, cclas)
  }else if (cd == 0){
    pred_marcos2(k, df, df_n, cl, cclas)
  }else{
    cat('Type cd = 1 for categorical dependent variables, \n and cd = 0 for non-categorical dependent variables.')
  }
} 

































