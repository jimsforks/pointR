
# cmdPreProcPtsExport<-function(){
#   click('buttonPreprocPtExport')
# }

# observeEvent(input$buttonPreprocPtExport,{
#   fp.dt<-parseSavePath(c(home='~'), input$buttonPreprocPtExport)
#   if(length(fp.dt)>0 && length(fp.dt$datapath)>0 ){
#     fileName<-as.character(fp.dt$datapath[1])
#     scripts<-getPreProcPtScript()[preprocChoices$points]
#     txt0<-paste(names(scripts),'= function( pt, context, WH, keys){\n',scripts,"\n}", collapse=",\n")
#     str_split(txt0, '\n')[[1]]->lines
#     paste0("  ", lines,collapse="\n")->txt1
#     txt<-paste0('preprocPts<-list(\n', txt1, "\n)")
#     writeLines(txt, fileName)
#   }
# })

# cmdPreProcAtsExport<-function(){
#   click('buttonPreprocAtExport')
# }

# observeEvent(input$buttonPreprocAtExport,{
#   fp.dt<-parseSavePath(c(home='~'), input$buttonPreprocAtExport)
#   if(length(fp.dt)>0 && length(fp.dt$datapath)>0 ){
#     fileName<-as.character(fp.dt$datapath[1])
#     scripts<-getPreProcPtScript()[preprocChoices$attrs]
#     txt0<-paste(names(scripts),'= function( pt, context, WH, keys){\n',scripts,"\n}", collapse=",\n")
#     str_split(txt0, '\n')[[1]]->lines
#     paste0("  ", lines,collapse="\n")->txt1
#     txt<-paste0('preprocAts<-list(\n', txt1, "\n)")
#     writeLines(txt, fileName)
#   }
# })

