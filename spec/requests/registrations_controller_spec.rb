require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :request do

  describe 'register#create' do
    it 'should create a new user' do
      # Given there are no users

      # When
      post_json '/api/v1/register',
      {
        email: 'm@m.fr',
        password: '12345678',
        password_confirmation: '12345678'
      }

      # Then
      expect_status 201
      user = User.find_by_email('m@m.fr')
      expect(user).not_to be_nil
      expect_json({ id: user.id, email: user.email, token: user.authentication_token })
    end

    it 'should return code 422 if there is an email validation problem' do
      # Given
      User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')

      # When
      post_json '/api/v1/register',
      {
        email: 'm@m.fr',
        password: '12345678',
        password_confirmation: '12345678'
      }

      # Then
      expect_status 422
      expect_json({ message: 'Email has already been taken' })
    end

    it 'should return code 422 if there is a password validation problem' do
      # Given there are no users

      # When
      post_json '/api/v1/register',
      {
        email: 'm@m.fr',
        password: '12345678',
        password_confirmation: 'toto'
      }

      # Then
      expect_status 422
      expect_json({ message: 'Password confirmation doesn\'t match Password' })
    end
  end

  describe 'register#destroy' do
    it 'should 401 if bad credentials' do
      # Given
      user = User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')
      user.reload

      # When
      delete_json '/api/v1/delete_account', {}, 'toto', 'toto'

      # Then
      expect_status 401
      expect(User.find_by_email('m@m.fr')).not_to be_nil
    end

    it 'should delete the user' do
      # Given
      user = User.create(email: 'm@m.fr', password: '12345678', password_confirmation: '12345678')
      user.reload

      # When
      delete_json '/api/v1/delete_account', {}, user.email, user.authentication_token

      # Then
      expect_status 200
      expect(User.find_by_email('m@m.fr')).to be_nil
    end
  end
end
