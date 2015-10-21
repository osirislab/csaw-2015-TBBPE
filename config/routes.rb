Rails.application.routes.draw do
  root "posts#index"

  get    "/posts",                to: "posts#index",   as: :posts
  get    "/posts/search",         to: "posts#search",  as: :posts_search
  get    "/posts/new",            to: "posts#new",     as: :new_post
  get    "/posts/:id",            to: "posts#show",    as: :post
  post   "/posts",                to: "posts#create"
  post   "/posts/:id/like",       to: "posts#like",    as: :like_post
  post   "/posts/:id/dislike",    to: "posts#dislike", as: :dislike_post
  get    "/posts/:id/edit",       to: "posts#edit",    as: :edit_post
  patch  "/posts/:id",            to: "posts#update"

  resource :users, only: %w(new create)
end
