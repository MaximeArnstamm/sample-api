require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do

  describe 'login' do
    it 'should verify my credential and send me the token' do
      # Given
      me = User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')
      current_token = me.reload.authentication_token

      # When
      post_json '/api/v1/login',
      {
        email: 'm@m.fr',
        password: '12345678'
      }

      # Then
      expect_status 200
      expect_json({ id: me.id, email: me.email, token: current_token})
    end

    it 'should verify my credential and reject me if they are bad' do
      # Given
      User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')

      # When
      post_json '/api/v1/login',
      {
        email: 'toto',
        password: 'toto'
      }

      # Then
      expect_status 401
      expect_json({ message: 'Bad credentials'})
    end
  end

  describe 'logout' do
    it 'should 401 if bad credentials' do
      # Given
      me = User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')
      current_token = me.reload.authentication_token

      # When
      delete_json '/api/v1/logout', {}, 'toto', 'toto'

      # Then
      expect_status 401
      expect(me.reload.authentication_token).to eq current_token
    end

    it 'should log me out and reset the token' do
      # Given
      me = User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')
      current_token = me.reload.authentication_token

      # When
      delete_json '/api/v1/logout', {}, me.email, current_token

      # Then
      expect_status 200
      expect_json({ message: 'Logged out successfully.'})
      expect(me.reload.authentication_token).not_to eq current_token
    end
  end

end
