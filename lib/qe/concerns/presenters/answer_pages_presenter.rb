# A presenter is a class representation of a view, which consolidates data from multiple models
# Pages editing can be initiated from 3 different controllers, AnswerSheets for the initial load, 
#   AnswerPages to AJAX load in another page, and (in BOAT) the ApplicationsController for multiple sheets.
# Rather than duplicate code from controller to controller, each place can simply reference this Presenter.

# We always need data to render the current page for editing. 
# On the initial load, we need data for the page list (sidebar).
# On later page loads, we need to determine the "next page" which basically requires the page list again.

# require 'qe/concerns/presenters/presenter'

# module Qe::Concerns::Presenters::AnswerPagesPresenter
#   extend ActiveSupport::Concern
# end
