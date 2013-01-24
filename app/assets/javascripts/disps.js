// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//

$(document).ready(function() {


$('#disp_form').bind('update_me',function(){

 	var client_id = $("#client_id").val();

 	var path = "/clients/"+client_id+"/disps/new.js";
 	
 	// alert(path);


  

 $.ajax({
    url: path,             // указываем URL и
    dataType : "html",                     // тип загружаемых данных
    success: function (data, textStatus) { // вешаем свой обработчик на функцию success
       
       $("#disp_form").html(data)
       $("#disp_form" ).effect("highlight");
    } 
});



 });





  return $('#disp_mkb').autocomplete({
    source: "/ajax/mkb_types",


    select: function( event, ui ) {
      $(".mkb").val(ui.item.id);
  
  }



  });


  
   
  


});

$("#disp_tabs").tabs();