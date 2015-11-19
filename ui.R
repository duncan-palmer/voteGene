# Author : Duncan P
# Shiny UI for gene voting interface.

shinyUI(fluidPage(theme=shinytheme('flatly'),
	titlePanel('Gene Voting'),

	sidebarLayout(
		sidebarPanel(
			selectizeInput('genes','Genes',choices = geneList,options = list(maxOptions = 5)),
			radioButtons('vote',label=h3('Vote'),choices = list('Yes' = 1,'No' = -1,'No Opinion' = 0)),
			actionButton('voteSubmit','Submit'),
			br(),
			br(),
			h4('Previous Comments'),
			uiOutput('comment1'),
			br(),
			uiOutput('comment2')),

		mainPanel(
			uiOutput('display'),
			plotOutput('voteVis')
			))
))
