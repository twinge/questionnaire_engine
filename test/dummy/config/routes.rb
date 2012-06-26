Rails.application.routes.draw do

  get "home/index"

  # This line mounts QuestionnaireEngine's routes at the root of your application.
  # This means, any requests to URLs such as http://localhost:3000/user, will go to 
  # Questionnaire::Elements. If you would like to change where this engine
  # is mounted, simply change the :at option to something different.
  #
  # DON'T TRUST THIS - We ask that you don't use the :as option here, as
  # Questionnaire relies on it being the default of "Qe"
  #
  mount Qe::Engine, :at => '/'

  root :to => 'home#index'
  
end
