function setUpSortables() {
	$('[data-sortable]').sortable({axis:'y', 
																  dropOnEmpty:false, 
																	activeClass: 'moving',
																  update: function(event, ui) {
																		sortable = this;
																		$.ajax({data:$(this).sortable('serialize',{key:sortable.id + '[]'}),
																						complete: function(request) {$(sortable).effect('highlight')}, 
																						success:function(request){$('#errors').html(request)}, 
																						type:'POST', 
																						url: $(sortable).attr('data-sortable-url')
																					 })
																		}
	});
	$('[data-sortable][data-sortable-handle]').each(function() {
		handle = $(this).attr('data-sortable-handle');
		$(this).sortable("option", "handle", handle);
	});
	
		
	$('.droppable').droppable({
		activeClass: 'ui-state-highlight',
		drop: function( event, ui ) {
			$.post($(this).attr('data-url'), {draggable_element: ui.draggable.attr('id')}, function() {}, 'script')
		},
	});
}

function setUpCalendars() {
	$('[data-calendar]').datepicker({changeYear:true,
																	 yearRange: '1975:c+5'})
}

function setUpJsHelpers() {
		// ==================
		// Sortable
		setUpSortables();
		// ==================
		
		// ==================
		// Calendar
		setUpCalendars();
  	// ==================
		$("[title]").tooltip({
		   // tweak the position
       offset: [0, 20],
    
       // use the "slide" effect
       effect: 'slide'
		}).dynamic({ bottom: { direction: 'down', bounce: true } });;
}
