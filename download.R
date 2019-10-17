
# para colorir a saida das mensagens no console 
library(crayon)
# definindo a cor padrão dos avisos de erro e warning
error <- red$bold
warn <- magenta$underline
#source("local_settings.R")

#---- remover toda a lista de varivaeis carregas do rstudio
#rm(list=ls())

getwd()
setwd("~/carlos/projeto_R/indicadores")
getwd()

args <- commandArgs(trailingOnly = TRUE)

collection <- function(name_collection) {
  comment(collection) <- "funcao que recebe o nome da collection para download. 
                          e chama a funcao especifica desta collection para isso"
  
  
  coll <- name_collection
  
  if (coll == "inep") {
    teste <- "Sim"
    teste
    source("download/inep_download/inep_download.R")
    
  }else{
    teste <- "Nao"
    teste
  }
  
}

tryCatch(
  
  {
    collection(args[1])
  },
  
  error = function(error_message) {
    message(error("----------------- ERRO ---------------------------------"))
    message("Passar o nome da collection. Ex: Rscript download.R inep")
    
  }
)

collection_escolhida <- readline(prompt = "DIGITE A COLLECTION QUE DESEJA BAIXAR: ") 
coll <- str_to_lower(as.character(collection_escolhida))
collection(coll)
  