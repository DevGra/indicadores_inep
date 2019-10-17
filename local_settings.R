library(crayon)
# definindo a cor padrão dos avisos de erro e warning
error <- red$bold
warn <- magenta$underline

getwd()

setwd("C:/Users/cgt/Documents/carlos/projeto_R/indicadores")


##DIR <- 'K:/projeto_R/inep'
#setwd(file.path("K:", "projeto_r", "inep"))
PATH <- getwd()
 
DOWNLOAD_PATH <- sprintf("%s", paste(PATH, 'download', sep = " /"))
TRANSFORM_PATH <- sprintf("%s", paste(PATH, 'transform', sep = "/"))
SELECTED_PATH <- sprintf("%s", paste(PATH, 'selected', sep = "/"))
GRAPHIC_PATH <- sprintf("%s", paste(PATH, 'graphic', sep = "/"))


# lista com os diretorios padrao do projeto


DIR <- list(DOWNLOAD_DIR = DOWNLOAD_PATH,
             TRANSFORM_DIR = TRANSFORM_PATH,
             SELECTED_DIR = SELECTED_PATH,
             GRAPHIC_DIR = GRAPHIC_PATH
        )


# salva as variaveis que serao globais, em em arquivo rdata que podera ser carregado em qualquer outro arquivo
#save(DIR, file = "DIR.RData")

# para salvar uma imagem do workspace
#save.image(file = "estruturacao.RData")
