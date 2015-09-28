require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :request do

  describe 'events#create' do
    before {
      @user = User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')
      @user.reload

      @wrong_user = User.create(email: 'toto@toto.fr', password: '12345678', password_confirmation: '12345678')
      @wrong_user.reload
    }

    it 'should 401 if bad credentials' do
      # Given the user and his bar

      # When
      post "/api/v1/users/#{@user.id}/events",
      {
        name: 'test',
        date: Date.today
      }.to_json,
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'x-user-email' => 'toto',
        'x-user-token' => 'toto',
      }

      # Then
      expect(response.response_code).to eq 401
      #expect_status 401
    end
  end

end
