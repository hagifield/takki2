Rails.application.routes.draw do
  
  devise_for :admins, controllers: {
  registrations: "admin/registrations",
  sessions: "admin/sessions"
  }
  devise_for :users, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }
  
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Public側
  scope module: :public do
    # Homes
    root to: 'homes#top' # トップページ
    get 'about', to: 'homes#about'

    # Users
    get 'mypage', to: 'users#mypage'
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        get 'followers'
        get 'followings'
      end
    end

    # Posts
    resources :posts do
      collection do
        get 'likes', to: 'posts#like_index'
      end
      resources :comments, only: [:create, :destroy] # ポストに対するコメント
    end

    # Tickets
    get 'tickets/users/:id', to: 'tickets#my_tickets', as: 'user_tickets' # 自分の所持しているチケット一覧
    get 'tickets/users/:id/issued', to: 'tickets#my_issued_tickets', as: 'user_issued_tickets' # 自分の発行したチケット一覧
    resources :tickets do
      member do
        get 'transfer'
      end
      resources :comments, only: [:create, :destroy] # チケットに対するコメント
    end
    
    
    # Notifications
    resources :notifications, only: [:index, :show, :destroy]

    # Likes
    resources :likes, only: [:create, :destroy] do
    end
    get 'users/:id/likes/posts', to: 'likes#index_posts', as: 'user_post_likes'
    get 'users/:id/likes/tickets', to: 'likes#index_tickets', as: 'user_ticket_likes'

    # Ownerships
    resources :ownerships, only: [:create, :destroy]

    # Relationships (follows/unfollows)
    resources :relationships, only: [:create, :destroy]
  end

  # Adminネームスペース
  namespace :admin do
    # Admin Users
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        get 'followers'
        get 'followings'
      end
    end

    # Admin notifications
    resources :admin_notifications, only: [:new, :create, :index]
  end
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
