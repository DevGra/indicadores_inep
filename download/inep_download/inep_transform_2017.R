getwd()
# duas barras pq no windows a barra que separa os diretorios e ao contrario
#setwd('indicadores\\download\\inep_download')
setwd("~/carlos/projeto_R/indicadores/download/inep_download")
library(magrittr)
library(stringr)
library(tibble)
library(dplyr)

#rm(list=ls())
anos <- list.dirs(path = ".", full.names = TRUE, recursive = TRUE)
arquivo <- ''

for (ano in anos) {
  
  ano <- strsplit(ano, "/")[[1]]
  ano <- ano[2]
  
  if (!is.na(ano)) {
    
    dir_download <- sprintf("%s",paste(getwd(), ano, sep = '/'))
    cat(dir_download)
    
    #arquivos_por_ano <- list.files(path = dir_download, pattern = "\\.csv$")
    arquivos_por_ano <- list.files(path = dir_download, pattern = ".CSV$")
    
    if (length(arquivos_por_ano) > 0) {
      
      # pegando os arquivos de forma automatica e setando seus nomes
      for (file in arquivos_por_ano) {
        print(file)
        
        # if apenas para teste, apos, tira-lo para carregar todos os arquivos inep
        if (file == "DM_CURSO.CSV") {
          
          letra <- strsplit(file, "_")[[1]]
          letra <- letra[2]
          letra <- strsplit(letra, "\\.")[[1]]
          
          # cria de forma dinamica o nome do arquivo
          arquivo <- paste("df" , str_to_lower(letra[1]), sep = "_")
          nome_do_a_ser_salvo <- arquivo 
          
          dir_transf_inep <- paste("inep_transform", ano, sep = "/")
          out_dir <- file.path(DIR$TRANSFORM_DIR, dir_transf_inep)
          
          arquivo <- read.csv(sprintf("%s",paste(dir_download, file, sep = '/')) , sep = "|",encoding = "latin1")
          
        } #retirar
        if (file == "DM_IES.CSV") {
          df_IES <<- read.csv(sprintf("%s",paste(dir_download, file, sep = '/')) , sep = "|",encoding = "latin1")
        }
        
      } #retirar
    } #retirar
  } #retirar
} #retirar depois, só pra teste
str(arquivo)

#  ---------- CODIGO AQUI ----------

# aqui o arquivo ainda eh um csv
typeof(arquivo)
class(arquivo)
getwd()

# load cursos
#df_curso <- read.csv("C:/Users/cgt/Documents/carlos/projeto_R/indicadores/download/inep_download/2017/DM_CURSO.CSV", sep ="|",encoding = "latin1")
#class(df_curso) 
# df_curso<- read.csv("DM_CURSO.CSV",sep="|",encoding="latin1")
# 
# str(df_curso)
# View(df_curso)

# load docentes
#df_docente <- read.csv("DM_DOCENTE.CSV",sep="|",encoding="latin1")

# load IES
# df_IES <- read.csv("DM_IES.CSV", sep = "|", encoding = "latin1")

#load alunos
#df_ALUNO <- read.csv("DM_ALUNO.CSV",sep="|",encoding="latin1")

df_curso <- arquivo

#--selecionando as variaveis do df_IES
df_IES <- subset(df_IES, select = c("CO_IES", "NO_IES", "SG_IES"))

# -- merge sem nomear as colunas repetidas. ex: CO_UF.x e CO_UF.y
#df_curso_select <- merge(df_curso, df_IES[, c("CO_IES", setdiff(colnames(df_IES),colnames(df_curso)))], by = "CO_IES") 

# -- merge dos DFs curso x IES 
df_curso_select <- merge(df_curso, df_IES, by = "CO_IES", sort = TRUE, no.dups = TRUE)

# - para verificar a diferenca entre as variaveis 
# setdiff(df_curso$CO_UF,df_curso$CO_UF)
# setdiff(df_curso_select$NU_ANO_CENSO.x,df_curso_select$NU_ANO_CENSO.y)
# setdiff(df_curso_select$NIN_CAPITAL.x, df_curso_select$IN_CAPITAL.y)


#selecting the relevant columns
df_curso_select <- subset(df_curso_select, select = c(NU_ANO_CENSO,CO_IES,NO_IES, SG_IES, TP_CATEGORIA_ADMINISTRATIVA, 
                                                      TP_ORGANIZACAO_ACADEMICA,CO_LOCAL_OFERTA, CO_UF, CO_MUNICIPIO,
                                                      IN_CAPITAL, CO_CURSO, NO_CURSO,TP_SITUACAO,
                                                      CO_OCDE_AREA_GERAL, CO_OCDE_AREA_ESPECIFICA, CO_OCDE_AREA_DETALHADA, 
                                                      CO_OCDE, TP_GRAU_ACADEMICO,TP_MODALIDADE_ENSINO,TP_NIVEL_ACADEMICO, 
                                                      IN_GRATUITO, TP_ATRIBUTO_INGRESSO, NU_CARGA_HORARIA, DT_INICIO_FUNCIONAMENTO, 
                                                      DT_AUTORIZACAO_CURSO, IN_INTEGRAL, IN_MATUTINO, IN_VESPERTINO, IN_NOTURNO, IN_OFERECE_DISC_SEMI_PRES, 
                                                      NU_PERC_CARGA_SEMI_PRES, IN_POSSUI_LABORATORIO,QT_MATRICULA_TOTAL,QT_CONCLUINTE_TOTAL, 
                                                      QT_INGRESSO_TOTAL, QT_INGRESSO_VAGA_NOVA,QT_INGRESSO_PROCESSO_SELETIVO,QT_VAGA_TOTAL))

head(as_tibble(df_curso_select))

# str(df_curso)

# names(df_curso_select)

# this makes the set of new names (must be in order)
# newnames <- c("ies", "cat_adm","org_acad","uf","municipio","curso","situacao",
#               "cod_ocde","grau_acad","mod_ens",
#               "niv_acad",
#               "atrib_ingr",
#               "carg_hor",
#               "data_func",
#               "matr_total","concl_total","ingr_total",
#               "ingr_vn","vaga_total")

# exemplo de como renomear as colunas 
# nomes_coluna <- c("ies", "cat_adm","org_acad","uf","municipio","curso")
# colunas_renomeadas <- replace(nomes_coluna, c(1, 6),c("IES", "CURSO"))

# this attributes the new names to columns
#colnames(df_curso_select) <- newnames
names(df_curso_select)

#this is the cat_adm column of the data frame
# df_curso_select$cat_adm

str(df_curso_select)
summary(df_curso_select)


# this changes the categorical column from integrer to factor
df_curso_select$CO_IES <- factor(df_curso_select$CO_IES)
df_curso_select$TP_CATEGORIA_ADMINISTRATIVA <- factor(df_curso_select$TP_CATEGORIA_ADMINISTRATIVA)
df_curso_select$TP_ORGANIZACAO_ACADEMICA <- factor(df_curso_select$TP_ORGANIZACAO_ACADEMICA)
df_curso_select$CO_UF <- factor(df_curso_select$CO_UF)
df_curso_select$CO_MUNICIPIO <- factor(df_curso_select$CO_MUNICIPIO)
df_curso_select$IN_CAPITAL <- factor(df_curso_select$IN_CAPITAL)
df_curso_select$TP_SITUACAO <- factor(df_curso_select$TP_SITUACAO)
df_curso_select$TP_GRAU_ACADEMICO <- factor(df_curso_select$TP_GRAU_ACADEMICO)
df_curso_select$TP_MODALIDADE_ENSINO <- factor(df_curso_select$TP_MODALIDADE_ENSINO)
df_curso_select$TP_NIVEL_ACADEMICO <- factor(df_curso_select$TP_NIVEL_ACADEMICO)
df_curso_select$IN_GRATUITO <- factor(df_curso_select$IN_GRATUITO)
df_curso_select$TP_ATRIBUTO_INGRESSO <- factor(df_curso_select$TP_ATRIBUTO_INGRESSO)
df_curso_select$IN_INTEGRAL <- factor(df_curso_select$IN_INTEGRAL)
df_curso_select$IN_MATUTINO <- factor(df_curso_select$IN_MATUTINO)
df_curso_select$IN_VESPERTINO <- factor(df_curso_select$IN_VESPERTINO)
df_curso_select$IN_NOTURNO <- factor(df_curso_select$IN_NOTURNO)
df_curso_select$IN_OFERECE_DISC_SEMI_PRES <- factor(df_curso_select$IN_OFERECE_DISC_SEMI_PRES)
df_curso_select$NU_PERC_CARGA_SEMI_PRES <- factor(df_curso_select$NU_PERC_CARGA_SEMI_PRES)
df_curso_select$IN_POSSUI_LABORATORIO <- factor(df_curso_select$IN_POSSUI_LABORATORIO)

#View(df_curso_select)

# ---- Mudando nomes dos niveis --------
# Adicionando alguns a serem utilizados

levels_cat_adm <- c("PublFed","PublEst","PublMun", "PrivCFL", "PrivSFL", "Especial")
levels(df_curso_select$TP_CATEGORIA_ADMINISTRATIVA) <- levels_cat_adm

levels_org_acad <- c("Univ","CUniv", "Fac/Inst", "Ifet", "Cefet")
levels(df_curso_select$TP_ORGANIZACAO_ACADEMICA) <- levels_org_acad

# -- importando a funcao COD_UF do arquivo co_uf.R
source("C:\\Users\\cgt\\Documents\\carlos\\projeto_R\\indicadores\\files\\co_uf.R", local = TRUE, chdir = TRUE, encoding = getOption("encoding"))
# levels_uf <- c("RO","AC","AM","RR","PA","AP","TO","MA","PI","CE","RN","PB",
#                "PE","AL","SE","BA","MG","ES","RJ","SP","PR","SC","RS","MS","MT","GO","DF","EAD")
levels_uf <- sapply(levels(df_curso_select$CO_UF), COD_UF, simplify = T)
levels(df_curso_select$CO_UF) <- levels_uf

# -- importando a funcao find_municipio do arquivo municipios_df-map_values.R
source("C:\\Users\\cgt\\Documents\\carlos\\projeto_R\\indicadores\\files\\municipios_df-map_values.R", local = TRUE, chdir = TRUE)
levels_municipio <- sapply(levels(df_curso_select$CO_MUNICIPIO), find_municipio, simplify = T)
levels(df_curso_select$CO_MUNICIPIO) <- levels_municipio

levels_in_capital <- c("Nao", "Sim")
levels(df_curso_select$IN_CAPITAL) <- levels_in_capital

levels_situacao <- c("Ativo","Extinto", "EmExt")
levels(df_curso_select$TP_SITUACAO) <- levels_situacao

levels_grau_acad <- c("Bach", "Lic", "Tecn")
levels(df_curso_select$TP_GRAU_ACADEMICO) <- levels_grau_acad

levels_mod_ens <- c("Pres", "EAD")
levels(df_curso_select$TP_MODALIDADE_ENSINO) <- levels_mod_ens

levels_niv_acad <- c("Grad","SeqFE")
levels(df_curso_select$TP_NIVEL_ACADEMICO) <- levels_niv_acad 

levels_in_gratuito <- c("Nao","Sim")
levels(df_curso_select$IN_GRATUITO) <- levels_in_gratuito 

# -    verificar pq o 3 aparece
levels_atrib_ingr <- c("Reg", "ABI", "BLInterd","3")
levels(df_curso_select$TP_ATRIBUTO_INGRESSO) <- levels_atrib_ingr

levels_in_integral <- c("Nao","Sim")
levels(df_curso_select$IN_INTEGRAL) <- levels_in_integral 

levels_in_matutino <- c("Nao","Sim")
levels(df_curso_select$IN_MATUTINO) <- levels_in_matutino

levels_in_vesp <- c("Nao","Sim")
levels(df_curso_select$IN_VESPERTINO) <- levels_in_vesp

levels_in_noturno <- c("Nao","Sim")
levels(df_curso_select$IN_NOTURNO) <- levels_in_noturno

levels_in_of_disc_semi <- c("Nao","Sim")
levels(df_curso_select$IN_OFERECE_DISC_SEMI_PRES) <- levels_in_of_disc_semi

#levels(df_curso_select$NU_PERC_CARGA_SEMI_PRES ) 

levels_in_pos_lab <- c("Nao","Sim")
levels(df_curso_select$IN_POSSUI_LABORATORIO) <- levels_in_pos_lab

setwd("C:/Users/cgt/Documents/carlos/projeto_R/indicadores/download/inep_download")

# - gravando um arquivo xlsx parcial com as mudanças acima
write.xlsx(df_curso_select, "inep_agreg_parcial.xlsx")

# df_curso_select <- read.xlsx("inep_agreg_parcial.xlsx")

# contar o s NAs de uma coluna
sum(is.na(df_curso_select$TP_GRAU_ACADEMICO))
sum(is.na(df_curso_select$CO_MUNICIPIO))

# ---------------------------------- FAZENDO O MAPVALUES COMO O DF OCDE ---------------------------------------------------------------------- 
# -  carregando o arquivo da ocde
ocde_df <- read.xlsx("C:\\Users\\cgt\\Documents\\carlos\\projeto_R\\indicadores\\download\\inep_download\\2017\\ocde.xlsx")
ocde_df <- as_tibble(ocde_df)
str(ocde_df)

ocde_area_geral <- subset(ocde_df, select = c("CO_OCDE_AREA_GERAL", "NO_OCDE_AREA_GERAL"))
# -- agrupando para pegar os valores correspondentes ao codigo e nome
ocde_area_geral <- ocde_area_geral %>% 
  group_by(CO_OCDE_AREA_GERAL, NO_OCDE_AREA_GERAL) %>%
  distinct(NO_OCDE_AREA_GERAL, .keep_all = TRUE)

cod_area_geral <- ocde_area_geral$CO_OCDE_AREA_GERAL
nome_area_geral <- ocde_area_geral$NO_OCDE_AREA_GERAL

# - o [-1] em cod_area_geral se deve pelo fato de nao haver em df_curso_select o 0 - que corresponde a área basica em ocde_df
cod_area_geral <- as.character(cod_area_geral)[-1]
nome_area_geral <- nome_area_geral[-1]
# - fazendo a substituicao do codigo em df_curso_select pelo nome em nome_area_geral
df_curso_select$CO_OCDE_AREA_GERAL <- mapvalues(df_curso_select$CO_OCDE_AREA_GERAL, cod_area_geral, nome_area_geral)

#--------------------------AREA ESPECIFICA-----------------------------

ocde_area_espec <- subset(ocde_df, select = c("CO_OCDE_AREA_ESPECIFICA", "NO_OCDE_AREA_ESPECIFICA"))
# -- agrupando para pegar os valores correspondentes ao codigo e nome
ocde_area_espec <- ocde_area_espec %>% 
  group_by(CO_OCDE_AREA_ESPECIFICA, NO_OCDE_AREA_ESPECIFICA) %>%
  distinct(NO_OCDE_AREA_ESPECIFICA, .keep_all = TRUE)

cod_area_espec <- ocde_area_espec$CO_OCDE_AREA_ESPECIFICA
nome_area_espec <- ocde_area_espec$NO_OCDE_AREA_ESPECIFICA

# - o [-1] em cod_area_geral se deve pelo fato de nao haver em df_curso_select o 0 - que corresponde a área basica em ocde_df
cod_area_espec <- as.character(cod_area_espec)[-1]
nome_area_espec <- nome_area_espec[-1]
# - fazendo a substituicao do codigo em df_curso_select pelo nome em nome_area_geral
df_curso_select$CO_OCDE_AREA_ESPECIFICA <- mapvalues(df_curso_select$CO_OCDE_AREA_ESPECIFICA, cod_area_espec, nome_area_espec)

#----------------------AREA DETALHADA-----------------------------------

ocde_area_det <- subset(ocde_df, select = c("CO_OCDE_AREA_DETALHADA", "NO_OCDE_AREA_DETALHADA"))
# -- agrupando para pegar os valores correspondentes ao codigo e nome
ocde_area_det <- ocde_area_det %>% 
  group_by(CO_OCDE_AREA_DETALHADA, NO_OCDE_AREA_DETALHADA) %>%
  distinct(NO_OCDE_AREA_DETALHADA, .keep_all = TRUE)

cod_area <- ocde_area_det$CO_OCDE_AREA_DETALHADA
nome_area <- ocde_area_det$NO_OCDE_AREA_DETALHADA

# verificando as diferencas de codigo que tem em ocde e nao tem em df_curso_select
ocde <- levels(factor(cod_area))
curso <- levels(factor(df_curso_select$CO_OCDE_AREA_DETALHADA))
diferenca_ocde_curso <- setdiff(ocde, curso)

ocde_area_det$CO_OCDE_AREA_DETALHADA <- as.character(ocde_area_det$CO_OCDE_AREA_DETALHADA)

`%notin%` <- Negate(`%in%`)
df_result <- ocde_area_det[ocde_area_det$CO_OCDE_AREA_DETALHADA %notin% c(diferenca_ocde_curso),]

#- ordenando o codigo ocde
df_result <- df_result[order(df_result$CO_OCDE_AREA_DETALHADA),]

#ocde_result <- intersect(ocde, curso)

# - fazendo a substituicao do codigo em df_curso_select pelo nome em nome_area_geral
df_curso_select$CO_OCDE_AREA_DETALHADA <- mapvalues(df_curso_select$CO_OCDE_AREA_DETALHADA, df_result$CO_OCDE_AREA_DETALHADA, df_result$NO_OCDE_AREA_DETALHADA)
# --------------------------------------------------------------------


#-- nadia nao pediu na planilha, verficar se tem que colocar
levels_ocde <- c("Educacao", "HumArt", "CSocAplic", "CExNat", "EngConstProd", "CAgric", "Saue", "Servicos","ABI")
levels(df_curso_select$CO_OCDE) <- levels_ocde














#------------ NAs ------------------
#Importante verificar onde ocorrem NAs

nas <- df_curso_select[!complete.cases(df_curso_select),]
nas$ies <- droplevels(nas$ies)
nas$TP_CATEGORIA_ADMINISTRATIVA <- droplevels(nas$TP_CATEGORIA_ADMINISTRATIVA)
nas$TP_ORGANIZACAO_ACADEMICA <- droplevels(nas$TP_ORGANIZACAO_ACADEMICA)
nas$CO_UF <- droplevels(nas$CO_UF)
nas$CO_MUNICIPIO <- droplevels(nas$CO_MUNICIPIO)
nas$CO_CURSO <- droplevels(nas$CO_CURSO)
nas$TP_SITUACAO <- droplevels(nas$TP_SITUACAO)
nas$CO_OCDE <- droplevels(nas$CO_OCDE)
nas$TP_GRAU_ACADEMICO <- droplevels(nas$TP_GRAU_ACADEMICO)
nas$TP_MODALIDADE_ENSINO <- droplevels(nas$TP_MODALIDADE_ENSINO)
nas$TP_NIVEL_ACADEMICO <- droplevels(nas$TP_NIVEL_ACADEMICO)
nas$TP_ATRIBUTO_INGRESSO <- droplevels(nas$TP_ATRIBUTO_INGRESSO)
nas$DT_INICIO_FUNCIONAMENTO <- droplevels(nas$DT_INICIO_FUNCIONAMENTO)

str(nas)
# View(nas)

# ---------------rodar quando atualizar ----------------------

# Vamos tentar corrigir isso ao mÃ¡ximo; onde nÃ£o for possível, colocamos "M" (missing, mas nÃ£o deixar NA, que atrapalha seleÃ§Ã£o)

# Caso UF/Municipio missing = EAD

na_uf <- df_curso_select[!complete.cases(df_curso_select$CO_UF),]
na_municipio <- df_curso_select[!complete.cases(df_curso_select$CO_MUNICIPIO),]
na_ead <- df_curso_select[df_curso_select$TP_MODALIDADE_ENSINO == "EAD",]
str(na_ead$TP_MODALIDADE_ENSINO)
length(na_uf$CO_UF)
length(na_municipio$CO_MUNICIPIO)
length(na_municipio$CO_MUNICIPIO)

# View(na_uf)
# View(na_municipio)
# View(na_ead)
# iguais?

# unique(na_uf == na_municipio)
# unique(na_uf == na_ead)

# ok, sÃ£o os mesmos, vamos colocar EAD nas duas variÃ¡veis onde Ã© EAD

# Adicionando o level "EAD" (jÃ¡ foi)
# levels(df_curso_select$uf) <- c(levels(df_curso_select$uf), "EAD")
# levels(df_curso_select$municipio) <- c(levels(df_curso_select$municipio), "EAD")

df_curso_select[is.na(df_curso_select$uf),"uf"] <- "EAD"
df_curso_select[is.na(df_curso_select$mun),"municipio"] <- "EAD"

# rodar nas

# checando se ABI = area bÃ¡sica de ingresso <-> OCDE = NA

na_ocde <- df_curso_select[!complete.cases(df_curso_select$cod_ocde),]
ingr_abi <- df_curso_select[df_curso_select$atrib_ingr == "ABI",]

# testando os valores da comparaÃ§Ã£o (nÃ£o eliminar levels antes de fazer isso)

# unique(na_ocde == ingr_abi)

# sÃ£o iguais

# str(na_ocde)
# str(ingr_abi)

# Vamos colocar "ABI" no lugar de NA em OCDE

# Adcionar level ABI para OCDE

levels(df_curso_select$cod_ocde) <- c(levels(df_curso_select$cod_ocde), "ABI")
levels(df_curso_select$cod_ocde)

# Trocar NA para "cod_ocde"

df_curso_select[is.na(df_curso_select$cod_ocde),"cod_ocde"] <- "ABI"

# rodar nas novamente

# grau_acad = "NA" para esses casos, mas podem haver outros, vamos checar se hÃ¡ algum outro NA nessa categoria

na_grau <- df_curso_select[!complete.cases(df_curso_select$grau_acad),]
na_grau$grau_acad <- droplevels(na_grau$grau_acad)
str(na_grau)

# HÃ¡ outros casos
View(na_grau)

# Os casos em que atrib_ingr = 1, colocamos tbem "ABI"

levels(df_curso_select$grau_acad) <- c(levels(df_curso_select$grau_acad), "ABI")
levels(df_curso_select$grau_acad)

df_curso_select[(is.na(df_curso_select$grau_acad) & df_curso_select$atrib_ingr == "ABI"),"grau_acad"] <- "ABI"

# rodar nas

# Todos os "NA" estÃ£o em grau_acad, sÃ£o cusos sequenciais -> vamos colocar "SEQ" no lugar NA em grau_acad

levels(df_curso_select$grau_acad) <- c(levels(df_curso_select$grau_acad), "Seq")
levels(df_curso_select$grau_acad)

df_curso_select[(is.na(df_curso_select$grau_acad) & df_curso_select$niv_acad == "Seq"),"grau_acad"] <- "Seq"

# checar nas

# summary(df_curso_select)

# rodar nas



# df_curso_select$uf

# levels <- as.numeric(df_curso_select$uf)
# levels

# grepl seleciona pattern nos valores de uma coluna
# selecionando apenas os cursos com "ENGENHARIA" no nome

eng <- df_curso_select[grepl("ENGENHARIA",df_curso_select$curso),]

# eliminar cursos de tecnologia

eng <- eng[eng$grau_acad != "Tecn",]

str(eng)
#View(eng)

# eliminando os fatores nÃ£o utilizados
eng$cod_ocde <- droplevels(eng$cod_ocde)
eng$grau_acad <- droplevels(eng$grau_acad)
eng$niv_acad <- droplevels(eng$niv_acad)
eng$atrib_ingr <- droplevels(eng$atrib_ingr)
eng$situacao <- droplevels(eng$situacao)
eng$curso <- droplevels(eng$curso)
eng$uf <- droplevels(eng$uf)
eng$municipio <- droplevels(eng$municipio)
eng$mod_ens <- droplevels(eng$mod_ens)
eng$data_func <- droplevels(eng$data_func)
eng$ies <- droplevels(eng$ies)

names(eng)

# basic orperations with data frame

# is.data.frame(eng[1:10,]) # subsetting a row produces a data frame
# is.data.frame(eng[,2]) #subsetting a column does not produce a data.frame -> use subset or:

# to get a data frame, use drop = F
# eng[,4, drop=F]
# is.data.frame(eng[,4, drop=F])

#eng[is.na(eng),]


levels(eng$uf)

# operating dataframes
#eng$concl_total / eng$ingr_total
#is.data.frame(eng$concl_total / eng$ingr_total)

#----------------- Cruzamentos: Cross Tables

table_ca <- table(eng$cat_adm) #this gives the number of courses in each of the 6 adm categories
table_ca.uf <- table(eng$cat_adm,eng$uf)
class(table_ca)

# aggregate creates a datafile with sums of columns according to categories in another column
table_byuf <- aggregate(cbind(Ingr=eng$ingr_total, Matr=eng$matr_total, Concl=eng$concl_total), by=list(UF=eng$uf), FUN=sum)

table_byuf
str(table_byuf)

#View(table_byuf)


sp<-subset(eng, eng$uf=="SP")
sp
str(sp)
#View(sp)


#?aggregate
table_agreg_eng <- aggregate(cbind(Ingr=eng$ingr_total, Matr=eng$matr_total, Concl=eng$concl_total),by=list(Cat_adm=eng$cat_adm, Org_acad=eng$org_acad, UF=eng$uf), FUN=sum)
table_agreg_sp <- aggregate(cbind(Ingr=sp$ingr_total, Matr=sp$matr_total, Concl=sp$concl_total), by=list(Cat_adm=sp$cat_adm, Org_acad=sp$org_acad), FUN=sum)


# ------------- FIM CODIGO ----------

# SALVAR OS ARQUIVOS EM transform/inep/ano
if (!dir.exists(out_dir)) {
  dir.create(out_dir)
}
cat(out_dir)
nome_arquivo <- paste(nome_do_a_ser_salvo, ".csv", sep = "")
caminho_arquivo <- paste(out_dir, nome_arquivo , sep = "/")


tryCatch(
  
  {
    write.csv(arquivo, file = caminho_arquivo, row.names = FALSE)
  },
  
  error = function(error_message) {
    message(error("----------------- ERRO ---------------------------------"))
    message("Arquivo não foi gravado! Verifique!")
    
  }
)

}

}

}else{
  
  print("NAO EXISTEM ARQUIVOS .CSV NESTE DIRETORIO!")
}

}

}

# str(arquivo)
# View(arquivo)


# if (file.exists(arquivos_inep)) {
#     
#     cat("EXISTE")
#     
#   }
#     
#     # pegando os arquivos de forma automatica e setando seus nomes
#     for (file in arquivos_inep) {
#       # if apenas para teste, apos, tira-lo para carregar todos os arquivos inep
#       if (file == "DM_CURSO.CSV") {
#         letra <- strsplit(file, "_")[[1]]
#         letra <- letra[2]
#         letra <- strsplit(letra, "\\.")[[1]]
#         
#         
#         # cria de forma dinamica o nome do arquivo
#         arquivo <- paste("df_" , str_to_lower(letra[1])
#   
#         arquivo <- read.csv(file , sep="|",encoding="latin1")
#         
#       }
#       
#     }
#   
#   paste(arquivo, ".csv")

