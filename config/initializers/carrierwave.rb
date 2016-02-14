CarrierWave.configure do |config|
  case Rails.env
    when 'production'
      config.fog_credentials = {
          :provider               => 'AWS',
          :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
          :aws_secret_access_key  => ENV['AWS_SECRET_KEY'],
          :region                 => 'ap-northeast-1',
          :path_style             => true,
      }
      config.fog_public     = true
      config.fog_attributes = {'Cache-Control' => 'public, max-age=86400'}
      config.fog_directory  = 'rekishoku'
      config.asset_host     = 'https://s3-ap-northeast-1.amazonaws.com/rekishoku'
    when 'staging'
      config.fog_credentials = {
          :provider               => 'AWS',
          :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
          :aws_secret_access_key  => ENV['AWS_SECRET_KEY'],
          :region                 => 'ap-northeast-1',
          :path_style             => true,
      }
      config.fog_public     = true
      config.fog_attributes = {'Cache-Control' => 'public, max-age=86400'}
      config.fog_directory  = 'rekishoku-stg'
      config.asset_host     = 'https://s3-ap-northeast-1.amazonaws.com/rekishoku-stg'
    when 'development'
      config.asset_host = 'http://localhost:3000'
  end
end
