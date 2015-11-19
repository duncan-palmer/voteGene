# Author : Duncan P.
# Shiny Server for gene voting interface.

shinyServer(
	function(input,output){

		geneQuery <- reactive({
			synTableQuery(paste("Select comment From syn5260108 Where geneName='",input$genes,"'",sep=''))@values$comment
			})

		output$display <- renderUI({tags$textarea(placeholder='Comment',id='comment',rows=10,cols=45)})
		output$comment1 <- renderText(geneQuery()[1])
		output$comment2 <- renderText(geneQuery()[2])
				
		# When user submits their vote, pull out the associated vote table to upload vote data as another row. 
		observeEvent(input$voteSubmit,{
			# Visualization/Backend wrapped in progress bar.
			withProgress(message='Uploading Data/Making Votes Plot',{
			gene <- input$genes

			# Give visualization.
			query <- synTableQuery(paste("Select * From syn5260108 Where geneName = '",gene,"'",sep=''))
			votes <- c(length(which(query@values[,6] == 1)),length(which(query@values[,6] == -1)),length(which(query@values[,6] == 0)))	
			output$voteVis <- renderPlot({barplot(votes,col=c('blue','red','green'),names.arg=c('Y','N','NA'),main=paste(gene,'Votes'))})			

			# Logic to process result.
			cols <- synGetColumns(tableId)
			df <- data.frame('geneName'=gene,'nominee'='DuncanP','comment' = input$comment,'evidence'='syn5260108','evidenceType'='NA','vote' = as.numeric(input$vote))
			schema <- TableSchema(name = 'genes',parent='syn5051764',columns = lapply(1:length(cols),function(i){cols[[i]]@id}))
			rowAppend <- synapseClient::Table(schema,df)
			synStore(rowAppend,retrieveData=TRUE)
			})})
})
