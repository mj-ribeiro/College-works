
setwd("D:/Git projects/college_works/monitoring_macro")



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



d_00 = merge(df_00, sp, by.x="idn", by.y="idn")



## mapas



pnames()


install.packages('ggspatial')
library(ggspatial)

d_00$na = is.na(d_00$ite)


ggplot(data= d_00, aes(geometry=geom)) +
  geom_sf(aes(fill=ite) ) +
  scale_fill_viridis_c(direction = -1, limits = c(0, 150), na.value = "red") + # Escala de cores
  labs(fill = "ITE",
       title = "Índice de tratamento de esgoto, por município",
       subtitle = "Dados da SNIS, para o ano de 2000.") +
  annotation_north_arrow(
    style = north_arrow_nautical()
  ) +
  ggspatial::annotation_scale(plot_unit = 'km', location='br') +
  theme_void()
  


  
  

ggplot(data= d_00, aes(geometry=geom)) +
  geom_sf(aes(fill=ite) ) +
  scale_fill_viridis_c(direction = -1, limits = c(0, 100)) 
  
  

  

d_00$bug = ifelse(d_00$na==T, 1, 0)

d_00$bug = as.factor(d_00$bug)


d_00$test = ifelse(is.na(d_00$ite)==T,100, d_00$ite)


ggplot(data=d_00, aes(geometry=geom)) + 
  geom_sf(aes(fill=ite)) 




## 2007


f_07 = df$ano == 2007

df_07 = df[f_07,]


df_07$idn = id_n



d_07 = merge(df_07, sp, by.x="idn", by.y="idn")



ggplot(data= d_07, aes(geometry=geom)) +
  geom_sf(aes(fill=ite) ) +
  scale_fill_viridis_c(direction = -1, limits = c(0, 150), na.value = "red") + # Escala de cores
  labs(fill = "ITE",
       title = "Índice de tratamento de esgoto, por município",
       subtitle = "Dados da SNIS, para o ano de 2007.") +
  annotation_north_arrow(
    style = north_arrow_nautical()
  ) +
  ggspatial::annotation_scale(plot_unit = 'km', location='br') +
  theme_void()


## 2018


f_18 = df$ano == 2018

df_18 = df[f_18,]


df_18$idn = id_n



d_18 = merge(df_18, sp, by.x="idn", by.y="idn")




ggplot(data= d_18, aes(geometry=geom)) +
  geom_sf(aes(fill=ite) ) +
  scale_fill_viridis_c(direction = 1, limits = c(0, 150), na.value = "red") + # Escala de cores
  labs(fill = "ITE",
       title = "Índice de tratamento de esgoto, por município",
       subtitle = "Dados da SNIS, para o ano de 2018.") +
  annotation_north_arrow(
    style = north_arrow_nautical()
  ) +
  ggspatial::annotation_scale(plot_unit = 'km', location='br') +
  theme_void()





