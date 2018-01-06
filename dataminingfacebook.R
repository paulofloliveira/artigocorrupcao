### ---------------------------------------------------------------------------
### Donwload e Analise de conteudo do Facebook
### ---------------------------------------------------------------------------

# instalando pacotes necessario, esta etapa só precisa fazer uma vez no seu 
# computador
install.packages("Rfacebook")
install.packages("tm")
install.packages("wordcloud")
install.packages("igraph")
install.packages("ggdendro")
install.packages("ggplot2")

# carregando os pacotes
library(Rfacebook)
library(igraph)
library(wordcloud)
library(tm)
library(ggdendro)
library(readr)
library(ggplot2)

# antes de continuar e' necessario criar um app (aplicativo) no facebook
# pode ser usando já a sua conta normal do facebook, mas acessando o 
# modulo desenvolverdor https://developers.facebook.com
# ir em My app > Add new app
# escolha a opcao website
# defina um nome
# click em criar new app
# coloque seu email de contato
# escolha a categoria
# click em criar app id
# coloque o codigo se segunraca e click em submit
# clikc em Skip Quick Start - no canto superior da tela

# autenticar o R com o meu app criado na pagina do Facebook
fb_oauth <- fbOAuth(app_id="529500980767363", app_secret="b9ac3fb934e1926708242c9dc209fa90", extended_permissions = TRUE)

save(fb_oauth, file="fb_oauth")

load("fb_oauth")

## download dados
