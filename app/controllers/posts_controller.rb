# 投稿に関する機能を提供するコントローラー
# ApplicationControllerを継承して基本的なコントローラー機能を利用
class PostsController < ApplicationController
  # Deviseのメソッドを使用してユーザー認証を要求
  # index, showアクション以外はログインが必要
  before_action :authenticate_user!, except: [:index, :show]

  # 各アクションの前に実行される共通処理を定義
  # set_post: 指定されたIDの投稿を@postに設定
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # ensure_correct_user: 投稿者本人かどうかを確認
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  # GET /posts
  # 全ての投稿を新しい順に取得して表示
  def index
    @posts = Post.all

    # 検索機能
    if params[:search].present?
      @posts = @posts.where('title LIKE ? OR content LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    end

    # カテゴリーフィルター
    if params[:category].present? && params[:category] != 'all'
      @posts = @posts.where(category: params[:category])
    end

    # ソート機能
    case params[:sort]
    when 'newest'
      @posts = @posts.order(created_at: :desc)
    when 'oldest'
      @posts = @posts.order(created_at: :asc)
    else
      @posts = @posts.order(created_at: :desc)
    end

    @categories = Post::CATEGORIES
  end

  # GET /posts/:id
  # 個別の投稿を表示（@postは:set_postで設定済み）
  def show
  end

  # GET /posts/new
  # 新規投稿用のフォームを表示
  def new
    @post = current_user.posts.build
  end

  # POST /posts
  # 新規投稿を作成
  def create
    # current_user（ログイン中のユーザー）に紐づいた投稿を作成
    @post = current_user.posts.build(post_params)
    if @post.save
      # 保存成功時は投稿詳細ページにリダイレクト
      redirect_to @post, notice: '投稿が作成されました。'
    else
      # バリデーションエラー時は新規投稿フォームを再表示
      render :new, status: :unprocessable_entity
    end
  end

  # GET /posts/:id/edit
  # 投稿編集フォームを表示（@postは:set_postで設定済み）
  def edit
  end

  # PATCH/PUT /posts/:id
  # 投稿を更新
  def update
    if @post.update(post_params)
      # 更新成功時は投稿詳細ページにリダイレクト
      redirect_to @post, notice: '投稿が更新されました。'
    else
      # バリデーションエラー時は編集フォームを再表示
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  # 投稿を削除
  def destroy
    @post.destroy
    # 削除後は投稿一覧ページにリダイレクト
    redirect_to posts_url, notice: '投稿が削除されました。'
  end

  private

  # Strong Parameters
  # 安全な属性のみを許可
  def post_params
    # titleとcontentのみ更新を許可
    params.require(:post).permit(:title, :content, :category)
  end

  # 指定されたIDの投稿を@postインスタンス変数に設定
  def set_post
    @post = Post.find(params[:id])
  end

  # アクセス制御
  # 投稿者本人以外のアクセスを制限
  def ensure_correct_user
    unless @post.user == current_user
      # 投稿者本人でない場合は投稿一覧にリダイレクト
      redirect_to posts_url, alert: 'この操作は許可されていません。'
    end
  end
end
