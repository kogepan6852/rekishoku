# This file is used by Rack-based servers to start the application.

if ENV['RACK_ENV'] == 'production'
  use Rack::Rewrite do
    r301 %r{.*}, 'https://www.rekishoku.jp$&', :if => Proc.new {|rack_env|
      rack_env['SERVER_NAME'] != 'www.rekishoku.jp'
    }
  end
end

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
