function replaceMaskedEmails() {
  document.querySelectorAll('span.madress').forEach(span => {
    const address = span.textContent.replace(' [at] ', '@');
    const link = document.createElement('a');
    link.href = `mailto:${address}`;
    link.textContent = address;
    span.replaceWith(link);
  });
}

function ignoreEmptyFieldsOnSubmit(event) {
  const form = event.currentTarget;
  const inputs = form.querySelectorAll('input');
  inputs.forEach(input => {
    if (!input.value) {
      input.dataset.nameBackup = input.name;
      input.removeAttribute('name');
    }
  });
  // Restore field names after the form is submitted
  // setTimeout ensures this runs after the submit event completes
  setTimeout(() => {
    inputs.forEach(input => {
      if (input.dataset.nameBackup) {
        input.name = input.dataset.nameBackup;
        delete input.dataset.nameBackup;
      }
    });
  }, 0);
}

function fixLanguageMenus() {
  document.querySelectorAll(".language-menu")
    .forEach(el => el.classList.add('dropdown-menu-right'));
}

function initOpenAire() {
  const openAireBox = document.getElementById('open-aire_box');
  const openAireTrigger = document.getElementById('open-aire_trigger');
  const openAireCheckbox = document.getElementById('open-aire_trigger_checkbox');
  const duration = 500; // ms

  if (!openAireBox || !openAireTrigger || !openAireCheckbox) return;

  if (localStorage.getItem('open_aire_options_are_visible') === "false") {
    openAireBox.style.display = 'none';
    openAireBox.style.opacity = 0;
  } else {
    openAireBox.style.display = 'block';
    openAireBox.style.opacity = 1;
  }

  openAireCheckbox.addEventListener('click', () => {
    if (openAireBox.style.display !== 'none' && openAireBox.style.opacity !== '0') {
      openAireTrigger.classList.remove('glyphicon-check');
      openAireTrigger.classList.add('glyphicon-unchecked');
      fadeOut(openAireBox, duration);
      localStorage.setItem("open_aire_options_are_visible", false);
    } else {
      openAireTrigger.classList.remove('glyphicon-unchecked');
      openAireTrigger.classList.add('glyphicon-check');
      fadeIn(openAireBox, duration);
      localStorage.setItem("open_aire_options_are_visible", true);
    }
  });

  function fadeOut(element, duration) {
    element.style.transition = `opacity ${duration}ms`;
    element.style.opacity = '0';
    setTimeout(() => {
      element.style.display = 'none';
    }, duration);
  }

  function fadeIn(element, duration) {
    element.style.display = 'block';
    element.style.transition = `opacity ${duration}ms`;
    void element.offsetWidth; // trigger reflow
    element.style.opacity = '1';
  }
}

// Expand click behavior to legend that contains the trigger collapsed legend was clicked
function initFieldsetCollapsing() {
  document.body.addEventListener('click', function(event) {
    const fieldset = event.target.closest('.mir-fieldset-collapsed');
    if (!fieldset) return;

    if (!event.target.classList.contains('expand-item')) {
      const trigger = fieldset.querySelector('.expand-item');
      if (trigger) {
        trigger.click();
      }
    }
  });
}

function init() {
  document.getElementById('project-searchMainPage')?.addEventListener('submit', ignoreEmptyFieldsOnSubmit);
  replaceMaskedEmails();
  fixLanguageMenus();
  initOpenAire();
  initFieldsetCollapsing();
}

document.addEventListener("DOMContentLoaded", init);

$(document).ready(function () {
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
