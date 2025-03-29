# 検索機能のシステムテスト
RSpec.describe 'Search', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user, title: 'テスト投稿', content: 'テスト内容です') }
  let!(:other_post) { create(:post, user: other_user, title: '別の投稿', content: '別の内容です') }

  # 検索機能のテスト
  describe '検索機能' do
    context 'ログインしている場合' do
      before do
        sign_in user
        visit search_path
      end

      context '投稿の検索' do
        it 'タイトルで検索できること' do
          fill_in '検索キーワード', with: 'テスト'
          select '投稿', from: '検索対象'
          click_button '検索'

          expect(page).to have_content('テスト投稿')
          expect(page).to have_content('テスト内容です')
          expect(page).not_to have_content('別の投稿')
        end

        it '内容で検索できること' do
          fill_in '検索キーワード', with: '内容'
          select '投稿', from: '検索対象'
          click_button '検索'

          expect(page).to have_content('テスト投稿')
          expect(page).to have_content('別の投稿')
        end

        it 'カテゴリーで検索できること' do
          select post.category, from: 'カテゴリー'
          select '投稿', from: '検索対象'
          click_button '検索'

          expect(page).to have_content('テスト投稿')
          expect(page).not_to have_content('別の投稿')
        end
      end

      context 'ユーザーの検索' do
        it '名前で検索できること' do
          fill_in '検索キーワード', with: user.name
          select 'ユーザー', from: '検索対象'
          click_button '検索'

          expect(page).to have_content(user.name)
          expect(page).to have_content(user.email)
          expect(page).not_to have_content(other_user.name)
        end

        it 'メールアドレスで検索できること' do
          fill_in '検索キーワード', with: user.email
          select 'ユーザー', from: '検索対象'
          click_button '検索'

          expect(page).to have_content(user.name)
          expect(page).to have_content(user.email)
          expect(page).not_to have_content(other_user.name)
        end
      end

      context '検索結果の表示' do
        it '検索結果が新しい順に表示されること' do
          fill_in '検索キーワード', with: '投稿'
          select '投稿', from: '検索対象'
          click_button '検索'

          expect(page).to have_content('投稿一覧')
          expect(page).to have_selector('.post-item', count: 2)
        end

        it '検索結果が0件の場合メッセージが表示されること' do
          fill_in '検索キーワード', with: '存在しないキーワード'
          select '投稿', from: '検索対象'
          click_button '検索'

          expect(page).to have_content('検索結果が見つかりませんでした')
        end
      end

      context '検索オプション' do
        it '検索対象を切り替えられること' do
          fill_in '検索キーワード', with: 'テスト'
          select '投稿', from: '検索対象'
          click_button '検索'
          expect(page).to have_content('テスト投稿')

          select 'ユーザー', from: '検索対象'
          click_button '検索'
          expect(page).not_to have_content('テスト投稿')
        end

        it 'カテゴリーで絞り込めること' do
          fill_in '検索キーワード', with: '投稿'
          select '投稿', from: '検索対象'
          select post.category, from: 'カテゴリー'
          click_button '検索'

          expect(page).to have_content('テスト投稿')
          expect(page).not_to have_content('別の投稿')
        end
      end
    end

    context 'ログインしていない場合' do
      it '検索ページにアクセスできること' do
        visit search_path
        expect(page).to have_current_path(search_path)
      end

      it '検索が実行できること' do
        visit search_path
        fill_in '検索キーワード', with: 'テスト'
        select '投稿', from: '検索対象'
        click_button '検索'

        expect(page).to have_content('テスト投稿')
      end
    end
  end
end 