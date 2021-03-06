
moduleEdAssetUI<-function(id, input, output) { 
  ns <- NS(id)
  #---header backdrop
  # absolutePanel( id=ns('header'), "class"="headerPanel", draggable=FALSE
  # ),
  #---asset name
  #-------asset button
  tagList(
    div( 'class'="ptRBtn2 topHeadCol1 topHeadRow1",
       actionButton(ns("newAssetButton"), span(class='icon-plus'," ptR Asset") )
    ),
  #------asset chooser
    div('class'="topHeadCol2 topHeadRow1",
        uiOutput(ns("dataSetUI"))
    )
  )
}


#------------ui ouput----------------------
moduleEdAsset<-function(input, output, session, 
    name, 
    nameChoices
){
  ns <- session$ns
  #---assets
  output$dataSetUI<-renderUI({
    if( length(nameChoices() )>0 && length(name())>0 && name() %in% nameChoices() ){
      butts<- nameChoices()
      selected=name()
      jqScrollBar(inputId=ns("name"),  choices =butts, selected =selected)
      # radioGroupButtons(inputId=ns("name"), choices=butts, selected=name(),
      #                   justified=TRUE)
    }
  }) 
  
  
  
  list(
    name          = reactive({input$name}),
    newAsset      = reactive({input$newAssetButton})
  )
}
