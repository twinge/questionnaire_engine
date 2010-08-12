Rails::Application.routes.draw do 
  
  namespace :admin do
    resources :question_sheets do 
      resources :pages,                               # pages/
                :controller => :question_pages do         # question_sheet_pages_path(),
                collection do
                  put :reorder
                end
                member do
                  get :show_panel
                end
        resources :elements do
                  collection do
                    put :reorder
                  end
                  member do
                    post :remove_from_grid
                    post :drop
                    post :duplicate
                  end
                end
      end
    end
  end

  # form capture and review
  resources :answer_sheets do 
    resources  :page, :controller => :answer_pages do
                member do
                  post :save_file
                end
    end
  end                 

  resources :elements
end