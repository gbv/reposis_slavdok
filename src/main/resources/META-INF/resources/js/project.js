
$(document).ready(function () {

  // spam protection for mails
  $('span.madress').each(function (i) {
    var text = $(this).text();
    var address = text.replace(" [at] ", "@");
    $(this).after('<a href="mailto:' + address + '">' + address + '</a>')
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
  var localHref = 'http://localhost:18031/slavdok/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='http://localhost:18031/slavdok/servlets/solr/select?q=createdby:USERNAME']").attr('href', localHref);
  var testHref = 'https://reposis-test.gbv.de/slavdok/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://reposis-test.gbv.de/slavdok/servlets/solr/select?q=createdby:USERNAME']").attr('href', testHref);
  var prodHref = 'https://slavdok.slavistik-portal.de/servlets/solr/select?q=createdby:' + userID + '&fq=objectType:mods';
  $("a[href='https://slavdok.slavistik-portal.de/servlets/solr/select?q=createdby:USERNAME']").attr('href', prodHref);

  // prevent dropdown from leaving visible page area
  $(".language-menu").addClass('dropdown-menu-right');

  // hide openAIRE in forms intially
  if (localStorage.getItem('open_aire_options_are_visible') === "false") {
    $('#open-aire_box').css('display', 'none');
  }

  // toggle openAIRE in forms on-click
  $("#open-aire_trigger_checkbox").click(function () {
    toggleOAOptions();
  });


  // expand click behavoir to legend that contains the trigger
  // collapsed legend was clicked
  $("body").on("click", ".mir-fieldset-collapsed", function (event) {
    // if contained trigger was not clicked
    if (!$(event.target).hasClass('expand-item')) {
      // simulate click on trigger
      $(event.target).find('.expand-item').click();
    }
  });

  $(".bc-select").each(function () {
    // setDefault($(this));
    if ($(this).children("option").length > 0) {
      setLabelForClassificationBC($(this));
    }
    else {
      setSelect2BC($(this));
    }
  });


});

function getNewestSubmissions() {
  $.ajax({
    method: "GET",
    url: webApplicationBaseURL + "servlets/solr/find?rows=5&sort=created+desc",
    dataType: "html"
  }).done(function (html) {
    var hitListHtml = $(html).find('#hit_list').html();
    if (hitListHtml.includes("hit_1")) {
      $('#hit_list').html(hitListHtml);
      $('.hit_counter').html("&nbsp");
      $('.hit_options').html("&nbsp");
      $('.single_hit_option').html("&nbsp");
    }
  });
};

function toggleOAOptions() {
  var duration = 500;
  if ($('#open-aire_box').is(':visible')) {
    $('#open-aire_trigger').removeClass('glyphicon-check');
    $('#open-aire_trigger').addClass('glyphicon-unchecked');
    $('#open-aire_box').fadeOut(duration);
    localStorage.setItem("open_aire_options_are_visible", false);
  } else {
    $('#open-aire_trigger').removeClass('glyphicon-unchecked');
    $('#open-aire_trigger').addClass('glyphicon-check');
    $('#open-aire_box').fadeIn(duration);
    localStorage.setItem("open_aire_options_are_visible", true);
  }
};

// TODO: Parameterize the select function in MIR (type-ahead)
function setLabelForClassificationBC(parent) {
  $.ajax({
    url: webApplicationBaseURL + 'servlets/solr/select',
    data: {
      q: optionsToQuery(parent),
      fq: 'classification:base_classification',
      wt: 'json',
      core: 'classification'
    },
    dataType: 'json'
  }).done(function (data) {
    $.each(data.response.docs, function (_i, cat) {
      let text = cat['label.' + $("html").attr("lang")][0];
      if (text === undefined) {
        text = cat['label.en'][0]
      }
      getOptionWithValBC(parent, cat.category).html(text);
    });
    setSelect2BC(parent);
  });
};

function optionsToQuery(elm) {
  let query = [];
  $(elm).children().each(function (i, option) {
    if ($(option).val() !== "") {
      query.push('category:' + $(option).val());
    }
  });
  return query.join(" OR ");
};

function setSelect2BC(elm) {
  $(elm).select2({
    ajax: {
      url: webApplicationBaseURL + 'servlets/solr/select',
      data: function (params) {
        params.term = (params.term == null) ? "" : params.term;
        return {
          q: '-id:base_classification OR category *' + params.term + "* OR " + 'label.en *' + params.term + "* OR " + 'label.de *' + params.term + "*",
          fq: 'classification:base_classification',
          rows: 2147483647,
          sort: 'category ASC',
          wt: 'json',
          core: 'classification'
        };
      },
      dataType: 'json',
      processResults: function (data) {
        let res = {
          results: $.map(data.response.docs, function (obj) {
            let text = obj['label.' + $("html").attr("lang")];
            if (text === undefined) {
              text = obj['label.en'][0]
            }
            else {
              text = text[0];
            }
            return { id: obj.category, text: text };
          })
        };
        addDefault(elm, res);
        return res;
      },
    },
    minimumInputLength: 0,
    language: $("html").attr("lang")
  });
};

function addDefault(elm, res) {
  $(elm).children().each(function (i, option) {
    let found = false;
    $.each(res.results, function (i, solrOption) {
      if (solrOption.id === $(option).val()) {
        found = true;
        return false;
      }
    });
    if (!found) {
      if ($(option).val() !== "") {
        res.results.push({ id: $(option).val(), text: $(option).html() })
      }
    }
  })
};

function getOptionWithValBC(elm, val) {
  return $(elm).find("option[value='" + val + "']");
};

$( document ).ajaxComplete(function() {
  // remove DDC from metadata view if it is the default one
  if ($('dd').text().indexOf('491.8') != -1) {
      $("dt:contains('DDC')").remove();
      $("dd:contains('491.8')").remove();
  }
});
