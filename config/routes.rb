Qe::Engine.routes.draw do

  namespace :admin do
    resources :email_templates
    
    resources :question_sheets do 
      member do
        post :archive
        post :unarchive
        post :duplicate
      end
     
      resources :pages, :controller => :question_pages do         # question_sheet_pages_path(),
                collection do
                  post :reorder
                end
                member do
                  get :show_panel
                end
     
      resources :elements do
                collection do
                  post :reorder
                end
                member do
                  get :remove_from_grid
                  post :use_existing
                  post :drop
                  post :duplicate
                end
              end
      end
    end
  end

end
