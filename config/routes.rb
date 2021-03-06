# -*- encoding : utf-8 -*-
Trans::Application.routes.draw do
  root :to => 'home#index'
  resources :notices do
    collection do
      get :read, :unread
    end
  end
  resources :excels do
    collection do
      get :export_translations
      post :export_translations
    end
  end
  resources :categories
  resources :languages
  resources :documents do
    collection do
      get :uploaded, :batch_new, :batch_assign
      post :batch_create, :batch_assign
    end
    resources :comments
    resources :operations
    resources :translations
  end
  resources :translations do
    collection do
      get :generated, :assigned, :sent, :translated, :approved, :finished, :batch_assign, :batch_archive, :batch_upload, :batch_approve, :batch_archive_approved, :search, :search_generated, :search_assigned, :search_approved, :search_finished, :autocomplete_employee_name
      post :batch_assign, :batch_archive, :batch_upload, :batch_approve, :batch_archive_approved, :search_generated, :search_assigned, :search_approved, :search_finished
    end
    member do
      get :download
    end
    resources :comments
  end
  resources :users do
    resources :expertises
    collection do
      get 'edit_password'
      post 'update_password'
    end
  end
  resources :employees
  resources :mails
  match 'signin' => 'sessions#new', :as => :signin, :via => [:get]
  match 'signin' => 'sessions#create', :as => :signin, :via => [:post]
  match 'signout' => 'sessions#destroy', :as => :signout
end

