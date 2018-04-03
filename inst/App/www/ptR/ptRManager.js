
Shiny.addCustomMessageHandler(
  "ptRManager",
  function(data){
    //console.log('hello from ptRManager\n');
    //console.log(JSON.stringify(data));
    if(!!data.openFile){
      //console.log('about to trigger open\n');
      if( data.sender==='cmd.openFileNow'){
        $('#buttonFileOpenHidden').trigger('click');
      }
      if( data.sender==='cmd.snippet.file.open'){
        $('#buttonSnippetOpen').trigger('click');
      }
    }
    if(!!data.importSnippet){
      //console.log('about to trigger load snippet\n');
      $('#buttonSnippetOpen').trigger('click');
    }
    if(!!data.saveFile){
      var sender=data.sender;
      //console.log('data.saveFile:: sender=' + sender);
      var tabId = data.tabId;
      //console.log('data.saveFile:: tabId=' + tabId);
      //get title from tabId and stabs
      var title=stabs.getTitleGivendataValue(tabId);
      //console.log(JSON.stringify(title));
      $('#buttonFileSaveHidden').trigger('click');
      //console.log(JSON.stringify( $("h4 .sF-title .modal-title").text() ));
      $("h4.sF-title.modal-title").text( 'Save '+ title +' as ...');
      if(sender==='fileCmd.close' || sender==='fileCmd.quit'){
        $("#sF-cancelButton").text( "Close Without Saving");
        $("#buttonFileSaveHidden").on('cancel', function(event){
            Shiny.onInputChange('buttonFileSaveHidden', { cancel: 'close'});
        });
      } else {
        $("#sF-cancelButton").text( "Cancel");
        $("#buttonFileSaveHidden").on('cancel', function(event){
          Shiny.onInputChange('buttonFileSaveHidden', {cancel: 'cancel'});
        });
      }
    }
    if(!!data.exportSVG){
      //console.log('about to trigger svg export\n');
      $('#buttonExportSVGHidden').trigger('click');
    }
    if(!!data.setFocus){
      //console.log('#' + data.setFocus +'\n' );
      setTimeout(function() {$('#' + data.setFocus).focus()}, 10);
      //$('#' + data.setFocus).focus();
    }
     if(!!data.hide){
      //console.log('#' + data.hide +'\n' );
      setTimeout(function() {$('#' + data.hide).hide()}, 10);
    }
    if(!!data.addClass){
      //var klass=data.addClass.klass;
      setTimeout(function() {$('#' + data.addClass.id).addClass(klass)}, 10);
    }
    if(!!data.snippetButtonActivate){
      $(".snippetButton").each( function(){
        $(this).draggable({
    		//revert: true
    		opacity: 0.5,
    		stroke: "#FFFFFF",
    		helper: 'clone',
        revert: 'invalid',
        appendTo: 'body'
      }); 
    });
    }
    if(!!data.rowCountChange){
      $(window).resize();
    }
  }
  
); 



$('document').ready(function()
{
  $('.hiddenButton').hide();
  

  
  document.addEventListener('keydown', function(event) {
    if (event.code == 'KeyW' && (event.ctrlKey || event.metaKey)) {
      alert('phew!');
      event.stopPropagation();
    }
  });
  
  /*
  $("#left-component").on('resize', function(e){
    console.log('resize #left-component');
  });

  $(".split-pane-component").on('resize', function(e){
    console.log('resize #split-pane-component');
  });
  */
  
  
  var sntb = new SnippetToolBaR( "snippetToolBarContainer", "dndSnippetList", "snippetScrollDown", "snippetScrollUp", 32);
  sntb.reAdjustPos();
  $(sntb.downId).click(function(){sntb.onDownClick();});
  $(sntb.upId).click(function(){sntb.onUpClick();});
  $(window).on('resize',function(e){  
    //console.log('resize window');
    	sntb.reAdjustPos();
  });
  
  var rsb = new rowScrollBaR("rowOutPanel",  "rowDND-rowPanel", "rowScrollDown","rowScrollUp", 32 );
  //"rowDND-rowPanel" does not have position(), actually no attributes
  
  //var rsb = new rowScrollBaR("rowOutPanel",  "rowDND-rowIndex", "rowScrollDown","rowScrollUp", 32 );
  
  
  rsb.reAdjustPos();
  $(rsb.downId).click(function(){rsb.onDownClick();});
  $(rsb.upId).click(function(){rsb.onUpClick();});
  $(window).on('resize',function(e){  
      //console.log('resize window');
    	rsb.reAdjustPos();
  });
  
  
  /*
  $(window).on('resize',function(e){  
  	alert('resize window');
  });
  */
  
    
/*  
  $('.cAceContainer').droppable({
    
    //activeClass: "ui-state-default",
    //hoverClass: "ui-state-hover",
    accept: ":not(.ui-sortable-helper)",

    drop: function(event, ui) {
      console.log('0:  drop occurred');
      var theEditor = $(this).data('aceEditor'); 
      console.log( JSON.stringify( this.data ))
      var pos = theEditor.renderer.screenToTextCoordinates(event.clientX, event.clientY);
      
      console.log("pos=" + JSON.stringify(pos));
      var txt =  ui.draggable.attr("data-snippet");
      $(this).focus();
      theEditor.moveCursorToPosition(pos);
      //editor.session.insert(pos, txt);
      //editor.insert(txt);
      ui.helper.remove();
      
	    var tab_press= jQuery.Event('keydown', {which: 88});
       var snippetManager = ace.require("ace/snippets").snippetManager;
       snippetManager.insertSnippet(theEditor, txt);
       
       setTimeout( function(){
       $(this).focus();
       console.log('drop occurred');
 	     $(this).trigger(tab_press);
       }, 5);
      return true;
    }


  });
*/  

  //$('body').on('keypress', 'enter')
});




