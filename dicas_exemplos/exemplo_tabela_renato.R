#?xtabs

#?daply
#?plyr



#eng_pres <- droplevels(subset(eng, eng$mod_ens == "1"))
#str(eng_pres)


# subsetting para SP: WARNING: remove NAs, nesse caso os cursos ? dist?ncia que n?o t?m UF atribu?da
#eng_sp <- droplevels(subset(eng, eng$uf=="35"))

#str(eng_sp)

#View(eng_sp)

# Criando tabelas (matrizes) 

# carregando PLYR

# library(plyr)

# Formato básico de tabelas
# WARNING: cálulas vazias (NA) criam problemas sários - ver abaixo exemplo UFs

#daply(eng_sp,.(cat_adm,org_acad), summarize,sum(matr_total))
# daply(eng,.(cat_adm,org_acad), summarize,sum(matr_total))

# daply(eng_1,.(cat_adm,org_acad), summarize,sum(matr_total))
# daply(eng_2,.(cat_adm,org_acad), summarize,sum(matr_total))

#sum(eng$matr_total)
#sum(eng$matr_total,na.rm = T)

#sum(eng_sp$matr_total)

#sum(eng[(eng$uf == "35"),]$matr_total,na.rm = T)

#sum(eng_sp[(eng_sp$situacao == "1"),]$matr_total)

# Warning: a primeira produz dados errados pois h? os cursos EAD sem atribui??o de UF
#table_1 <- daply(eng,.(uf,cat_adm), summarize,sum(matr_total))
#table_2 <- daply(eng_pres,.(uf,cat_adm), summarize,sum(matr_total))

#table_1
#table_2

# tabula matr?culas por cat_adm e por situ??o (ativo = 1, em extin??o = 3)
# daply(eng_sp,.(cat_adm,eng_sp$situacao), summarize,sum(matr_total))

#sum(eng_sp$matr_total)
#sum(eng_sp$matr_total,na.rm = T)

# Corrigindo data misses



#table1 <- daply(eng,.(uf,cat_adm), summarize,sum(matr_total))
#table2 <- daply(eng,.(cat_adm, org_acad), summarize,sum(matr_total))

#table1
#table2
# Troca NULL por zero

# table1[table1 == "NULL"] = 0
# table2[table2 == "NULL"] = 0

#table1
#table2

# escrevendo tabela em csv para importar com excel WARNING: se houver acentos precisa especifical o encoding = "latin1"
# Default: row.names = T, o que produz a primeira coluna corretamente

# write.table(table1, file="tabela.csv", sep=";", dec=".", fileEncoding = "latin1")

#esse m?todo ? melhor, n?o cria problema com a primeira coluna
#write.csv(table1, file="tabela.csv", fileEncoding = "latin1")

#labels(eng$curso)

#levels(eng$curso)

# list.files()

# WARNING: para recuperar a tabela no R, n?o esquecer o encoding!

# tabela <- read.csv("tabela.csv", sep=";", encoding = "latin1")
# str(tabela)


# --------------- Filtering

# seleciona cursos com mais de 2.000 matriculados

#filter <- eng$matr_total > 2000

#exibe na tela

#eng[filter,] 

# eng[eng$cat_adm == "P?bl Est" & eng$curso == "ENGENHARIA MEC?NICA",]

#str(table1)

# table1[10,1]
# table1["SP","P?blEst"]

#table1

#rownames(table1)
#colnames(table1)

# rownames(table2)
#colnames(table2)
#table2

#------ MATPLOT()

#table1
#View(table1)

#matplot(table1[,"P?blFed"],type="s")

#?matplot
#?plot

# ---- criando um DF de uma matrix VERY WEIRD!!!!

#table1.df <- as.data.frame(table1)
# class(table1.df)
#df<-lapply(table1.df, unlist)

#aplicar novamente as.data.frame
#df.df<- as.data.frame(df)

#df.df
#table1.df
#df
#str(table1.df)

#OK:
#str(df.df)

#class(table1.df)
#class(df)
# table1.df[2,]
#table1.df["SP",]
#colnames(table1.df)

# using rownames to create a new column for the UFs

#newcolumn <- rownames(table1.df)
#table1.df$uf <- newcolumn
#table1.df
#str(table1.df)

