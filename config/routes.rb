Qe::Engine.routes.draw do
  
  namespace :admin do 
    resources :question_sheets
  end

end
