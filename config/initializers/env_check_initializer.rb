mandatory_env_vars = [
  'RAILS_MASTER_KEY',
  'DATABASE_USERNAME',
  'DATABASE_PASSWORD',
  'DATABASE_HOST',
  'DATABASE_PORT',
  'DATABASE_NAME',
  'HEROKU_APP_NAME',
  'DEVISE_JWT_SECRET_KEY',
]
mandatory_env_vars.each do |env_var|
  ENV.fetch(env_var)

rescue KeyError => e
  raise "Environment variable #{env_var} not configured =z"
end
