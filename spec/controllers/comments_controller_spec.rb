# CommentsControllerのテスト
RSpec.describe CommentsController, type: :controller do
  # 認証・認可のテスト
  describe '認証・認可' do
    context '未ログインユーザーの場合' do
      let(:post) { create(:post) }

      it 'コメントを作成できないこと' do
        post :create, params: { post_id: post.id, comment: attributes_for(:comment) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'コメントを編集できないこと' do
        comment = create(:comment)
        patch :update, params: { post_id: comment.post_id, id: comment.id, comment: attributes_for(:comment) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'コメントを削除できないこと' do
        comment = create(:comment)
        delete :destroy, params: { post_id: comment.post_id, id: comment.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログインユーザーの場合' do
      before do
        sign_in_test_user
        @post = create(:post)
      end

      it 'コメントを作成できること' do
        expect {
          post :create, params: { post_id: @post.id, comment: attributes_for(:comment) }
        }.to change(Comment, :count).by(1)
      end

      context '自分のコメントの場合' do
        let(:comment) { create(:comment, user: @user, post: @post) }

        it 'コメントを編集できること' do
          patch :update, params: { post_id: @post.id, id: comment.id, comment: attributes_for(:comment, content: '更新後のコメント') }
          expect(comment.reload.content).to eq('更新後のコメント')
        end

        it 'コメントを削除できること' do
          expect {
            delete :destroy, params: { post_id: @post.id, id: comment.id }
          }.to change(Comment, :count).by(-1)
        end
      end

      context '他のユーザーのコメントの場合' do
        let(:other_user) { create(:user) }
        let(:comment) { create(:comment, user: other_user, post: @post) }

        it 'コメントを編集できないこと' do
          patch :update, params: { post_id: @post.id, id: comment.id, comment: attributes_for(:comment) }
          expect(response).to redirect_to(post_path(@post))
        end

        it 'コメントを削除できないこと' do
          expect {
            delete :destroy, params: { post_id: @post.id, id: comment.id }
          }.not_to change(Comment, :count)
          expect(response).to redirect_to(post_path(@post))
        end
      end
    end
  end

  # アクションのテスト
  describe 'POST #create' do
    before do
      sign_in_test_user
      @post = create(:post)
    end

    context '有効なパラメータの場合' do
      let(:valid_attributes) { attributes_for(:comment, content: 'テストコメント') }

      it '新しいコメントを作成すること' do
        expect {
          post :create, params: { post_id: @post.id, comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it '作成したコメントが正しい属性を持つこと' do
        post :create, params: { post_id: @post.id, comment: valid_attributes }
        expect(Comment.last.content).to eq('テストコメント')
        expect(Comment.last.user).to eq(@user)
        expect(Comment.last.post).to eq(@post)
      end

      it '投稿の詳細ページにリダイレクトすること' do
        post :create, params: { post_id: @post.id, comment: valid_attributes }
        expect(response).to redirect_to(post_path(@post))
      end

      it '成功メッセージを表示すること' do
        post :create, params: { post_id: @post.id, comment: valid_attributes }
        expect(flash[:notice]).to eq('コメントを投稿しました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_attributes) { attributes_for(:comment, content: nil) }

      it '新しいコメントを作成しないこと' do
        expect {
          post :create, params: { post_id: @post.id, comment: invalid_attributes }
        }.not_to change(Comment, :count)
      end

      it '投稿の詳細ページにリダイレクトすること' do
        post :create, params: { post_id: @post.id, comment: invalid_attributes }
        expect(response).to redirect_to(post_path(@post))
      end

      it 'エラーメッセージを表示すること' do
        post :create, params: { post_id: @post.id, comment: invalid_attributes }
        expect(flash[:alert]).to eq('コメントの投稿に失敗しました')
      end
    end
  end

  describe 'PATCH #update' do
    before do
      sign_in_test_user
      @post = create(:post)
      @comment = create(:comment, user: @user, post: @post)
    end

    context '有効なパラメータの場合' do
      let(:new_attributes) { attributes_for(:comment, content: '更新後のコメント') }

      it 'コメントを更新すること' do
        patch :update, params: { post_id: @post.id, id: @comment.id, comment: new_attributes }
        @comment.reload
        expect(@comment.content).to eq('更新後のコメント')
      end

      it '投稿の詳細ページにリダイレクトすること' do
        patch :update, params: { post_id: @post.id, id: @comment.id, comment: new_attributes }
        expect(response).to redirect_to(post_path(@post))
      end

      it '成功メッセージを表示すること' do
        patch :update, params: { post_id: @post.id, id: @comment.id, comment: new_attributes }
        expect(flash[:notice]).to eq('コメントを更新しました')
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_attributes) { attributes_for(:comment, content: nil) }

      it 'コメントを更新しないこと' do
        expect {
          patch :update, params: { post_id: @post.id, id: @comment.id, comment: invalid_attributes }
        }.not_to change { @comment.reload.content }
      end

      it '投稿の詳細ページにリダイレクトすること' do
        patch :update, params: { post_id: @post.id, id: @comment.id, comment: invalid_attributes }
        expect(response).to redirect_to(post_path(@post))
      end

      it 'エラーメッセージを表示すること' do
        patch :update, params: { post_id: @post.id, id: @comment.id, comment: invalid_attributes }
        expect(flash[:alert]).to eq('コメントの更新に失敗しました')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in_test_user
      @post = create(:post)
      @comment = create(:comment, user: @user, post: @post)
    end

    it 'コメントを削除すること' do
      expect {
        delete :destroy, params: { post_id: @post.id, id: @comment.id }
      }.to change(Comment, :count).by(-1)
    end

    it '投稿の詳細ページにリダイレクトすること' do
      delete :destroy, params: { post_id: @post.id, id: @comment.id }
      expect(response).to redirect_to(post_path(@post))
    end

    it '成功メッセージを表示すること' do
      delete :destroy, params: { post_id: @post.id, id: @comment.id }
      expect(flash[:notice]).to eq('コメントを削除しました')
    end
  end
end 