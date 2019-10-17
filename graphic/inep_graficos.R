
# ------------ GGPLOT2

library(ggplot2)
cursos <- df_curso_select
names(cursos)

str(cursos)
levels(cursos$cat_adm)
levels(cursos$cod_ocde)

# data and aesthetics
ggplot(data=cursos, aes(x=ingr_total , y=matr_total))

# add geometry: gráfico dispersão = geom_point
ggplot(data=cursos, aes(x=ingr_total , y=matr_total)) + 
  geom_point()

# add color by some factor to aesthetics

ggplot(data=cursos, aes(x=ingr_total , y=matr_total, 
                        colour = cod_ocde)) + 
  geom_point()

# add size of disk by org_acad

p <- ggplot(data=cursos, aes(x=ingr_total , y=matr_total, 
                             colour = cod_ocde,
                             size = concl_total)) + 
  geom_point()

# Using layers

# basic layer

p <- ggplot(data=cursos, aes(x=ingr_total , y=matr_total, 
                             colour = cod_ocde,
                             size = concl_total))

# Add geometry

p + geom_point()
p+ geom_line()

p+ geom_line() + geom_point()

#------Overriding Aesthetics

q <- ggplot(data=cursos, aes(x=ingr_total , y=matr_total, 
                             size = concl_total))
q + geom_point()

q + geom_point(aes(colour = cat_adm))

# Renaming axis
q + geom_point(aes(colour = cat_adm)) +
  xlab("Ingressos") + 
  ylab("Matrículas")
levels(cursos$cod_ocde)
cexnat <- cursos[cursos$cod_ocde == "CExNat",]
str(cexnat)
levels_org_acad
#View(cexnat)

r <- ggplot(data=cexnat, aes(x=cat_adm , y=concl_total)) +
  ggtitle("Concluintes por cat. adm. e org. acad. - Cursos de Saúde")

r + geom_point(aes(colour = org_acad, size = concl_total)) +
  xlab("Categoria Administrativa") + 
  ylab("Concluintes")

#--- Histogramas e densidades

s <- ggplot(data=cexnat, aes(x=matr_total, color = org_acad))
s + geom_histogram(binwidth=10)+
  xlim(0,200)

# add border

s + geom_histogram(binwidth=10, aes(fill = org_acad)) +
  xlim(0,200)

# addc colour

s + geom_histogram(binwidth=10, aes(fill = org_acad), colour = "Black") +
  xlim(0,200)

s + geom_density(aes(fill=org_acad)) + xlim(0,200)

s + geom_density(aes(fill=org_acad),position="stack")

#--- Stats transforms

class(cursos)
q <- ggplot(data=cursos,aes(x=ingr_total , y=matr_total, colour = cat_adm))

q + xlab("Ingressos") + 
  ylab("Matrículas") +
  geom_smooth()+
  xlim(10,7000) +
  ylim(10,8000)

q <- ggplot(data=cursos,aes(x=ingr_total , y=concl_total, colour = cat_adm))

q + xlab("Ingressos") + 
  ylab("Concluintes") +
  geom_smooth()+
  xlim(10,7000) +
  ylim(10,4000)

# basic barplot

p <- ggplot(data=cursos)
p +  geom_bar(aes(x=uf, y = ingr_total, color=uf, fill=uf),stat = "identity",width=0.7)

# eliminating EAD

p <- ggplot(data=subset(cursos,uf!="EAD"))
p + geom_bar(aes(x=uf, y = ingr_total, color=uf, fill=uf),stat = "identity",width=0.7)

# Choosing the x levels
p <- ggplot(data=cursos)
p +  geom_bar(aes(x=uf, y = ingr_total, color=uf, fill=uf),stat = "identity",width=0.7) +
  scale_x_discrete(limits=c("AC","MG","PR", "GO",  "SP"))

# Ordenando o eixo x - mais fácil criar uma tabela  para os dados agregados por UF usando "aggregate"

table_uf <- aggregate(
  cbind(Ingr=cursos$ingr_total, Matr=cursos$matr_total, Concl=cursos$concl_total), 
  by=list(UF = cursos$uf), 
  FUN=sum)
table_uf

#usar a biblioteca "forcats"
library(forcats)

# função "fct_reorder" - usar o sinal "-" para ordem decrescente (default é crescente)

table_uf$UF <- fct_reorder(table_uf$UF,-table_uf$Matr)
table_uf$UF

p <- ggplot(data=table_uf, aes(x=UF, y = Matr))
p +  geom_bar(stat = "identity",width=0.7)

