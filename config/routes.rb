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
        post 'follow'
        delete 'unfollow'
        get 'followers'
        get 'followings'
      end
    end

    # Posts
    resources :posts do
      collection do
        get 'likes', to: 'posts#like_index'
      end
      resource :like, only: [:create, :destroy] # 投稿ごとのいいね
      resources :comments, only: [:create, :destroy] do # 投稿に対するコメント
        resource :like, only: [:create, :destroy] # 投稿のコメントに対するいいね
      end
    end

    # Tickets
    get 'tickets/users/:id', to: 'tickets#my_tickets', as: 'user_tickets' # 自分の所持しているチケット一覧
    get 'tickets/issued_tickets/:user_id', to: 'tickets#issued_tickets', as: 'user_issued_tickets' # ユーザーの発行したチケット一覧。パスの最後はユーザーIDを受け取る。
    get 'tickets/:id/individual_tickets', to: 'tickets#individual_tickets', as: 'issued_individual_tickets'# ユーザーの発行したチケットの個別チケット一覧。
    resources :tickets do
      member do
        get 'transfer'
      end
      resource :like, only: [:create, :destroy] # チケットごとのいいね
      resources :comments, only: [:create, :destroy] do # チケットに対するコメント
        resource :like, only: [:create, :destroy] # チケットのコメントに対するいいね
      end
    end
    
    # IndividualTickets
    resources :individual_tickets, only: [:index, :show, :update] do
      collection do
        post :acquire # チケットを取得する
      end
      
      member do
        patch :transfer # チケット譲渡用
        patch :mark_as_used # チケットを使用済みにする
      end
    end
    
    # Requests
    resources :requests, only: [:create, :update]
    
    # Notifications
    resources :notifications, only: [:index, :show, :destroy]

    # Likes
    get 'users/:id/likes/posts', to: 'likes#index_posts', as: 'user_post_likes'
    get 'users/:id/likes/tickets', to: 'likes#index_tickets', as: 'user_ticket_likes'


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
