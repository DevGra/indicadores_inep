#  criar as funções padrão e ler os dicionarios em files, todos os arquivos que forem usados pelas funções, ficaram la.
getwd()
setwd("~/carlos/projeto_R/indicadores/files")
source("co_uf.R")
source("co_municipio.R")


# pode se redirecionar a saida em um arquivo
# ex: cat("aluguma coisa", "\n", file = "arquivo de saida")
    # num <- c(2, 4, 6)
    # cat(num, file = "teste.txt")

# outra forma
# sink("filename")
# .
# source("script.R")
# .
# sink()

# recebe o nome de resposta do codigo para a funcao CO_UF

teste <- CO_UF(22)
Encoding(teste) <- "UTF-8"
teste

list.files()

munic <- CO_MUNICIPIO(5222054)
#Encoding(munic) <- "UTF-8"
Encoding(munic) <- "latin1"
munic

# ---------------  use to specify a root of project------------------------------------
# Sys.getenv()
# Sys.getenv("HOME")

# rstudioapi::getActiveProject() # project path
# rstudioapi::getActiveDocumentContext()$path # file path
# And you can use getwd() to check whether path is modified or not.


