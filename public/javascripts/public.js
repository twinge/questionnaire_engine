// used by answer sheets
// NOTE: must restart server after changes, to copy to plugin_assets

var PageHandler = Class.create();

// TO DO: handle failure, exception and timeout cases
PageHandler.prototype = {
  initialize : function(page) {
    this.auto_save_frequency = 30;  // seconds
    this.timer_id = null;
	  this.suspendLoad = false;
    
    this.current_page = page;
    this.registerAutoSave();
    
    this.page_validation = new Hash();  // validation objects for each page
    this.enableValidation(page);
    
    this.background_load = false;
    this.final_submission = false;
  },
  
  // swap to a different page
  showPage : function(page) {
    // hide the old
    $(this.current_page + '-link').removeClassName('active'); 
    $(this.current_page).hide();
  
	// HACK: Need to clear the main error message when returning to the submit page
	//       It is very confusing to users to be there when they revisit the page
	if ((page=='submit_page') && ($('submit_message'))) $('submit_message').hide(); 
	if ((page=='submit_page') && ($('application_errors'))) $('application_errors').update('');

    // show the new
	$(page + '-link').removeClassName('incomplete');
	$(page + '-link').removeClassName('valid');
	$(page + '-link').addClassName('active');
    $(page).show();
    
    this.current_page = page;
    this.registerAutoSave();
	this.suspendLoad = false;
  },
  
  // callback onSuccess
  pageLoaded : function(transport) {
    var response = new String(transport.responseText);
    var match = response.match(/<div id=\"(.*?)\"/i); // what did I just load? parse out the first div id
    if( match != null )
    {
      var page = match[1];
      new Insertion.Bottom('preview', response);
      if(this.background_load) $(page).hide(); else this.showPage(page);  // show after load, unless loading in background
      this.enableValidation(page);
    }
  },
  
  loadPage : function(page, url) {
    if (!this.suspendLoad) {
		this.suspendLoad = true; // don't load a page if one is currently loading (prevent double-click behavior where two pages end up visible!)
		
		this.unregisterAutoSave();  // don't auto-save while loading/saving
	      // will register auto-save on new page once loaded/shown
	    
		new Effect.ScrollTo('main');

	    this.validatePage(this.current_page);   // mark current page as valid (or not) as we're leaving
	    
	    this.savePage();
	
	    if( $(page) && page.match('no_cache') == null )   // if already loaded (element exists) excluding pages that need reloading
	    {
	      this.showPage(page);
	    }
	    else
	    {
	      new Ajax.Request(url, {asynchronous:true, evalScripts:false, method:'get', 
	          onSuccess:this.pageLoaded.bind(this)});
	    }
	}
  },
  
  // save form if any changes were made
  savePage : function() {
    form_data = this.captureForm();
    
    if( form_data )
    {
      if( this.page_form_data == null || this.page_form_data['data'] !== form_data['data'])   // if any changes
      {
        this.page_form_data = form_data;
        
        new Ajax.Request(form_data['url'], {asynchronous:true, evalScripts:false, method:'put', parameters:form_data['data'],
          onFailure:function() {
            this.page_form_data = null;    // on error, force save for next call to save
              // WARNING: race conditions with load & show?
              // sort of a mess if save fails while another page is already loading!!
          }.bind(this)});
      }
    }
  },
  
  // setup a timer to auto-save (only one timer, for the page being viewed)
  registerAutoSave: function() {
    this.page_form_data = this.captureForm();
    this.timer_id = setInterval(this.savePage.bind(this), this.auto_save_frequency * 1000);
  },
  
  unregisterAutoSave: function() {
    if( this.timer_id != null ) 
    {
      clearInterval(this.timer_id);
      this.timer_id = null;
    }
  },
  
  // serialize form data and extract url to post to
  captureForm : function() {        
    form_el = $(this.current_page + '-form');
    if( form_el == null ) return null;
        
    // serialize with old-school query params (false), since it's easier to compare than a hash
    return $H({url: form_el.readAttribute('action'), data: Form.serialize(form_el)});
  },
  
  
  // enable form validation (when form is loaded)
  enableValidation : function(page) {
    this.page_validation[page] = new Validation(page + '-form', {onSubmit:false, immediate:true, focusOnError:false});  // Set these both to false because it was breaking navigation.  since we call them manually, we don't need the validator to do it automatically
  },
  
  validatePage : function(page) {
    valid = this.page_validation[page].validate();

    if(!valid)
    {  
	  el = $(page + '-link');
	  el.removeClassName('valid');
      el.addClassName('incomplete');
    }
    else
    {
	  el = $(page + '-link');
      el.removeClassName('incomplete');
	  el.addClassName('valid');
    }
    
    return valid;
  },
  
  // load all pages in the background
  validateAll : function()
  {
    this.final_submission = true;
    var btn = $('submit_button'); if (btn) { btn.disable(); }
    
    if(this.background_load == true) { this.completeAll(); return; } // already loaded
    
    // load all pages, completeAll callback will be called to validate and submit the form
    this.background_load = true;
    
    // retrieve onclick from links from page navigation
    links = $('list-pages').getElementsBySelector('a').invoke('readAttribute', 'onclick');
      
    // parse page/url parameters from loadPage call
    pages = new Array();
    links.invoke('scan', /loadPage\('(.*)','(.*)'\)/, function(match) { pages.push( $H({page: match[1], url: match[2]}) ) });
    
    // skip over pages that are already loaded (check if element by that name exists)
    pages = pages.reject( function(page) { return($(page['page']) !== null); });
    
    if(pages.size() == 0) { this.completeAll(); return; } // already loaded

    page_loader = this;
    pages.each(function(page) {
      new Ajax.Request(page['url'], {asynchronous:true, evalScripts:false, method:'get', 
          onSuccess:page_loader.pageLoaded.bind(page_loader)});
    });
        
    // don't reset background_load flag here (if changed before loading is complete, it'll mess things up, and there will be no further load requests anyway)
  },
  
  clearAll : function(transport) {
  	pages = this.page_validation.keys();
	  pages.each(function(page) { 
      // HACK: this.current_page is undefined here.  hard-coded.
	  //alert(this.current_page);
	    if (page != 'submit_page') $(page).remove();
    });
    //Remove all but first page from _validation
  },
  
  // callback when falls to 0 active Ajax requests
  completeAll : function()
  {
    // was running validateAll for final submission
    if( this.final_submission == true )
    {
      pages = this.page_validation.keys();
      
      // validate all pages
      var all_valid = true;
      page_loader = this;
      pages.each(function(page) { 
//        $(page).show();   // validation requires form to be visible (grr) - disabled this requirement in validation.js
        if( !page_loader.validatePage(page) ) all_valid = false;
//        $(page).hide(); 
      });
//      $( this.current_page ).show();
      
      if( all_valid )
      {
        this.savePage();  // in case any input fields on submit_page
        
        // submit the application
        if($('submit_to'))
        {
          url = $F('submit_to');

    		  // HACK: Simple fix - clear out pages array to force reload.  This enables "frozen" apps
    		  //       immediately after submission - :onSuccess (for USCM which stays in the application vs. redirecting to the dashboard)
    		  var curr = this.current_page;
    		  var pages = this.page_validation.keys();
          new Ajax.Request(url, {asynchronous:true, 
		                             evalScripts:true, 
								 method:'post', 
								 onSuccess: function() {
									pages.each(function(page) { 
								    // HACK: this.current_page is undefined here.  hard-coded.
									  if (page != curr) $(page).remove();
								  });
								 }
							});
        }
      }
      else
      {
        // some pages aren't valid
        var el = $('submit_message')
        if(el) { el.update("Please ensure all pages are complete and valid, then submit again."); el.show(); }
        
        var btn = $('submit_button'); if (btn) { btn.enable(); }
      }
      
      this.final_submission = false;
	    this.background_load = false;
    }
  },
  
  // is page loaded? (useful for toggling enabled state of questions)
  isPageLoaded : function(page)
  {
    return this.page_validation.include(page);
  }
  
}


