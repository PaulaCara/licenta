Licenta::Engine.routes.draw do
  resources :event_trails
  root 'application#home'
end
