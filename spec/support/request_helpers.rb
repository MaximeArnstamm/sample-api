module RequestHelpers
  def get_json(path, params = {}, email = '', token = '')
    get path, params.to_json, env_with_auth(email, token)
  end

  def post_json(path, params = {}, email = '', token = '')
    post path, params.to_json, env_with_auth(email, token)
  end

  def put_json(path, params = {}, email = '', token = '')
    put path, params.to_json, env_with_auth(email, token)
  end

  def patch_json(path, params = {}, email = '', token = '')
    patch path, params.to_json, env_with_auth(email, token)
  end

  def delete_json(path, params = {}, email = '', token = '')
    delete path, params.to_json, env_with_auth(email, token)
  end

  def env_with_auth(email, token)
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'x-user-email' => email,
      'x-user-token' => token
    }
  end

end
