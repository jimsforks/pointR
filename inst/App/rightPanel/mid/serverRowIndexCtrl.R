rowGroupsDB<-reactiveVal(initialRowGroupDB())


rowGroupsDB.addRow<-function(pageId, aname, cname, row_index ){
  db<-filter(rowGroupsDB(), tabId!=pageId | name!=aname | colName!= cname | rows !=row_index)
  db<-rbind(db, tibble(tabId=pageId, name=aname, rows=row_index, colName=cname))
  rowGroupsDB(db)
}

# if the number of rows change or the current row changes
# possible initial triggers causing a change in getTibNRow():
#  1. asset change 
#  2. split button 
#  3. clone button
#  4. delete row button
#  5. user code change
# possible triggers for getTibRow:
#   0. any of the above plus
#   1. rowup button
#   2. rowdown button
#  Generally, 
# the number of rows is determined from ptDefs after ace update 
# so, the control cannot determine what was the initial trigger 

observeEvent(  getTibRow(), {
  rowIndex<-input$myTibRowCntrl$selected
  if(!is.null(getTibRow()) &&
     identical(rowIndex,getTibRow()) &&
     !is.null(getTibNRow()) &&
     length(input$myTibRowCntrl$order)== getTibNRow()
  ){
    return(NULL)
  }
  updateRowPicker(session, "myTibRowCntrl",selectRow = getTibRow() )
})


# if the number of rows change 
# possible initial triggers causing a change in getTibNRow():
#  1. asset change 
#  2. split button (tagPt)
#  3. clone button (cloneRow)
#  4. delete row button (deleteRow)
#  5. user code change (USER COMMIT)
# the number of rows is determined from ptDefs after ace update 
resetRowPickeR<-function(){
  rowIndex<-input$myTibRowCntrl$selected
  if(!is.null(getTibRow()) &&
     identical(rowIndex,getTibRow()) &&
     !is.null(getTibNRow()) &&
     length(input$myTibRowCntrl$order)== getTibNRow()
  ){
    return(NULL)
  }
  updateRowPicker(session, "myTibRowCntrl",
                  selectRow = getTibRow(),
                  count= getTibNRow() # count resizes with predjudice, i.e. we loose the  group!!!
  )
  # WE SHOULD PRESERVE THE GROUP FOR 
  # NAME
  # CLONE
  # SPLIT
  # DELETE
}



#  rowPicker => selector$row,
observeEvent( input$myTibRowCntrl$selected, {
  #input$rowIndex,{
  if( getTibEditState()==TRUE ){
    log.fin(input$myTibRowCntrl$selected)
    rowIndex<-input$myTibRowCntrl$selected
    if(length(rowIndex)<1){
      rowIndex<-Inf
    }
   
    if(!is.null(getTibRow()) &&  identical(rowIndex,getTibRow())){ 
      # group<-input$myTibRowCntrl$group
      # if(length(group)>0)
      #   log.val(format(paste(group,collapse=",")))
      # else
        # cat('group is empty\n')
        # cat('bailing\n')
          # log.fout(input$myTibRowCntrl$selected)
      return(NULL)  #bail
    }
    rowIndex<-min(getTibNRow(),rowIndex)
    # compute matColIndex and update rowIndex, matColIndex
    if(identical(getColumnType(),'point')){
      pts<-getTibPts()
      matColIndex<-length(pts[[rowIndex]])/2
      updateSelected( matCol=matColIndex, rowIndex=rowIndex)
    } else {
      if(!is.null(getPreProcScript()['onChangeRow'])){
        ptDefs<-getPtDefs()
        selection<-getAssetName()
        preprocTrySetAttrValue('onChangeRow', ptDefs, rowIndex, selection, mssg=NULL)
      } else {
        updateSelected( rowIndex=rowIndex)
      }
    }
     # log.fout(input$myTibRowCntrl$selected)
  }
})

# rowPicker => the tib row order
observeEvent( input$myTibRowCntrl$order,{
  log.fin(input$myTibRowCntrl$order)
  if( getTibEditState()==TRUE &  !all(diff(input$myTibRowCntrl$order)==1)){ 
    ordering<-input$myTibRowCntrl$order
    log.val(ordering)
    name<-getAssetName()
    row<-getTibRow()
    columnName<-getTibColumnName()
    if(is.null(columnName)){
      return(NULL)
    }
    newPtDefs<-getPtDefs()
    tib<-newPtDefs$tib[[name]]
    tib<-tib[ordering,]
    newPtDefs$tib[[name]]<-tib
    row<-which(row==ordering)
    updateRowPicker(session, "myTibRowCntrl", renumber = TRUE)
    sender="reorderRow"
    updateAceExtDef(
      newPtDefs, sender=sender, 
      selector=list( name=name, rowIndex=row, columnName=columnName   ) 
    )
  }
  log.fout(input$myTibRowCntrl$order)
})


# rowPicker => rowGroupsDB 
observeEvent( input$myTibRowCntrl$group,{
  if( getTibEditState()==TRUE &&  !is.null(getTibColumnName())){
    log.fin(input$myTibRowCntrl$group)
    group<-input$myTibRowCntrl$group
    # if(length(group)>0)
    # log.val(format(paste(group,collapse=",")))
    # else
    #   cat('group is empty\n')
    aname<-getAssetName()
    pageId<-getTibTabId()
    cname<-getTibColumnName()
    # print(rowGroupsDB())
    db<-filter(rowGroupsDB(), tabId!=pageId | name!=aname)
    db<-rbind(db, tibble(tabId=pageId, name=aname,rows=group, colName=cname))
    # cat('setting rowGroupsDB with db=')
    # print(db)
    rowGroupsDB(db)
    # cat('now rowGroupsDB=')
    # print(rowGroupsDB())
    log.fout(input$myTibRowCntrl$group)
  }
})

# new asset , reload rowCntrl from rowGroupsDB
# selector$name + rowGroupsDB => rowPicker
observeEvent(getAssetName(),{ #reload rowpicker
  aname<-getAssetName()
  if(!is.null(aname)){
    log.fin("reload rowpicker")
    # log.val(aname)
    # group<-input$myTibRowCntrl$group
    # if(length(group)>0){
    #   cat('groups=\n')
    #   log.val(format(paste(group,collapse=",")))
    # } else {
    #   cat('group is empty\n')
    # }
    
    # print(rowGroupsDB())
    pageId<-getTibTabId()
    count<-getTibNRow()
    aname<-getAssetName()
    cname<-getTibColumnName()
    
    group<-filter(rowGroupsDB(), tabId==pageId,  name==aname, colName==cname)$rows
    row<-getTibRow()
    #browser()
    if(length(group)>0 && !(row %in% group)){
      row<-tail(group,1)
      updateSelected(rowIndex=row)
    }
      
    #browser()
    # cat('class of group is ',class(group),'\n')
    # updateRowPicker(session, "myTibRowCntrl",
    #                 count= count
    # )
    # cat('************ (getAssetName count=count\n')
    # print(rowGroupsDB())
    # cat('*********before**************\n')
    updateRowPicker(session, "myTibRowCntrl",
                    count= count,
                    selectRow = row,
                    addToGroup=group
    )
    # cat('*********after**************\n')
    # print(rowGroupsDB())
    # if(length(group)>0){
    #   cat('groups=\n')
    #   log.val(format(paste(group,collapse=",")))
    # } else {
    #   cat('group is empty\n')
    # }
    log.fout("reload rowpicker")
  }
})


observeEvent(getTibTabId(),{
  # log.fin(getTibTabId())
  # cat('-----initializing rowGroupDB-----\n')
  # count=getTibNRow()
  # log.val(count)
  rowGroupsDB(initialRowGroupDB())
  updateRowPicker(session, "myTibRowCntrl",
                  selectRow=getTibRow(),
                  count=getTibNRow()
                  )
  # log.fout(getTibTabId())
})
