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
      # Given the user

      # When
      post_json "/api/v1/users/#{@user.id}/events",
      {
        name: 'test',
        date: Date.today
      },
      'toto',
      'toto'

      # Then
      expect_status 401
    end
  end

end
