# Author : Duncan P. 
# Shiny globals file for voting interface. 

library(shinythemes)
library(synapseClient)
synapseLogin()

tableId <- 'syn5260108'
synTable <- synTableQuery('Select * from syn5260108')
geneList <- as.vector(as.matrix(synTable@values[[1]]))








