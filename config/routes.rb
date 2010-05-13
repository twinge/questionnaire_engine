ActionController::Routing::Routes.draw do |map|
  map.resources :question_sheets do |sheets|
    sheets.resources :pages,                               # pages/
                     :controller => :question_pages,
                     :name_prefix => 'question_',          # question_pages_path(),
                     :collection => { :reorder => :put },
                     :member => { :show_panel => :get } do |pages|
      pages.resources :elements,
                      :collection => { :reorder => :put },
                      :member => { :remove_from_grid => :post, :drop => :post, :duplicate => :post }
    end
  end

  # form capture and review
  map.resources :answer_sheets do |sheets|
    sheets.resources :pages,                              # pages/
                     :controller => :answer_pages,
                     :name_prefix => 'answer_',           # answer_pages_path(),
                     :member => {:save_file => :post}
  end                 

  map.resources :elements
end