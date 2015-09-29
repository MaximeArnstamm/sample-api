require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :request do

  describe 'events#index' do
    before {
      @user = User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')
      @user.reload

      @wrong_user = User.create(email: 'toto@toto.fr', password: '12345678', password_confirmation: '12345678')
      @wrong_user.reload
    }

    it 'should 401 if bad credentials' do
      # Given the user

      # When
      get_json "/api/v1/users/#{@user.id}/events", {}, 'toto', 'toto'

      # Then
      expect_status 401
    end

    it 'should 403 if not authorized' do
      # Given the user

      # When
      get_json "/api/v1/users/#{@user.id}/events", {}, @wrong_user.email, @wrong_user.authentication_token

      # Then
      expect_status 403
      expect_json({ message: 'Not authorized'})
    end

    it 'should get all events for user' do
      # Given
      @user.events << Event.new(name: 'Ev 1', city: 'Paris')
      @user.events << Event.new(name: 'Ev 2', city: 'London')
      @user.save
      @user.reload

      # When
      get_json "/api/v1/users/#{@user.id}/events", {}, @user.email, @user.authentication_token

      # Then
      expect_status 200
      json = JSON.parse(response.body)
      expect(json['events'].count).to eq 2
    end
  end

  describe 'events#show' do
    before {
      @user = User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')
      @user.reload

      @event = Event.create(name: 'ev', city: 'London', user: @user)
      @event.reload

      @wrong_user = User.create(email: 'toto@toto.fr', password: '12345678', password_confirmation: '12345678')
      @wrong_user.reload

      @wrong_event = Event.create(name: 'toto', city: 'Paris', user: @wrong_user)
      @wrong_event.reload
    }

    it 'should 401 if bad credentials' do
      # Given the user

      # When
      get_json "/api/v1/users/#{@user.id}/events/#{@event.id}", {}, 'toto', 'toto'

      # Then
      expect_status 401
    end

    it 'should 403 if not authorized' do
      # Given the user

      # When
      get_json "/api/v1/users/#{@user.id}/events/#{@event.id}", {}, @wrong_user.email, @wrong_user.authentication_token

      # Then
      expect_status 403
      expect_json({ message: 'Not authorized'})
    end

    it 'should show the event' do
      # Given

      # When
      get_json "/api/v1/users/#{@user.id}/events/#{@event.id}", {}, @user.email, @user.authentication_token

      # Then
      expect_status 200
      expect_json(
        'event',
        name: 'ev',
        city: 'London'
      )
    end
  end

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
        city: 'Paris'
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
        city: 'Paris'
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
        city: 'Paris'
      },
      @user.email,
      @user.authentication_token

      # Then
      expect_status 201
      expect(Event.count).to eq 1
      event = Event.last
      expect(event.name).to eq 'test'
      expect(event.city).to eq 'Paris'
      expect(event.user).to eq @user
    end
  end

end
