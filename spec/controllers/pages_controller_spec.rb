require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #acceuil" do
    it "returns http success" do
      get :acceuil
      expect(response).to have_http_status(:success)
    end
  end

end
