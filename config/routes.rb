Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do
    get 'register/coordinator', to: 'registrations#new_coordinator', as: :new_coordinator_registration
    post 'register/coordinator', to: 'registrations#create_coordinator', as: :create_coordinator_registration

    get 'register/researcher', to: 'registrations#new_researcher', as: :new_researcher_registration
    post 'register/researcher', to: 'registrations#create_researcher', as: :create_researcher_registration

    patch 'registrations/:id/activate_coordinator', to: 'registrations#activate_coordinator', as: :activate_coordinator
    patch 'registrations/:id/deactivate_coordinator', to: 'registrations#deactivate_coordinator', as: :deactivate_coordinator
    patch 'registrations/:id/activate_researcher', to: 'registrations#activate_researcher', as: :activate_researcher
    patch 'registrations/:id/deactivate_researcher', to: 'registrations#deactivate_researcher', as: :deactivate_researcher
  end

  root "home#index"

  get 'coordinators', to: 'supervisors#index_coordinator', as: :coordinators
  get 'researchers', to: 'supervisors#index_researcher', as: :researchers

  get 'supervisor/projects', to: 'supervisors#index_project', as: :supervisor_projects
  get 'supervisor/project/:id', to: 'supervisors#show_project', as: :supervisor_project
  get 'supervisor/projects/search', to: 'supervisors#search_project', as: :search_supervisor_projects

  resources :coordinators, only: [:show, :edit, :update] do
    resources :projects, only: [:index, :show, :edit, :update] do
      get "search", on: :collection
    end
  end

  resources :researchers, only: [:show, :edit, :update] do
    resources :projects, only: [:index, :show, :new, :create] do
      get "search", on: :collection
    end
  end

end
