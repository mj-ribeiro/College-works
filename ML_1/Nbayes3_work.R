#------------------------------------------------------------------------------------------------
#                                    Naive Bayes
#------------------------------------------------------------------------------------------------

# Defining my work diretory

setwd("C:/Users/user/Downloads/ML_work/Algorithm")



library(readxl)
teste <- read_excel("teste.xlsx")

teste$foot = NULL
df2 = teste[,'sex'] 
teste[,'sex']=NULL
teste$sex = df2


teste = data.frame(teste)


#--- function


naive_marcos = function(k, df){
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


cc = naive_marcos('sex', teste)


cc



#--------  predict



p = function(k, df, cl, b, c, cclas=0){
    t = prop.table(table(df[,k]))
    ta = length(t)
    nm = rownames(t)
    
    P = array(0, dim = c(2, 1, ta))
    #print('Conditional Probabilities')
    
    pm = matrix(0, nrow = ta, ncol = 1)
    rownames(pm) = nm
    
        
    for(i in 1:ta){
      a =dnorm(b, mean=cl[1, 1 ,i] , sd=cl[1, 2 ,i]) 
      d = dnorm(c, mean=cl[2, 1 ,i] , sd=cl[2, 2 ,i])
      m = matrix(c(a,d))
      P[, ,i] = m
      
      #cat(nm[i], '\n')
      #print(P[, ,i])
      
      pm[i] = t[i]*P[1,1,i]*P[2,1,i]
      
}
  pm = pm/sum(pm)  
  paa = which.max(pm)
  cnewd = rownames(pm)[paa]
  
  if(cclas==0){
    return(pm)
  }else{
    return(cnewd)
  }

}



# --- prev

prev = function(k, df, df_n, cl, b, c, cclas=1){   
  
  p_new = matrix(0, nrow = length(df_n))
  
  for(i in 1:length(df_n[,1])){
    
    p_new[i] = p(k, df, cl, df_n[i, 1], df_n[i, 2], cclas=1) 

  }
  
  return(p_new)
}



height = c(5.4, 5.8, 6, 5)
weight = c(170, 183, 188, 188)

dfn = data.frame(height, weight)

o = p('sex', teste, cc, 5, 188, cclas = 1)
o

oo = prev('sex', teste, dfn, cc, cclas = 1)
oo




