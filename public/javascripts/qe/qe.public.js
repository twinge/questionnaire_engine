// used by answer sheets
// NOTE: must restart server after changes, to copy to plugin_assets
(function($) {
	$(function() {
		$('.reference_send_invite').live('click', function() {
      var el = this;
			var data = $(el).closest('form').serializeArray();
			data.push({name: 'answer_sheet_type', value: answer_sheet_type});
      $.ajax({url: $(el).attr('href'), data: data, dataType: 'script',  type: 'POST'});
			return false;
		});
	});
	$.qe = {};
	$.qe.pageHandler = {
	  initialize : function(page) {
	    this.auto_save_frequency = 30;  // seconds
	    this.timer_id = null;
		  this.suspendLoad = false;
    
	    this.current_page = page;
			$('#' + page).data('form_data', this.captureForm($('#' + page)));
	    this.registerAutoSave();
    
	    this.page_validation = {};  // validation objects for each page
	    this.enableValidation(page);
    
	    // this.background_load = false;
	    // this.final_submission = false;
	  },
  
	  // swap to a different page
	  showPage : function(page) {
	    // hide the old
	    $('#' + this.current_page + '-link').removeClass('active'); 
	    $('#' + this.current_page).hide();
  
			// HACK: Need to clear the main error message when returning to the submit page
			//       It is very confusing to users to be there when they revisit the page
			if ((page=='submit_page') && ($('#submit_message')[0] != null)) $('#submit_message').hide(); 
			if ((page=='submit_page') && ($('#application_errors')[0] != null)) $('#application_errors').html('');

	    // show the new
			$('#' + page + '-link').removeClass('incomplete');
			$('#' + page + '-link').removeClass('valid');
			$('#' + page + '-link').addClass('active');
	    $('#' + page).show();
	    this.current_page = page;
	    this.registerAutoSave(page);
			this.suspendLoad = false;
	  },
  
	  // callback onSuccess
	  pageLoaded : function(response) {
	    // var response = new String(transport.responseText);
	    var match = response.match(/<div id=\"(.*?)\"/i); // what did I just load? parse out the first div id
	    if( match != null )
	    {
	      var page = match[1];
	      $('#preview').append(response);
	      // if(this.background_load) $('#' + page).hide(); else 
				$.qe.pageHandler.showPage(page);  // show after load, unless loading in background
				setUpJsHelpers();
	      $.qe.pageHandler.enableValidation(page);
				$.qe.pageHandler.validatePage('#' + page);
	    }
			$('#page_ajax_spinner').hide();
			updateTotals();
	  },
  
	  loadPage : function(page, url) {
	    if (!this.suspendLoad) {
				this.suspendLoad = true; // don't load a page if one is currently loading (prevent double-click behavior where two pages end up visible!)
		
				this.unregisterAutoSave();  // don't auto-save while loading/saving
			      // will register auto-save on new page once loaded/shown
	    
				$.scrollTo('#main');

		    this.validatePage(this.current_page);   // mark current page as valid (or not) as we're leaving
	    
		    this.savePage();
	
		    if( $('#' + page)[0] != null && page.match('no_cache') == null )   // if already loaded (element exists) excluding pages that need reloading
		    {
		      $.qe.pageHandler.showPage(page);
					$('#page_ajax_spinner').hide();
		    }
		    else
		    {
					$.ajax({
             url: url,
             type: 'GET',
						 data: {'answer_sheet_type':answer_sheet_type},
						 success: $.qe.pageHandler.pageLoaded,
             error: function (xhr, status, error) {
                 alert("There was a problem loading that page. We've been notified and will fix it as soon as possible. To work on other pages, please refresh the website.");
             }
         });
		      // new Ajax.Request(url, {asynchronous:true, evalScripts:false, method:'get', 
		      //     onSuccess:this.pageLoaded.bind(this)});
		    }
			}
	  },
  
	  // save form if any changes were made
	  savePage : function(page) {  
			if (page == null) page = $('#' + this.current_page);
	    form_data = this.captureForm(page);
	    if( form_data ) {
	      if( page.data('form_data') == null || page.data('form_data').data !== form_data.data) {  // if any changes
	        page.data('form_data', form_data);
					$.ajax({url: form_data.url, type: 'put', data: form_data.data, error: function() {
																															             page.data('form_data', null);    // on error, force save for next call to save
																														               // WARNING: race conditions with load & show?
																														               // sort of a mess if save fails while another page is already loading!!
																																          }});
	    	}
	  	}
		},
		
		savePages : function() {
			$('.answer-page').each(function() {$.qe.pageHandler.savePage($(this))})
		},
  
	  // setup a timer to auto-save (only one timer, for the page being viewed)
	  registerAutoSave: function(page) {
	    this.timer_id = setInterval(this.savePages, this.auto_save_frequency * 1000);
	  },
  
	  unregisterAutoSave: function() {
	    if( this.timer_id != null ) 
	    {
	      clearInterval(this.timer_id);
	      this.timer_id = null;
	    }
	  },
  
	  // serialize form data and extract url to post to
	  captureForm : function(page) {      
	    form_el = $('#' + page.attr('id') + '-form');
	    if( form_el[0] == null ) return null;
			return {url: form_el.attr('action'), data: form_el.serialize() + '&answer_sheet_type=' + answer_sheet_type};
	  },
  
  
	  // enable form validation (when form is loaded)
	  enableValidation : function(page) {
	    $('#' + page + '-form').validate({onsubmit:false, focusInvalid:false});  
	  },
  
	  validatePage : function(page) {
			try {
			  el = $(page + '-link');

		    valid = el.hasClass('valid');

		    if(!valid)  {  
				  el.removeClass('valid');
		      el.addClass('incomplete');
		    }
		    else  {
				  el = $(page + '-link');
			      el.removeClass('incomplete');
				  el.addClass('valid');
		    }
    
		    return valid;
			}
			catch(err) {
			
				// If the user clicks too quickly, sometimes the page element isn't properly defined yet.
				// If we don't catch the error, js stops execution. If we catch it, the user just has to click again.
			}
			$('page_ajax_spinner').hide();
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
		var all_valid = ($('#list-pages a.incomplete').length == 0);
		if( all_valid )
		{
		  this.savePage($('#' + this.current_page));  // in case any input fields on submit_page
  
		  // submit the application
		  if($('#submit_to')[0] != null)
		  {
		    url = $('submit_to').val();
				alert(url);
			  // clear out pages array to force reload.  This enables "frozen" apps
			  //       immediately after submission - :onSuccess (for USCM which stays in the application vs. redirecting to the dashboard)
			  var curr = this.current_page;
			  $.ajax(url, {dataType:'script', 
					 method:'post', 
					 success: function() {
						$('#list-pages a').each(function() { 
					    // HACK: this.current_page is undefined here.  hard-coded.
						  if ($(this).attr('data-page-id') != curr) $('#' + $(this).attr('data-page-id')).remove();
					  });
					 }
				});
		  }
		}
		else
		{
		  // some pages aren't valid
		  var el = $('#submit_message');
		  if(el) { el.html("Please ensure all pages are complete and valid, then submit again."); el.show(); }
  
		  var btn = $('#submit_button'); if (btn) { btn.attr('disabled', false); }
		}
  },
  
  // is page loaded? (useful for toggling enabled state of questions)
  isPageLoaded : function(page)
  {
    return this.page_validation.include(page);
  }
  
};


function submitToFrame(dom_id, url)
{
	$(dom_id + "-spinner").show();
  var form_dom = dom_id + '-form';
  var old_action = $(form_dom).action;
  var old_target = $(form_dom).target;
  $(form_dom).action = url;
  $(form_dom).target = dom_id + '-iframe';
  $(form_dom).submit();
  $(form_dom).action = old_action;
  $(form_dom).target = old_target;
}

function updateTotal(id) {
	try {
		total = 0;
		$$(".col_" + id ).each(function(e) {
		  total += Number(e.value);
		});
		$('total_' + id).value = total;
	} catch(e) {}
}

})(jQuery);