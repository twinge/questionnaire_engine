// used by form designer

var currentTab = 'pages_list';

function switchTab(toTab) {
  if(currentTab != null) $('tab-' + currentTab).removeClassName('active');
  $('tab-' + toTab).addClassName('active');
  currentTab = toTab;
}

function selectPage() {
    el = $('link-page-name');
    clearCurrentElement();
    el.addClassName('active');
    switchTab('properties');
    
    if( $('page_label')) $('page_label').activate();
}

function selectElement(id) {
    el = $(id);
    clearPageName();
    clearCurrentElement();
    el.addClassName('active');
    snapElementProperties(el);
    activeElement = id;
    switchTab('properties');
    
    if( $('element_label')) $('element_label').activate();
}

function clearCurrentElement() {
    if (activeElement != '' && $(activeElement)) { 
        $(activeElement).removeClassName('active');
    }
}

function clearPageName() {
    $('link-page-name').removeClassName('active');
}

function snapElementProperties(el) {
    propsTop = Position.cumulativeOffset(el)[1] - 160;
    if (propsTop < 0) propsTop = 0;
    $('panel-properties-element').style.marginTop = propsTop + "px";
}

function scrollToElement(id) { 
    $(id).scrollTo(); 
}

function addError(id) {
    $(id).addClassName('fieldWithErrors');
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
    $(dest).activate();
  }
}

function updateTotal(id) {
	total = 0;
	$$(".col_" + id ).each(function(e) {
	  total += Number(e.value);
	});
	$('total_' + id).value = total;
}

