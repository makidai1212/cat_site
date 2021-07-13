require 'rails_helper'

# describe 'クラス名' do
end
RSpec.describe 'Home' do
  specify '画面の表示' do
    # get root_pathみたいなもん
    visit root_path
    # expect は assert みたいなもん。
    # ( )の中身を入れることで to 以下の動作となることを確認
    expect(page).to have_css('h1', text: 'Welcome')
  end
  specify 'タイトルの表示' do
    visit root_path
    expect(page).to have_title 'Neko Neko'
  end
end

RSpec.describe 'Help' do
  specify '画面の表示' do
    visit about_path
    expect(page).to have_css('h1', text: 'Neko')
  end
  specify 'タイトルの表示' do
    visit about_path
    expect(page).to have_title 'Neko Nekoとは'
  end
end

# リンクのテストを上と同じように書いていくとこうなる
RSpec.describe 'サイトのリンクのテスト' do
  specify 'access to root_path' do
  visit root_path
    expect(page).to have_link nil, href: root_path, count: 2
  end
  specify 'access to about_path' do
  visit about_path
    expect(page).to have_link 'このサイトについて', href: about_path
  end
end

# describe 'テストの対象'
RSpec.describe 'サイトのリンクのテスト' do
  # contxt '特定の条件'
  context 'root_pathにアクセス' do
    # 共通の前提条件を決める
    before { visit root_path }
      # 「何のテストするよ」のやつ。日本語なら example。英語なら it。を使用する。
      example 'root_pathへのリンクはあるか' do
      expect(page).to have_link nil, href: root_path, count: 2
      end
      example 'about_pathへのリンクはあるか' do
      expect(page).to have_link 'このサイトについて', href: about_path
      end
  end
end

# さらに短縮するとこうなる
RSpec.describe 'サイトのリンクのテスト' do
  # contxt '特定の条件'
  context 'root_pathにアクセス' do
    before { visit root_path }
    # expectで共通する部分はsubjectで取り出せるらしい
    subject { page }
      example 'リンクのテスト' do
      # ()の中身はsubjectに引越し。to以下の動作が予測されるということ
      is_expected.to have_link nil, href: root_path, count: 2
      is_expected.to have_link 'このサイトについて', href: about_path
      end
  end
end

