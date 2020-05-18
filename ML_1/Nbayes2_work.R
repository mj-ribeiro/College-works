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



#--- correct function

naive_marcos = function(k, df){
  
  a = prop.table(table(df[ ,k]))
  ta = length(a)
  nm = rownames(a)
  print('Marcos Naive Bayes Classifier for Discrete Predictors')
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



#------------- remake


# Aplying in other data set

# I will try predict financial crisis



dfc = readRDS('df.rds')

dfc$x = ifelse(dfc$x==2, 0, dfc$x)


dfc$ret = NULL
dfc$cb = NULL 
dfc$cdi = NULL
dfc$gold = NULL





g1 = ggplot(data = dfc, aes(x =`vix`, y = `oil`, colour=x)) 
g1 +  geom_point(size=5) + geom_vline(xintercept = c(25, 65)) +
  geom_hline(yintercept = c(110, 10))



vix = c(100, 130, 133)
oil = c(20, 50, 18)

df_c2 = data.frame(vix, oil)


naive_marcos('x', dfc)








library(e1071) # library to work with naive bayes

clas3 = naiveBayes(x=dfc[-2], y = dfc$x)

print(clas3)



prev2 = predict(clas2, newdata = df_c, 'raw') 
print(prev2) 




#####################

