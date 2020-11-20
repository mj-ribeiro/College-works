
setwd("D:/Git projects/college_works/monitoring_macro")



library(sf)
library(geobr)
library(ggplot2)
library(readxl)
library(ggspatial)
library(magrittr)
library(raster)
library(tmap)




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




ggplot(data= d_00, aes(geometry=geom)) +
  geom_sf(aes(fill=ite) ) +
  scale_fill_viridis_c(direction = -1, limits = c(0, 150), na.value = "white") + # Escala de cores
  labs(fill = "ITE",
       title = "?ndice de tratamento de esgoto, por munic?pio",
       subtitle = "Dados da SNIS, para o ano de 2000.") +
  annotation_north_arrow(
    style = north_arrow_nautical()
  ) +
  ggspatial::annotation_scale(plot_unit = 'km', location='br') +
  theme_void()
  






sp$ite = d_00$ite


library(magrittr)

box = st_bbox(sp$geom)

xrange <- box$xmax - box$xmin # range of x values
yrange <- box$ymax - box$ymin # range of y value

box[1] <- box[1] - (0.1 * xrange) # xmin - left
box[3] <- box[3] + (0.1 * xrange) # xmax - right
box[2] <- box[2] - (0.1 * yrange) # ymin - bottom
box[4] <- box[4] + (0.1 * yrange) # ymax - top

box =  box  %>% st_as_sfc()


tm_shape(sp, bbox = box) +
  tm_polygons('ite', title='ITE',  textNA = 'Sem dados') +
  tm_compass(type = "8star", position = c("right", "top")) +
  tm_scale_bar(breaks = c(0, 100, 200), text.size = 0.6) +
  tm_layout(title = "?ndice de tratamento de esgoto, por munic?pio, em 2000",
            title.position = c(0,0.95),
            legend.text.size = 0.8,
            frame = F,
            legend.format = list(text.separator = "-"))





## 2007


f_07 = df$ano == 2007

df_07 = df[f_07,]


df_07$idn = id_n


sp$ite07 = df_07$ite


tm_shape(sp, bbox = box) + 
  tm_polygons('ite07', title='ITE',  textNA = 'Sem dados') +
  tm_compass(type = "8star", position = c("right", "top")) +
  tm_scale_bar(breaks = c(0, 100, 200), text.size = 0.6) +
  tm_layout(title = "?ndice de tratamento de esgoto, por munic?pio, em 2007",
            title.position = c(0,0.95),
            legend.text.size = 0.8,
            frame = F,
            legend.format = list(text.separator = "-"))









## 2018


f_18 = df$ano == 2018

df_18 = df[f_18,]


df_18$idn = id_n




sp$ite18 = df_18$ite

summary(sp$ite)

summary(sp$ite07)

summary(sp$ite18)



tm_shape(sp, bbox = box) + 
  tm_polygons('ite18', title='ITE', textNA = 'Sem dados') +
  tm_compass(type = "8star", position = c("right", "top")) +
  tm_scale_bar(breaks = c(0, 100, 200), text.size = 0.6) +
  tm_layout(title = "?ndice de tratamento de esgoto, por munic?pio, em 2018",
            title.position = c(0,0.95),
            legend.text.size = 0.8,
            frame = F, 
            legend.format = list(text.separator = "-"))





### hist

df2 = df[is.na(df$ite)==F, ]
df2$ano = as.factor(df2$ano)


t = ggplot(data = df2, aes(x=`ite`)) 

t +  geom_histogram(binwidth = 10,  aes(fill=ano),  
                    colour='black', position = 'stack') +
  ylab('Quantidade de municípios') +
  xlab('Índice de Tratamento de Esgoto')










