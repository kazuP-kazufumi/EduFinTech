# 投稿に関する機能を提供するコントローラー
# ApplicationControllerを継承して基本的なコントローラー機能を利用
# このコントローラーは投稿(Post)の作成・表示・編集・削除などのCRUD操作を担当
class PostsController < ApplicationController
  # Deviseのメソッドを使用してユーザー認証を要求
  # すべてのアクションで認証が必要
  before_action :authenticate_user!

  # 各アクションの前に実行される共通処理を定義
  # set_post: 指定されたIDの投稿を@postに設定
  # show, edit, update, destroyアクションの前に実行される
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]

  # ensure_correct_user: 投稿者本人かどうかを確認
  # edit, update, destroyアクションの前に実行される
  # 投稿者本人以外による編集・削除を防止
  before_action :ensure_correct_user, only: [ :edit, :update, :destroy ]

  # GET /posts
  # 投稿一覧を表示するアクション
  # 検索、フィルタリング、ソート、ページネーション機能を提供
  def index
    # 全ての投稿を取得
    @posts = Post.all

    # 検索機能の実装
    # タイトルまたは本文に検索キーワードが含まれる投稿を抽出
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @posts = @posts.where("title LIKE ? OR content LIKE ?", search_term, search_term)
    end

    # カテゴリーによるフィルタリング機能
    # 特定のカテゴリーの投稿のみを表示
    # 'all'が選択された場合は全カテゴリーを表示
    if params[:category].present? && params[:category] != "all"
      @posts = @posts.where(category: params[:category])
    end

    # ソート機能の実装
    # newest: 最新の投稿順
    # oldest: 古い投稿順
    # デフォルトは最新順
    case params[:sort]
    when "newest"
      @posts = @posts.order(created_at: :desc)
    when "oldest"
      @posts = @posts.order(created_at: :asc)
    else
      @posts = @posts.order(created_at: :desc)
    end

    # Kaminariによるページネーション
    # 1ページあたりの表示件数はkaminari_config.rbで設定
    @posts = @posts.page(params[:page])

    # カテゴリー一覧をビューで使用するために設定
    @categories = Post::CATEGORIES
  end

  # GET /posts/:id
  # 個別の投稿を表示するアクション
  # @postは:set_postで設定済み
  def show
  end

  # GET /posts/new
  # 新規投稿フォームを表示するアクション
  def new
    # ログイン中のユーザーに紐づいた新規投稿インスタンスを作成
    @post = current_user.posts.build
  end

  # POST /posts
  # 新規投稿を作成するアクション
  def create
    # current_user（ログイン中のユーザー）に紐づいた投稿を作成
    # post_paramsメソッドで安全な属性のみを使用
    @post = current_user.posts.build(post_params)
    if @post.save
      # 保存成功時は投稿詳細ページにリダイレクト
      # フラッシュメッセージで成功を通知
      redirect_to @post, notice: "投稿を作成しました"
    else
      # バリデーションエラー時は新規投稿フォームを再表示
      # エラーメッセージも表示される
      flash.now[:alert] = "投稿の作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  # GET /posts/:id/edit
  # 投稿編集フォームを表示するアクション
  # @postは:set_postで設定済み
  def edit
  end

  # PATCH/PUT /posts/:id
  # 投稿を更新するアクション
  def update
    # post_paramsメソッドで安全な属性のみを使用して更新
    if @post.update(post_params)
      # 更新成功時は投稿詳細ページにリダイレクト
      # フラッシュメッセージで成功を通知
      redirect_to @post, notice: "投稿を更新しました"
    else
      # バリデーションエラー時は編集フォームを再表示
      # エラーメッセージも表示される
      flash.now[:alert] = "投稿の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  # 投稿を削除するアクション
  def destroy
    # 投稿を削除
    @post.destroy
    # 削除後は投稿一覧ページにリダイレクト
    # フラッシュメッセージで成功を通知
    redirect_to posts_url, notice: "投稿を削除しました"
  end

  private

  # Strong Parameters
  # セキュリティのため、許可された属性のみを更新可能にする
  def post_params
    # title, content, categoryのみ更新を許可
    # それ以外の属性は無視される
    params.require(:post).permit(:title, :content, :category)
  end

  # 指定されたIDの投稿を@postインスタンス変数に設定
  # 投稿が見つからない場合は404エラーを発生
  def set_post
    @post = Post.find(params[:id])
  end

  # アクセス制御メソッド
  # 投稿者本人以外のアクセスを制限
  def ensure_correct_user
    # 現在のユーザーが投稿者と一致するか確認
    unless @post.user == current_user
      # 投稿者本人でない場合は投稿一覧にリダイレクト
      # フラッシュメッセージでエラーを通知
      redirect_to posts_url, alert: "この操作は許可されていません。"
    end
  end
end
