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
library(wordcloud2)
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
fb_oauth <- fbOAuth(app_id="", app_secret="", extended_permissions = TRUE)

save(fb_oauth, file="fb_oauth")

load("fb_oauth")

## download dados

#Página Deltan

Deltan <- getPage(page = "deltan.dallagnol", token = fb_oauth, n = 15500, feed = TRUE,since='2014/01/01', until='2018/01/01')

### nuvem de palavras
### identificando alguns assuntos
# retirando imagens
Deltan$message <- gsub('[^[:graph:]]', ' ', Deltan$message)

#retirando "ç"
Deltan$message <- gsub('ç', 'c', Deltan$message)

#retirando acentos
Deltan$message <- gsub('Á', 'A', Deltan$message)
Deltan$message <- gsub('á', 'a', Deltan$message)
Deltan$message <- gsub('é', 'e', Deltan$message)
Deltan$message <- gsub('É', 'E', Deltan$message)
Deltan$message <- gsub('Í', 'I', Deltan$message)
Deltan$message <- gsub('í', 'i', Deltan$message)
Deltan$message <- gsub('Ó', 'O', Deltan$message)
Deltan$message <- gsub('ó', 'o', Deltan$message)
Deltan$message <- gsub('Ú', 'U', Deltan$message)
Deltan$message <- gsub('ú', 'u', Deltan$message)
Deltan$message <- gsub('ã', 'a', Deltan$message)
Deltan$message <- gsub('õ', 'o', Deltan$message)
Deltan$message <- gsub('â', 'a', Deltan$message)
Deltan$message <- gsub('ê', 'e', Deltan$message)
Deltan$message <- gsub('ô', 'o', Deltan$message)
Deltan$message <- gsub('à', 'a', Deltan$message)

# preparando o Corpus
DeltanNuv = Corpus(VectorSource(Deltan$message))
DeltanNuv <- tm_map(DeltanNuv, content_transformer(tolower))
DeltanNuv <- tm_map(DeltanNuv, removePunctuation)
DeltanNuv <- tm_map(DeltanNuv, function(x)removeWords(x,stopwords("pt")))
DeltanNuv <- tm_map(DeltanNuv, function(x)removeWords(x, c('link', 'ano','nao','contra','saiba','aqui','the','dia','sao')))

#criando a nuvem de palavras
pal = brewer.pal(5, "Set2")
wordcloud(DeltanNuv, min.freq = 1, max.words = 100, random.order = T, colors = pal)

# cluste hieraquico
tdm = TermDocumentMatrix(DeltanNuv)
tdm <- removeSparseTerms(tdm, sparse = 0.98)
df <- as.data.frame(inspect(tdm))

df.scale <- scale(df)
d <- dist(df.scale, method = "euclidean")

fit.ward <- hclust(d, method = "ward.D")
ggdendrogram(fit.ward) 
