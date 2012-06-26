// used by answer sheets
// NOTE: must restart server after changes, to copy to plugin_assets
(function($) {
	$(function() {
		$('.save_button').live('click', function() {
			$.qe.pageHandler.savePage($(this).closest('.answer-page'), true);
		});
		
		$('#payment_staff_first, #payment_staff_last').live('keydown', function(e) {
			if (e.which == 13) {
				$('#staff_search').trigger('click');
				return false;
			}
			
		});
		$('.reference_send_invite').live('click', function() {
      var el = this;
			var data = $(el).closest('form').serializeArray();
			data.push({name: 'answer_sheet_type', value: answer_sheet_type});
      $.ajax({url: $(el).attr('href'), data: data, dataType: 'script',  type: 'POST',
                        beforeSend: function (xhr) {
                            $('body').trigger('ajax:loading', xhr);
                        },
                        complete: function (xhr) {
                            $('body').trigger('ajax:complete', xhr);
                        },
                        error: function (xhr, status, error) {
                            $('body').trigger('ajax:failure', [xhr, status, error]);
                        }
										});
			return false;
		});
		$('textarea[maxlength]').live('focus', function() {
			var max = parseInt($(this).attr('maxlength'));
			$(this).parent().find('.charsRemaining').html('You have ' + (max - $(this).val().length) + ' characters remaining');
		}).live('keyup', function(){
			var max = parseInt($(this).attr('maxlength'));
			if($(this).val().length > max){
				$(this).val($(this).val().substr(0, $(this).attr('maxlength')));
			}
			$(this).parent().find('.charsRemaining').html('You have ' + (max - $(this).val().length) + ' characters remaining');
		}).live('blur', function() {
			$(this).parent().find('.charsRemaining').html('');
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
	    $('#' + this.current_page + '-li').removeClass('active'); 
	    $('#' + this.current_page).hide();
  
			// HACK: Need to clear the main error message when returning to the submit page
			//       It is very confusing to users to be there when they revisit the page
			if ((page=='submit_page') && ($('#submit_message')[0] != null)) $('#submit_message').hide(); 
			if ((page=='submit_page') && ($('#application_errors')[0] != null)) $('#application_errors').html('');

	    // show the new
			// $('#' + page + '-li').removeClass('incomplete');
			// $('#' + page + '-li').removeClass('valid');
			$('#' + page + '-li').addClass('active');
	    $('#' + page).show();
	    this.current_page = page;
	    this.registerAutoSave(page);
	    this.suspendLoad = false;
	    fixGridColumnWidths();
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
				// $.qe.pageHandler.validatePage('#' + page);
				$('#' + page).data('form_data', $.qe.pageHandler.captureForm($('#' + page)));
	    }
			$('#page_ajax_spinner').hide();
			$('.reference_send_invite').button();
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
	
		    if( $.qe.pageHandler.isPageLoaded(page) && page.match('no_cache') == null )   // if already loaded (element exists) excluding pages that need reloading
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
								document.location = document.location;
             },
             beforeSend: function (xhr) {
                 $('body').trigger('ajax:loading', xhr);
             },
             complete: function (xhr) {
                 $('body').trigger('ajax:complete', xhr);
             }
         });
		      // new Ajax.Request(url, {asynchronous:true, evalScripts:false, method:'get', 
		      //     onSuccess:this.pageLoaded.bind(this)});
		    }
			}
	  },
  
	  // save form if any changes were made
	  savePage : function(page, force) {  
			if (page == null) page = $('#' + this.current_page);
	    form_data = this.captureForm(page);
	    if( form_data ) {
	      if( page.data('form_data') == null || page.data('form_data').data !== form_data.data || force === true) {  // if any changes
	        page.data('form_data', form_data);
					$.ajax({url: form_data.url, type: 'put', data: form_data.data,  beforeSend: function (xhr) {
																								                            $('#spinner_' + page.attr('id')).show();
																									                        },
																									                        complete: function (xhr) {
																								                            $('#spinner_' + page.attr('id')).hide();
																									                        },
																																					error: function() {
																															              page.data('form_data', null);    // on error, force save for next call to save
																														                // WARNING: race conditions with load & show?
																														                // sort of a mess if save fails while another page is already loading!!
																																          }});
	    	}
	  	}
			// Update last saved stamp
		},
		
		savePages : function(force) {
			$('.answer-page').each(function() {$.qe.pageHandler.savePage($(this), force)})
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
	    $('#' + page + '-form').validate({onsubmit:false, focusInvalid:true, onfocusout: function(element) { this.element(element);}});  
	    // $('#' + page + '-form').valid();  
	  },
  
	  validatePage : function(page) {
			try {
			  var li = $('#' + page + '-li');
			  var form = $('#' + page + '-form');

		    valid = form.valid();
				// Move radio button errors up
				$('input[type=radio].error').closest('tr').addClass('error');
				$('.choice_field input[type=radio].error').removeClass('error')
					.closest('.choice_field')
					.addClass('error');
				$('div.yesno label.error').hide();
				
		    if(valid)  {  
		      el.removeClass('incomplete');
				  el.addClass('complete');
		    } else {
				  el.removeClass('complete');
		      el.addClass('incomplete');
		    }
		    return valid;
			}
			catch(err) {
			
				// If the user clicks too quickly, sometimes the page element isn't properly defined yet.
				// If we don't catch the error, js stops execution. If we catch it, the user just has to click again.
			}
			$('page_ajax_spinner').hide();
	  },
  
  // callback when falls to 0 active Ajax requests
  completeAll : function()
  {
		$('#submit_button').attr('disabled', true)
		$('#submit_message').html('');
		$('#submit_message').hide();
		// validate all the pages
  	$('.page_link').each(function(index, page) {
			$.qe.pageHandler.validatePage($(page).attr('data-page-id'));
		});	
		var all_valid = ($('#list-pages li.incomplete').length == 0);
		
		// Make sure any necessary payments are made
		var payments_made = $('.payment_question.required').length == $('.payment').length
		
		
		if(  payments_made)
		{
		  this.savePage($('#' + $.qe.pageHandler.current_page));  // in case any input fields on submit_page
  
		  // submit the application
		  if($('#submit_to')[0] != null)
		  {
		    url = $('#submit_to').val();
			  // clear out pages array to force reload.  This enables "frozen" apps
			  //       immediately after submission - :onSuccess (for USCM which stays in the application vs. redirecting to the dashboard)
			  var curr = $.qe.pageHandler.current_page;
			  $.ajax({url: url, dataType:'script',
			 		data: {answer_sheet_type: answer_sheet_type},
					type:'post', 
					beforeSend: function(xhr) {
          	$('body').trigger('ajax:loading', xhr);
					},
					success: function(xhr) {
						$('#list-pages a').each(function() { 
						  if ($(this).attr('data-page-id') != curr) $('#' + $(this).attr('data-page-id')).remove();
						})
					},
					complete: function(xhr) {
            $('body').trigger('ajax:complete', xhr);
		  			var btn = $('#submit_button'); 
						if (btn) { btn.attr('disabled', false); }
					}
				});
		  }
		}
		else
		{
		  // some pages aren't valid
 	    $('#submit_message').html("Please make a payment"); 
		  $('#submit_message').show();
  
		  var btn = $('#submit_button'); if (btn) { btn.attr('disabled', false); }
		}
  },
  
  // is page loaded? (useful for toggling enabled state of questions)
  isPageLoaded : function(page)
  {
		return $('#' + page)[0] != null
  }
  
};

})(jQuery);

$(function() {
	fixGridColumnWidths();
});


function updateTotal(id) {
	try {
		total = 0;
		$(".col_" + id ).each(function(e) {
		  total += Number(e.val());
		});
		$('#total_' + id).val(total);
	} catch(e) {}
}

function submitToFrame(id, url)
{
  form = $('<form method="post" action="'+url+'.js" endtype="multipart/form-data"></form>')
  var csrf_token = $('meta[name=csrf-token]').attr('content'),
      csrf_param = $('meta[name=csrf-param]').attr('content'),
			dom_id = '#attachment_field_' + id,
			metadata_input = '<input name="'+csrf_param+'" value="'+csrf_token+'" type="hidden" />',
			file_field = '<input type="file" name="answers['+ id + ']>';
	if ($(dom_id).val() == '')	return;
  form.hide()
      .append(metadata_input)
      .append(file_field)
      .appendTo('body');
	$(dom_id + "-spinner").show();
  form.submit();
	return false
}
