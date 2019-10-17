df <- df[!duplicated(df$col),]
getwd()
# duas barras pq no windows a barra que separa os diretorios e ao contrario
#setwd('indicadores\\download\\inep_download')
setwd("~/carlos/projeto_R/indicadores/download/inep_download")
library(magrittr)
library(stringr)
library(tibble)
library(dplyr)
library(plyr)
library(data.table)

anos <- list.dirs(path = ".", full.names = TRUE, recursive = TRUE)

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
          
          df_curso <<- read.csv(sprintf("%s",paste(dir_download, file, sep = '/')) , sep = "|", encoding = "latin1")
          
        } #retirar
        if (file == "TB_AUX_AREA_OCDE.CSV") {
          df_ocde <<- read.csv(sprintf("%s",paste(dir_download, file, sep = '/')) , sep = "|", encoding = "latin1")
        }
        
        if (file == "DM_IES.CSV") {
          df_ies <<- read.csv(sprintf("%s",paste(dir_download, file, sep = '/')) , sep = "|", encoding = "latin1")
        }
        
      } #retirar
    } #retirar
  } #retirar
} #retirar depois, só pra teste
str(df_curso)
str(df_ocde)
str(df_ies)

#--selecionando as variaveis do df_IES
df_ies_select <- subset(df_ies, select = c("CO_IES", "NO_IES", "SG_IES"))

# -- merge dos DFs curso x IES 
df_merged <- merge(df_curso, df_ies_select, by = "CO_IES", sort = TRUE, no.dups = TRUE)

#selecting the relevant columns
df_curso_select <- subset(df_merged, select = c(NU_ANO_CENSO,CO_IES,NO_IES, SG_IES, TP_CATEGORIA_ADMINISTRATIVA, 
                          TP_ORGANIZACAO_ACADEMICA,CO_LOCAL_OFERTA, CO_UF, CO_MUNICIPIO,
                          IN_CAPITAL, CO_CURSO, NO_CURSO,TP_SITUACAO,
                          CO_OCDE_AREA_GERAL, CO_OCDE_AREA_ESPECIFICA, CO_OCDE_AREA_DETALHADA, 
                          CO_OCDE, TP_GRAU_ACADEMICO,TP_MODALIDADE_ENSINO,TP_NIVEL_ACADEMICO, 
                          IN_GRATUITO, TP_ATRIBUTO_INGRESSO, NU_CARGA_HORARIA, DT_INICIO_FUNCIONAMENTO, 
                          DT_AUTORIZACAO_CURSO, IN_INTEGRAL, IN_MATUTINO, IN_VESPERTINO, IN_NOTURNO, IN_OFERECE_DISC_SEMI_PRES, 
                          NU_PERC_CARGA_SEMI_PRES, IN_POSSUI_LABORATORIO,QT_MATRICULA_TOTAL,QT_CONCLUINTE_TOTAL, 
                          QT_INGRESSO_TOTAL, QT_INGRESSO_VAGA_NOVA,QT_INGRESSO_PROCESSO_SELETIVO,QT_VAGA_TOTAL))


cat_adm <- c("PublFed","PublEst","PublMun", "PrivCFL", "PrivSFL", "Especial")
tp_cat_adm <- subset(df_curso_select, select = c("TP_CATEGORIA_ADMINISTRATIVA"))
tp_cat_adm <- tp_cat_adm[!duplicated(tp_cat_adm$TP_CATEGORIA_ADMINISTRATIVA),]
tp_cat_adm <- tp_cat_adm[order(tp_cat_adm)]
lista_adm_in <- as.character(tp_cat_adm)
df_curso_select$nome_cat_adm <- plyr::mapvalues(df_curso_select$TP_CATEGORIA_ADMINISTRATIVA, lista_adm_in, cat_adm)

org_acad <- c("Univ","CUniv", "Fac/Inst", "Ifet", "Cefet")
tp_org_acad <- subset(df_curso_select, select = c("TP_ORGANIZACAO_ACADEMICA"))
tp_org_acad <- tp_org_acad[!duplicated(tp_org_acad$TP_ORGANIZACAO_ACADEMICA),]
tp_org_acad <- tp_org_acad[order(tp_org_acad)]
lista_cat_in <- as.character(tp_org_acad)
df_curso_select$nome_org_acad <- plyr::mapvalues(df_curso_select$TP_ORGANIZACAO_ACADEMICA, lista_cat_in, org_acad)

# -- carregando a planilha de UF
df_cod_uf <- read.xlsx("C:\\Users\\cgt\\Documents\\carlos\\projeto_R\\indicadores\\files\\plan_cod_uf.xlsx")
lista_uf_in <- as.character(df_cod_uf$cod)
lista_uf_out <- as.character(df_cod_uf$nome)
df_curso_select$nome_uf <- plyr::mapvalues(df_curso_select$CO_UF, lista_uf_in, lista_uf_out)

# -- carregando a planilha de municipios
df_cod_munic <- read.xlsx("C:\\Users\\cgt\\Documents\\carlos\\projeto_R\\indicadores\\files\\plan_cod_municipios.xlsx")
lista_munic_in <- as.character(df_cod_munic$cod)
lista_munic_out <- as.character(df_cod_munic$name)
df_curso_select$nome_municipio <- plyr::mapvalues(df_curso_select$CO_MUNICIPIO, lista_munic_in, lista_munic_out)


in_capital <- c("Nao", "Sim")
in_capital_select <- subset(df_curso_select, select = c("IN_CAPITAL"))
in_capital_select <- in_capital_select[!duplicated(in_capital_select),]
# --- removendo NA
in_capital_select <- in_capital_select[!is.na(in_capital_select)]
lista_capital_in <- as.character(in_capital_select)
df_curso_select$nome_in_capital <- plyr::mapvalues(df_curso_select$IN_CAPITAL, lista_capital_in, in_capital)



df_area_geral <- subset(df_ocde, select = c("CO_OCDE_AREA_GERAL", "NO_OCDE_AREA_GERAL"))
df_area_geral <- df_area_geral[!duplicated(df_area_geral$CO_OCDE_AREA_GERAL),]
df_area_geral <- df_area_geral[order(df_area_geral$CO_OCDE_AREA_GERAL),]
lista_area_in <- as.character(df_area_geral$CO_OCDE_AREA_GERAL)
lista_area_out <- as.character(df_area_geral$NO_OCDE_AREA_GERAL)
df_curso_select$nome_area_geral <- plyr::mapvalues(df_curso_select$CO_OCDE_AREA_GERAL, lista_area_in, lista_area_out, warn_missing = FALSE)


df_area_espec <- subset(df_ocde, select = c("CO_OCDE_AREA_ESPECIFICA", "NO_OCDE_AREA_ESPECIFICA"))
df_area_espec <- df_area_espec[!duplicated(df_area_espec$CO_OCDE_AREA_ESPECIFICA),]
df_area_espec <- df_area_espec[order(df_area_espec$CO_OCDE_AREA_ESPECIFICA),]
lista_espec_in <- as.character(df_area_espec$CO_OCDE_AREA_ESPECIFICA)[-1]
lista_espec_out <- as.character(df_area_espec$NO_OCDE_AREA_ESPECIFICA)[-1]
lista_espec_out[[22]] <- c("Serviços de segurança")
df_curso_select$nome_area_espec <- plyr::mapvalues(df_curso_select$CO_OCDE_AREA_ESPECIFICA, lista_espec_in, lista_espec_out)


df_area_det <- subset(df_ocde, select = c("CO_OCDE_AREA_DETALHADA", "NO_OCDE_AREA_DETALHADA"))
df_area_det <- df_area_det[!duplicated(df_area_det$CO_OCDE_AREA_DETALHADA),]
df_area_det <- df_area_det[order(df_area_det$CO_OCDE_AREA_DETALHADA),]
lista_det_in <- as.character(df_area_det$CO_OCDE_AREA_DETALHADA)
lista_det_out <- as.character(df_area_det$NO_OCDE_AREA_DETALHADA)
df_curso_select$nome_area_detalhada <- plyr::mapvalues(df_curso_select$CO_OCDE_AREA_DETALHADA, lista_det_in, lista_det_out, warn_missing = FALSE)

df_cod_ocde <- subset(df_ocde, select = c("CO_OCDE", "NO_OCDE"))
df_cod_ocde <- df_cod_ocde[!duplicated(df_cod_ocde$CO_OCDE),]
df_cod_ocde <- df_cod_ocde[order(df_cod_ocde$CO_OCDE),]
lista_ocde_in <- as.character(df_cod_ocde$CO_OCDE)
lista_ocde_out <- as.character(df_cod_ocde$NO_OCDE)
df_curso_select$nome_ocde <- plyr::mapvalues(df_curso_select$CO_OCDE, lista_ocde_in, lista_ocde_out, warn_missing = FALSE)


 


