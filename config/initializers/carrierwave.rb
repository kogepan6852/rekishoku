CarrierWave.configure do |config|
  case Rails.env
    when 'production'
      # config.fog_directory = 'dev.example.com'
      # config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/dev.example.com'
    when 'staging'
      # config.fog_directory = 'stg.example.com'
      # config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/stg.example.com'
    when 'development'
      config.asset_host = 'http://localhost:3000'
  end
end
