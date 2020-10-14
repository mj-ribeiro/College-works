
setwd("D:/Git projects/ceper_san")



library(sf)
library(geobr)
library(ggplot2)
library(readxl)



## dados

df = read_excel('esg.xlsx')


## renomear as colunas

or_names = colnames(df)

n_names = c('cod', 'mun', 'est', 'ano', 'prest', 'serv', 'ice', 'ite', 'iaue', 'iate', 'pop')



## print os velhos e novos nomes das colunas

pnames = function(){
  for (i in 1:length(or_names)) {
    cat('Nome na base:', or_names[i], '----- Novo nome:', n_names[i], '\n')
  }
}


# renomeando

for (i in 1:length(n_names)) {
  colnames(df)[i] = n_names[i]
}


head(df)



df = df[order(df$mun), ]




# geocode

sp = read_municipality(code_muni = 'SP')

sp = sp[order(sp$name_muni), ]




### filtrar por ano


table(df$ano)[1]

f_00 = df$ano == 2000

df_00 = df[f_00,]



summary(df[df$ano==2007, ]$ite )

summary(df[df$ano==2018, ]$ite )



# criando um  id number 


n = nrow(df_00)

id_n = seq(1, n, 1)


df_00$idn = id_n

sp$idn = id_n




## merge datasets



data = merge(df_00, sp, by.x="idn", by.y="idn")





## mapas



pnames()


ggplot(data= data, aes(geometry=geom)) +
  geom_sf(aes( fill=ite) ) +
  scale_fill_gradient(low="white", high="green",
                      na.value = "red", 
                      ) +
  scale_colour_manual(values=NA)




summary(data$ite)




