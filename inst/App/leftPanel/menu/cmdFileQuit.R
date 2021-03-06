

cmdFileQuit<-reactive({
  storeAssetState()
  fd<-getAllNamedUnsavedFiles()
  choices<-fd$filePath
  if(length(choices)>0){
    choices<-structure((fd$tabId), names=choices)
    showModal(fileQuitModal(choices))
  } else {
    cmdQuitNow()
  }
})

cmdQuitNow<-reactive({
  savePage(input$pages)
  opts<-isolate(reactiveValuesToList((editOption)))
  opts<-sapply(opts,unlist, USE.NAMES = T, simplify = F )
  writeOptionsJSON(opts)
  sendPtRManagerMessage(sender='closePtRWindowNow', now=TRUE)
  Sys.sleep(1)
  
  stopApp()
})



fileQuitModal<-function(choices){
  modalDialog( 
    # onkeypress=doQuit, 
    span('The following named files have unsaved changes.'), 
    div( class='ptR2',
         prettyCheckboxGroup(
           inputId = "namedUnsavedFilesChBox",
           label = "Check to Save", 
           choices = choices, 
           selected=NULL
         )
    ),
    footer = tagList(
      actionButton("checkAll", "Save All and Exit"),
      actionButton("quitNow",  "Save Selected and Exit")
    )
  ) 
} 



observeEvent(input$checkAll,{
  removeModal()
  savePage(input$pages)
  # now put tabs on tab list and save all
  selection<-getAllNamedUnsavedFiles()$tabId
  if(length(selection)==0){
    cmdQuitNow()
  } else {
    #iterate over each tab id selection and save each, then quit 
    setTabRequest(sender='fileCmd.quit', tabs=selection)
  }
})

observeEvent(input$quitNow,{
  selection<-input$namedUnsavedFilesChBox
  removeModal()
  savePage(input$pages)
  # now put tabs on tab list and save all
  if(length(selection)==0){
    cmdQuitNow()
  } else {
    #iterate over each tab id selection and save each, then quit 
    setTabRequest(sender='fileCmd.quit', tabs=selection)
  }
  
})



# observeEvent(input$modalSaveOrQuitCancel, {
#   removeModal()
# }) 
# 
# observeEvent(input$QuitWithoutSaving, {
#   js$closeWindow()
#   Sys.sleep(1)
#   stopApp()  
# }) 
# 
