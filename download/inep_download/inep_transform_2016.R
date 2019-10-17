
getwd()
setwd("./download/inep_download/2016")

#install.packages("ffbase", dependencies = TRUE) #Instala o pacote
require(ffbase) #Carrega o pacote
library(magrittr)
library(stringr)
library(tibble)
library(dplyr)
library(openxlsx)

df_IES <- read.csv2("DM_IES.csv", sep = "|")

# usado para carregar grandes bases de dados 
curso <- read.csv2.ffdf(file = "DM_CURSO.csv", sep = "|", first.rows = 1000000)
#curso[1:10, 1:4]

curso <- as.data.frame(curso)

#--selecionando as variaveis do df_IES
df_IES <- subset(df_IES, select = c("CO_IES", "SGL_IES"))
# criando a coluna q  esta faltando no ano de 2016
df_IES['NU_ANO_CENSO'] <- 2016
# ordenando a coluna
df_IES <- df_IES[, c('NU_ANO_CENSO', 'CO_IES', 'SGL_IES')]

# -- merge dos DFs curso x IES 
df_curso_select_2016 <- merge(curso, df_IES, by = "CO_IES", sort = TRUE, no.dups = TRUE)

#selecting the relevant columns
df_curso_select_2016 <- subset(df_curso_select_2016, select = c(NU_ANO_CENSO, CO_IES, NO_IES, SGL_IES, CO_CATEGORIA_ADMINISTRATIVA, 
                        DS_CATEGORIA_ADMINISTRATIVA, CO_ORGANIZACAO_ACADEMICA, DS_ORGANIZACAO_ACADEMICA, CO_LOCAL_OFERTA_CURSO, CO_MUNICIPIO_CURSO,  
                        NO_MUNICIPIO_CURSO, CO_UF_CURSO, SGL_UF_CURSO, IN_CAPITAL_CURSO, CO_CURSO, NO_CURSO, CO_SITUACAO_CURSO, DS_SITUACAO_CURSO,
                        CO_OCDE, NO_OCDE, CO_OCDE_AREA_GERAL, NO_OCDE_AREA_GERAL, CO_OCDE_AREA_ESPECIFICA, NO_OCDE_AREA_ESPECIFICA,
                        CO_OCDE_AREA_DETALHADA, NO_OCDE_AREA_DETALHADA, CO_GRAU_ACADEMICO, DS_GRAU_ACADEMICO, CO_MODALIDADE_ENSINO, DS_MODALIDADE_ENSINO, 
                        CO_NIVEL_ACADEMICO, DS_NIVEL_ACADEMICO, IN_GRATUITO, TP_ATRIBUTO_INGRESSO, NU_CARGA_HORARIA, DT_INICIO_FUNCIONAMENTO,
                        DT_AUTORIZACAO_CURSO, IN_INTEGRAL_CURSO, IN_MATUTINO_CURSO, IN_VESPERTINO_CURSO, IN_NOTURNO_CURSO, IN_OFERECE_DISC_SEMI_PRES, 
                        NU_PERC_CAR_HOR_SEMI_PRES, IN_POSSUI_LABORATORIO, QT_MATRICULA_CURSO, QT_CONCLUINTE_CURSO, QT_INGRESSO_CURSO, QT_INGRESSO_VAGAS_NOVAS,
                        QT_VAGAS_TOTAIS))

                              
head(as_tibble(df_curso_select_2016))

# this changes the categorical column from integrer to factor
df_curso_select_2016$IN_CAPITAL_CURSO <- factor(df_curso_select_2016$IN_CAPITAL_CURSO)
df_curso_select_2016$IN_GRATUITO <- factor(df_curso_select_2016$IN_GRATUITO)
df_curso_select_2016$TP_ATRIBUTO_INGRESSO <- factor(df_curso_select_2016$TP_ATRIBUTO_INGRESSO)
df_curso_select_2016$IN_OFERECE_DISC_SEMI_PRES <- factor(df_curso_select_2016$IN_OFERECE_DISC_SEMI_PRES)
df_curso_select_2016$IN_POSSUI_LABORATORIO <- factor(df_curso_select_2016$IN_POSSUI_LABORATORIO)

# substituindo o codigo por sua descrição
levels_in_capital <- c("Nao", "Sim")
levels(df_curso_select_2016$IN_CAPITAL_CURSO) <- levels_in_capital

levels_in_gratuito <- c("Nao","Sim")
levels(df_curso_select_2016$IN_GRATUITO) <- levels_in_gratuito

levels_atrib_ing <- c("Normal","ABI", "BLInterd")
levels(df_curso_select_2016$TP_ATRIBUTO_INGRESSO) <- levels_atrib_ing

levels_in_of_disc_semi <- c("Nao","Sim")
levels(df_curso_select_2016$IN_OFERECE_DISC_SEMI_PRES) <- levels_in_of_disc_semi

levels_in_gratuito <- c("Nao","Sim")
levels(df_curso_select_2016$IN_POSSUI_LABORATORIO) <- levels_in_gratuito

# - gravando um arquivo xlsx parcial com as mudanças acima
write.xlsx(df_curso_select_2016, "df_curso_2016_parcial.xlsx")
rm(list = ls())
df_curso_select_2016 <- read.xlsx("df_curso_2016_parcial.xlsx")

# contar o s NAs de uma coluna
sum(is.na(df_curso_select_2016$IN_CAPITAL_CURSO))
sum(is.na(df_curso_select_2016$IN_GRATUITO))
sum(is.na(df_curso_select_2016$TP_ATRIBUTO_INGRESSO))
sum(is.na(df_curso_select_2016$IN_OFERECE_DISC_SEMI_PRES))
sum(is.na(df_curso_select_2016$IN_POSSUI_LABORATORIO))

# substituindo os NAs de IN_CAPITAL_CURSO por EAD
df_curso_select_2016[is.na(df_curso_select_2016$IN_CAPITAL_CURSO), "IN_CAPITAL_CURSO"] <- "EAD"
df_curso_select_2016[is.na(df_curso_select_2016$IN_OFERECE_DISC_SEMI_PRES), "IN_OFERECE_DISC_SEMI_PRES"] <- "EAD"


sum(is.na(df_curso_select_2016))
sum(is.null(df_curso_select_2016))


