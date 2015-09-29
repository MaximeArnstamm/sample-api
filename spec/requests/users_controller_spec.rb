require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do

  describe 'user#show' do
    before {
      @user = User.create(
        email: 'm@m.fr',
        password: '12345678',
        password_confirmation: '12345678',
        first_name: 'Joe',
        last_name: 'Joe'
      )
      @user.reload

      @wrong_user = User.create(email: 'toto@toto.fr', password: '12345678', password_confirmation: '12345678')
      @wrong_user.reload
    }

    it 'should 401 if bad credentials' do
      # Given the user and his token

      # When
      get_json "/api/v1/users/#{@user.id}", {}, 'toto', 'toto'

      # Then
      expect_status 401
    end

    it 'should 403 if :id != current_user.id' do
      # Given the user and his token

      # When
      get_json "/api/v1/users/#{@user.id}", {}, @wrong_user.email, @wrong_user.authentication_token

      # Then
      expect_status 403
      expect_json({ message: 'Not authorized'})
    end

    it 'should show if :id == current_user.id' do
      # Given the user and his token

      # When
      get_json "/api/v1/users/#{@user.id}", {}, @user.email, @user.authentication_token

      # Then
      expect_status 200
      expect_json(
        'user',
        id: @user.id,
        email: 'm@m.fr',
        first_name: 'Joe',
        last_name: 'Joe',
      )

    end
  end

  describe 'user#update' do
    before {
      @user = User.create(
        email: 'm@m.fr',
        password: '12345678',
        password_confirmation: '12345678',
        first_name: '',
        last_name: '',
        )
      @user.reload

      @wrong_user = User.create(email: 'toto@toto.fr', password: '12345678', password_confirmation: '12345678')
      @wrong_user.reload
    }

    it 'should 401 if bad credentials' do
      # Given the user and his token

      # When
      put_json "/api/v1/users/#{@user.id}",
      {
        first_name: 'Joe',
        last_name: 'Joe'
      }, 'toto', 'toto'

      # Then
      expect_status 401
    end

    it 'should 403 if :id != current_user.id' do
      # Given the user and his token

      # When
      put_json "/api/v1/users/#{@user.id}",
      {
        first_name: 'Joe',
        last_name: 'Joe'
      }, @wrong_user.email, @wrong_user.authentication_token

      # Then
      expect_status 403
      expect_json({ message: 'Not authorized'})
    end

    it 'should update the user' do
      # Given the user and his token

      # When
      put_json "/api/v1/users/#{@user.id}",
      {
        first_name: 'Joe',
        last_name: 'Joe',
      }, @user.email, @user.authentication_token

      # Then
      expect_status 201

      @user.reload
      expect(@user.first_name).to eq('Joe')
      expect(@user.last_name).to eq('Joe')
    end

    it 'should not touch the fields not present or not permitted' do
      # Given the user and his token
      @user.first_name = 'to'
      @user.last_name = 'toto'
      @user.save!

      # When
      put_json "/api/v1/users/#{@user.id}",
      {
        first_name: 'Joe',
        email: 'll@ll.fr'
      }, @user.email, @user.authentication_token

      # Then
      expect_status 201
      @user.reload
      expect(@user.first_name).to eq('Joe') # updated
      expect(@user.last_name).to eq('toto') # not updated
      expect(@user.email).to eq('m@m.fr') # not permitted to update
    end

    it 'should permit to update the password' do
      # Given the user and his token
      old_password = @user.encrypted_password

      # When
      put_json "/api/v1/users/#{@user.id}",
      {
        password: '87654321'
      }, @user.email, @user.authentication_token

      # Then
      expect_status 201

      @user.reload
      expect(@user.encrypted_password).not_to eq(old_password)
    end
  end

end
