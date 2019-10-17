#getwd()
setwd("~/carlos/projeto_R/indicadores/files")

library(tidyr)
library(readxl)


find_municipio <- function(cod_munic) {
  variable_load <<- ls()
  search_load <- grepl('^munic$', variable_load)
  #search_load <- grepl("munic", variable_load, fixed = TRUE)
  is_variable_load <- variable_load[search_load]
  
  if (identical(is_variable_load, character(0))) {
    munic <<- read.xlsx("~/carlos/projeto_R/indicadores/files/cod_municipios.xlsx")
    
  }

  munic$cod <- as.character(munic$cod)
  munic$name <- as.character(munic$name)
  
  if( !is.character(cod_munic)) {
    cod_munic <- as.character(cod_munic)
  }
  search <- as.character(cod_munic)
  result <- mapvalues(search, munic$cod, munic$name)
  
  return(result)
  
}

# --- passar para a funcao os códigos do municipio
# codigo_a_passar <- read_xlsx("cod_municipios.xlsx")
# cod <- codigo_a_passar$cod
# 
# nomes <- find_mun_test(cod)


