requier 'rails_helper'

RSpec.describe "Access to statec_pages", type: :request do
  context 'GET #home' do
    before { visit root_path }
    it 'responds sccessfully' do
      expect(response).to have_http_status 200
    end
    it "has title 'Ruby on Rails Tutorial Sample App'" do
      expect(response.body).to include
    end
  end
  
end
