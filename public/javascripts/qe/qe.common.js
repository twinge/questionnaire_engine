function setUpSortables() {
	$('[data-sortable]').sortable({axis:'y', 
																  dropOnEmpty:false, 
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
		activeClass: 'droppable-active',
		drop: function( event, ui ) {
			$.post($(this).attr('data-url'), {draggable_element: ui.draggable.attr('id')}, function() {}, 'script')
		}
	});
}

function setUpCalendars() {
	now = new Date();
	year = now.getFullYear() + 10;
	$('[data-calendar]').datepicker({changeYear:true,
																	 yearRange: '1950:' + year})
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
		$(".tip[title]").tooltip({
		   // tweak the position
       offset: [0, 20],
    
       // use the "slide" effect
       effect: 'slide'
		}).dynamic({ bottom: { direction: 'down', bounce: true } });
}

function fixGridColumnWidths() {
	$("table.grid").each(function(i, grid) {
		num_columns = $(grid).find("th").length;
		if (num_columns > 0) {
			width = (100 / num_columns) + "%";
			$(grid).find("th").css("width", width);
			$(grid).find("td").css("width", width);
		}
	});
};
