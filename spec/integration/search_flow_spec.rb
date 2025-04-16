require 'rails_helper'

RSpec.describe 'Search Integration Flow', type: :system do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let!(:post) { create(:post, user: user_a, title: '検索テスト投稿', content: '検索テスト用の投稿内容です') }

  describe '投稿検索から投稿詳細表示までのフロー' do
    before do
      sign_in user_b
      visit root_path
    end

    it '投稿を検索し、詳細を表示する' do
      # 検索ページへ移動
      click_link '検索'
      expect(page).to have_content('検索')

      # 投稿を検索
      fill_in '検索キーワード', with: '検索テスト'
      click_button '検索'

      # 検索結果の表示確認
      expect(page).to have_content('検索テスト投稿')
      expect(page).to have_content(user_a.name)

      # 投稿詳細を表示
      click_link '検索テスト投稿'
      expect(page).to have_content('検索テスト投稿')
      expect(page).to have_content('検索テスト用の投稿内容です')
      expect(page).to have_content(user_a.name)

      # 投稿者プロフィールを表示
      click_link user_a.name
      expect(page).to have_content(user_a.name)
      expect(page).to have_content('検索テスト投稿')
    end
  end

  describe 'ユーザー検索からプロフィール表示までのフロー' do
    before do
      sign_in user_b
      visit root_path
    end

    it 'ユーザーを検索し、プロフィールを表示する' do
      # 検索ページへ移動
      click_link '検索'
      expect(page).to have_content('検索')

      # ユーザーを検索
      fill_in '検索キーワード', with: user_a.name
      select 'ユーザー', from: '検索対象'
      click_button '検索'

      # 検索結果の表示確認
      expect(page).to have_content(user_a.name)
      expect(page).to have_content(user_a.email)

      # プロフィールを表示
      click_link user_a.name
      expect(page).to have_content(user_a.name)
      expect(page).to have_content('検索テスト投稿')

      # 投稿一覧を表示
      click_link '投稿一覧'
      expect(page).to have_content('検索テスト投稿')
      expect(page).to have_content('検索テスト用の投稿内容です')
    end
  end

  describe '検索結果からの投稿作成・コメント投稿のフロー' do
    before do
      sign_in user_b
      visit root_path
    end

    it '検索結果から投稿を作成し、コメントを投稿する' do
      # 検索ページへ移動
      click_link '検索'
      expect(page).to have_content('検索')

      # 投稿を検索
      fill_in '検索キーワード', with: '検索テスト'
      click_button '検索'

      # 検索結果から投稿詳細を表示
      click_link '検索テスト投稿'
      expect(page).to have_content('検索テスト投稿')

      # コメントを投稿
      fill_in 'コメント', with: '検索結果からのコメント'
      click_button 'コメントする'
      expect(page).to have_content('検索結果からのコメント')
      expect(page).to have_content(user_b.name)

      # 投稿者プロフィールを表示
      click_link user_a.name
      expect(page).to have_content(user_a.name)
      expect(page).to have_content('検索テスト投稿')

      # コメント一覧を表示
      click_link 'コメント一覧'
      expect(page).to have_content('検索結果からのコメント')
      expect(page).to have_content(user_b.name)
    end
  end
end
