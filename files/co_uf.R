library(purrr)
library(repurrrsive)
library(rlist)
library(openxlsx)

COD_UF <- function(cod_uf) {
  
  lista_cod <- list(
                  "11" = "Rondônia",
                  "12" = "Acre",
                  "13" = "Amazonas",
                  "14" = "Roraima",
                  "15" = "Pará",
                  "16" = "Amapá",
                  "17" = "Tocantins",
                  "21" = "Maranhão",
                  "22" = "Piauí",
                  "23" = "Ceará",
                  "24" = "Rio Grande do Norte",
                  "25" = "Paraíba",
                  "26" = "Pernambuco",
                  "27" = "Alagoas",
                  "28" = "Sergipe",
                  "29" = "Bahia",
                  "31" = "Minas Gerais",
                  "32" = "Espírito Santo",
                  "33" = "Rio de Janeiro",
                  "35" = "São Paulo",
                  "41" = "Paraná",
                  "42" = "Santa Catarina",
                  "43" = "Rio Grande do Sul",
                  "50" = "Mato Grosso do Sul",
                  "51" = "Mato Grosso",
                  "52" = "Goiás",
                  "53" = "Distrito Federal"
          
                )
  
  # for (cod in names(lista_cod)) {
  #  
  #   cod_uf <- as.character(cod_uf)
  # 
  #   if (cod == cod_uf) {
  #    
  #     estado <- lista_cod[[cod]]
  #     return(estado)
  #   }
  # }
  # cod_uf <- as.character(cod_uf)
  # lista_cod[which(names(lista_cod) == cod_uf)]
  
  #map_chr(got_chars[9:12], "name")
  #print(names(lista_cod))
  if ( !is.character(cod_uf)) {
    cod_uf <- as.character(cod_uf)
  }
  
  #result <- map(lista_cod[2], names(lista_cod))
  #result <- list.map(lista_cod, ifelse(names(lista_cod) == cod_uf, lista_cod[[cod_uf]], NULL))
  find_mun <- function(cod_uf) {
    
      return(cod_uf)
  }
  
  result <- sapply(lista_cod[[cod_uf]], find_mun, simplify = T)
  
  return(result[[1]])

}
# COD_UF(11)
# lista_cod <- list(
#   "11" = "Rondônia",
#   "12" = "Acre",
#   "13" = "Amazonas",
#   "14" = "Roraima",
#   "15" = "Pará",
#   "16" = "Amapá",
#   "17" = "Tocantins",
#   "21" = "Maranhão",
#   "22" = "Piauí",
#   "23" = "Ceará",
#   "24" = "Rio Grande do Norte",
#   "25" = "Paraíba",
#   "26" = "Pernambuco",
#   "27" = "Alagoas",
#   "28" = "Sergipe",
#   "29" = "Bahia",
#   "31" = "Minas Gerais",
#   "32" = "Espírito Santo",
#   "33" = "Rio de Janeiro",
#   "35" = "São Paulo",
#   "41" = "Paraná",
#   "42" = "Santa Catarina",
#   "43" = "Rio Grande do Sul",
#   "50" = "Mato Grosso do Sul",
#   "51" = "Mato Grosso",
#   "52" = "Goiás",
#   "53" = "Distrito Federal"
#   
# )

# getwd()
# setwd("C:\\Users\\cgt\\Documents\\carlos\\projeto_R\\indicadores\\files")
# df <- as.data.frame(lista_cod, row.names = FALSE, optional = TRUE)
# 
# library('data.table')
# dat <- melt(as.data.table(df, keep.rownames = "Vars"), id.vars = "Vars")
# names(dat)
# df_cod_uf <- subset(dat, select = c("variable", "value"))
# names(df_cod_uf) <- c("cod", "nome")
# write.xlsx(df_cod_uf, "plan_cod_uf.xlsx")
