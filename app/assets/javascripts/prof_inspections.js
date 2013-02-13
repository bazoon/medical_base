// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//
$(document).ready(function(){  
 $(".alert-message").alert(); 


  $('#prof_inspections th a,#prof_inspections .pagination a').live('click', function () {
    $.getScript(this.href);
    return false;
  });


 // Search form.
  $('#prof_inspections_search').submit(function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });



 $( "#inspections" ).accordion();
 
  $(function() {
    $("#prof_inspection_tabs").tabs();
  });



});  

function remove_fields(link) {
 $(link).prev("input[type=hidden]").val("1");
 $(link).closest(".fields").hide(); 
}

function add_fields(link, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        $(link).parent().before(content.replace(regexp, new_id));
        $('.mkb').autocomplete({
              source: function(request, response) {
              var term          = request.term.toLowerCase(),
              element       = this.element,
              cache         = this.element.data('autocompleteCache') || {},
              foundInCache  = false;

              $.each(cache, function(key, data){
                if (term.indexOf(key) === 0 && data.length > 0) {
                  response(data);
                  foundInCache = true;
                  return;
                }
              });

            if (foundInCache) return;

            $.ajax({
                url: '/ajax/mkb_types',
                dataType: "json",
                data: request,
                success: function(data) {
                    cache[term] = data;
                    element.data('autocompleteCache', cache);
                    response(data);
                }
            });
        },
        minLength: 2
      });




}


