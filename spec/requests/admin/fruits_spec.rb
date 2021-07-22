require 'rails_helper'

RSpec.describe 'Admin::Fruits', type: :request do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
  end

  describe '#create' do
    let(:name) { 'りんご' }
    let(:color) { '#000000' }
    let(:params) { { fruit: { name: name, color: color } } }

    context '登録に成功した場合' do
      before { post admin_fruits_path, params: params } # pathは複数形

      it 'Fruitが登録されていること' do
        fruit = Fruit.find_by(name: name)
        expect(fruit).not_to eq nil
        expect(fruit.color).to eq nil
        expect(fruit.start_of_sales).to eq nil
      end

      it '作成したFruitの詳細画面へリダイレクトしていること' do
        expect(response).to have_http_status '302'
        fruit = Fruit.find_by(name: name)
        expect(response).to redirect_to(admin_fruit_path(fruit)) # pathは単数形
      end

      it 'リダイレクト先の画面にflashが表示されていること' do
        follow_redirect!

        expect(response.body).to include 'success'
      end
    end

    context 'nameが未入力でエラーの場合' do
      # describeで定義した name を上書き
      let(:name) { nil }

      before { post admin_fruits_path, params: params }

      it 'Fruitが登録されていないこと' do
        expect(Fruit.find_by(name: name)).to eq nil
      end

      it '作成したFruitの登録画面のままであること' do
        expect(response).to have_http_status '200'
      end

      it 'エラーが表示されていること' do
        expect(response.body).to include 'be blank'
      end

      it 'エラーのflashが表示されていること' do
        expect(response.body).to include 'wrong!'
      end
    end

    context 'nameを含むリクエストを送ったものの、APIでエラーになった場合' do
      before do
        expect_any_instance_of(Admin::FruitsController).to receive(:call_api_with_params)
                                                             .with(name)
                                                             .once
                                                             .and_raise(StandardError)
        post admin_fruits_path, params: params
      end

      it 'Fruitが登録されていないこと' do
        expect(Fruit.find_by(name: name)).to eq nil
      end

      it '作成したFruitの登録画面のままであること' do
        expect(response).to have_http_status '200'
      end

      it 'エラーのflashが表示されていること' do
        expect(response.body).to include 'exception!'
      end
    end
  end
end
