# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# facebook api setting
case Rails.env
  when 'production'
    Rails.application.config.facebook_app_secret = ENV['FB_APP_SECRET']
  when 'staging'
    Rails.application.config.facebook_app_secret = ENV['FB_APP_SECRET']
  when 'development'
    Rails.application.config.facebook_app_secret = '595c012dd83b4bee4fb0068d388ee8d5'
  end
