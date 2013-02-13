// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//

// take from here http://developwithstyle.com/articles/2010/05/14/jquery-ui-autocomplete-is-it-any-good/

// $(document).ready(function() {



// var cache = {};
// $(".mkbs").autocomplete({
//   source: function(request, response) {
//     var term          = request.term.toLowerCase(),
//         element       = this.element,
//         cache         = this.element.data('autocompleteCache') || {},
//         foundInCache  = false;

//     $.each(cache, function(key, data){
//       if (term.indexOf(key) === 0 && data.length > 0) {
//         response(data);
//         foundInCache = true;
//         return;
//       }
//     });

//       if (foundInCache) return;

//       $.ajax({
//           url: '/ajax/mkb_types',
//           dataType: "json",
//           data: request,
//           success: function(data) {
//               cache[term] = data;
//               element.data('autocompleteCache', cache);
//               response(data);
//           }
//       });
//   },
//   minLength: 2
// });  








// });
