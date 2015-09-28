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

    it 'should 403 if not authorized' do
      # Given the user

      # When
      post_json "/api/v1/users/#{@user.id}/events",
      {
        name: 'test',
        date: Date.today
      },
      @wrong_user.email,
      @wrong_user.authentication_token

      # Then
      expect_status 403
      expect_json({ message: 'Not authorized'})
    end

    it 'should create an event' do
      # Given

      # When
      post_json "/api/v1/users/#{@user.id}/events",
      {
        name: 'test',
        date: Date.today
      },
      @user.email,
      @user.authentication_token

      # Then
      expect_status 201
      expect(Event.count).to eq 1
      event = Event.last
      expect(event.name).to eq 'test'
      expect(event.date).to eq Date.today
      expect(event.user).to eq @user
    end
  end

end
