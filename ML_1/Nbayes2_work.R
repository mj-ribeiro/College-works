#------------------------------------------------------------------------------------------------
#                                    Naive Bayes
#------------------------------------------------------------------------------------------------

# Defining my work diretory

setwd("D:/Git projects/college_works/ML_1")


# import data

df = read.csv('naive_base.csv')

df$garantias =NULL
df$renda =NULL


#------ create function



naive_marcos = function(k, df){
  
  a = prop.table(table(df[ ,k]))
  ta = length(a)
  nm = rownames(a)
  print(strrep('=-', 30))
  
  print('Marcos Naive Bayes Classifier for Discrete Predictors')
  
  print(strrep('=-', 30))
  
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
  print(M1)
  
  return(M1) 
}




cl = naive_marcos('risco', df)
cl


#-------- Classifier new data


# new data

historia = c('boa',    'boa',  'ruim', 'ruim', 'desconhecida', 'desconhecida')
divida = c('baixa', 'alta', 'baixa', 'alta',    'baixa', 'alta')

df_c = data.frame(historia, divida)




pred_marcos = function(k, df, df_c, cclas=0, cl){
  # k -> class
  # df -> data to training algorithm
  # df_c -> new data vectors
  # cclas -> to get classification (1) or probabilities (0)
  # cl -> classifier
  
  
  a = prop.table(table(df[,k]))
  ta = length(a)
  nm = rownames(a)
  
  tvv = length(df_c[,1])
  cnewd = c()
  pmax = c()

  
  v = matrix(0, tvv, ta)
  for(i in 1:tvv){
  
    v[i, ] =  cl[df_c[i, 1], df_c[i, 2],  ]
    
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



d = pred_marcos('risco',  df, df_c, cclas = 0, cl)
d



#---- Quality control



library(e1071) # library to work with naive bayes

clas2 = naiveBayes(x=df[-3], y = df$risco)

print(clas2)


prev2 = predict(clas2, newdata = df_c, 'raw') 
print(prev2) 



#the result obtained from my algorithm is identical to the result produced by the library




###########################################################################################
#                              Non Categorical dataset
###########################################################################################




naive_marcos2 = function(k, df){
  df = as.data.frame(df)
  #fator =  factor(df[,k])
  
  a = prop.table(table(df[ ,k]))
  ta = length(a)
  nm = rownames(a)
  print('Marcos Naive Bayes Classifier for Discrete Predictors')
  cat('A-priori probabilities:\n')
  
  #df2 = df[ , k]
  print(a)
  
  #df[ ,k] = NULL 
  #col_n = colnames(df)
  #df[,k] = df2
  
  M = array(0, dim = c(2,2, ta))
  m = matrix(0, 2, 2)
  
  
  for(g in 1:ta){
    m1 = as.matrix(tapply(df[,1], df[,k], mean)[g])
    v1 = as.matrix(tapply(df[,1], df[,k], sd)[g])
    
    m2 = tapply(df[,2], df[,k], mean)[g]
    v2 = tapply(df[,2], df[,k], sd)[g]
    
    m = matrix(c(m1, m2, v1, v2)  )
    M[, ,g] = m
    cat(nm[g], '\n')
    
    print(M[, ,g])
  }
  return(M)
}


cc = naive_marcos2('sex', teste)


cc
















