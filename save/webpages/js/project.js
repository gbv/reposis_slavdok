
$(document).ready(function() {

  // spam protection for mails
  $('span.madress').each(function(i) {
      var text = $(this).text();
      var address = text.replace(" [at] ", "@");
      $(this).after('<a href="mailto:'+address+'">'+ address +'</a>')
      $(this).remove();
  });

  // activate empty search on start page
  $("#project-searchMainPage").submit(function (evt) {
    $(this).find(":input").filter(function () {
          return !this.value;
      }).attr("disabled", true);
    return true;
  });

  // replace placeholder USERNAME with username
  var userID = $("#currentUser strong").html();
  var newHref = 'https://reposis-test.gbv.de/slavdok/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://reposis-test.gbv.de/slavdok/servlets/solr/select?q=createdby:USERNAME']").attr('href', newHref);

});

function getNewestSubmissions() {
  $.ajax({
    method: "GET",
    url: webApplicationBaseURL + "servlets/solr/find?rows=3",
    dataType: "html"
  }).done( function( html ) {
    var hitListHtml = $(html).find('#hit_list').html();
    if(hitListHtml.includes("hit_1")) {
      $('#hit_list').html(hitListHtml);
      $('.hit_counter').html("&nbsp");
      $('.hit_options').html("&nbsp");
      $('.single_hit_option').html("&nbsp");
    }
  });
}