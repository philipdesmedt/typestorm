Rails.application.routes.draw do
  root 'pages#landing'

  post '/analyze',                to: 'pages#analyze'
end
