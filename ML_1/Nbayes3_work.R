#------------------------------------------------------------------------------------------------
#                                    Naive Bayes
#------------------------------------------------------------------------------------------------

# Defining my work diretory

setwd("D:/Git projects/college_works/ML_1")



library(readxl)
teste <- read_excel("teste.xlsx")

teste$foot = NULL
df2 = teste[,'sex'] 
teste[,'sex']=NULL
teste$sex = df2


teste = data.frame(teste)


#--- function


naive_marcos2 = function(k, df){
  df = as.data.frame(df)
  #fator =  factor(df[,k])
  
  a = prop.table(table(df[ ,k]))
  ta = length(a)
  nm = rownames(a)
  print(strrep('=-', 30))
  
  print('Marcos Naive Bayes Classifier for Discrete Predictors')
  
  print(strrep('=-', 30))
  
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
     #cat(nm[g], '\n')
    
  }
   dimnames(M) = list(c(), c('mean', 'variance'), nm)
   return(M)
}


cc = naive_marcos2('sex', teste)


cc



#--------  predict



p = function(k, df, cl, b, c, cclas=0){
    t = prop.table(table(df[,k]))
    ta = length(t)
    nm = rownames(t)
    
    P = array(0, dim = c(2, 1, ta))
    #print('Conditional Probabilities')
    
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


o = p('sex', teste, cc, 5, 188, cclas = 1)
o



# --- prev

pred_marcos2 = function(k, df, df_n, cl, cclas=1){   

  
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
    
  }

  return(p_new)
}






height = c(5.4, 5.8, 6, 5)
weight = c(170, 183, 188, 188)

dfn = data.frame(height, weight)

o = p('sex', teste, cc, 5, 188, cclas = 1)
o

oo = pred_marcos2('sex', teste, dfn, cc, cclas = 0)
oo




