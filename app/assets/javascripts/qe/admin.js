$(function() {
	$('#status').ajaxStart(function() {
		$(this).show();
	}).ajaxComplete(function() {
		$(this).hide();
		setUpJsHelpers();
	});
	
	$('.lbOn').live('click', function() {
		if ($('#dialog-help')[0] == null) {
			$('body').append('<div id="dialog-help" style="display:none" title="Help!"><p><span id="dialog-help-message"></span></p></div>');
		}
		$.get($(this).attr('href'), function(content) {
			$('#dialog-help-message').html(content);
			$('#dialog-help').dialog({
				modal: true,
				width: 500,
				buttons: {
					Close: function() {
						$(this).dialog('close');
					}
				}
			});
		});
		return false;
	});
	
	$('.close_prop').live('click', function() {
  	$('#element_form_' + $(this).attr('data-dom_id')).hide();
	  $('#element_' + $(this).attr('data-dom_id')).show();
		return false;
	});

});
// used by form designer

var currentTab = 'pages_list';

function switchTab(toTab) {
  if(currentTab != null) $('#tab-' + currentTab).removeClass('active');
  $('#tab-' + toTab).addClass('active');
  currentTab = toTab;
}

function selectPage() {
    el = $('#link-page-name');
    clearCurrentElement();
    el.addClass('active');
    switchTab('properties');
    
    if($('#page_label').length > 0) $('#page_label').focus();
}

function selectElement(id) {
    el = $(id);
    clearPageName();
    clearCurrentElement();
    el.addClass('active');
    // snapElementProperties(el);
    activeElement = id;
    switchTab('properties');
    
    // if( $('#element_label')) $('#element_label').focus();
}

function clearCurrentElement() {
    if (activeElement != '' && $(activeElement)) { 
        $(activeElement).removeClass('active');
    }
}

function clearPageName() {
    $('#link-page-name').removeClass('active');
}

function snapElementProperties(el) {
    propsTop = Position.cumulativeOffset(el)[1] - 160;
    if (propsTop < 0) propsTop = 0;
    $('#panel-properties-element').css({'margin-top': propsTop});
}

function scrollToElement(id) { 
    $(id).scrollTo(); 
}

function addError(id) {
    $('#' + id).addClassName('fieldWithErrors');
}

// convert label to slug
function updateSlug(source, dest) {
  label = $F(source)
  slug = $F(dest)
  if( label == null || slug == null) return;  // oh oh
  
  label = label.strip();
  slug = slug.strip();
  
  if( label != '' && slug == '' ) {  // if slug is empty lets copy label to it
    slug = label.toLowerCase();
    slug = slug.gsub(/[^a-z0-9]/, '_');   // only alpha-numeric
    slug = slug.gsub(/_{2,}/, '_');       // compact double hyphens down to one
    slug = slug.gsub(/_$/, '');           // remove trailing underscores
    slug = slug.gsub(/^([0-9])/, '_\1')   // can't begin with a digit, so preprend an underscore
    if( slug.length > 36 ) slug = slug.slice(0, 36)  // max length
    
    $(dest).value = slug
    $(dest).focus();
  }
}

$(function() {
	setUpSortables();
	fixGridColumnWidths();
});
