# Set the host name for URL creation
case Rails.env
  when 'production'
    SitemapGenerator::Sitemap.default_host = "https://www.rekishoku.jp"
    SitemapGenerator::Sitemap.sitemaps_host = 'https://s3-ap-northeast-1.amazonaws.com/rekishoku/'
  when 'staging'
    SitemapGenerator::Sitemap.default_host = "http://www.historipfood.com"
    SitemapGenerator::Sitemap.sitemaps_host = 'https://s3-ap-northeast-1.amazonaws.com/rekishoku-stg/'
    SitemapGenerator::Sitemap.search_engines = {}
  when 'development'
    SitemapGenerator::Sitemap.default_host = "http://localhost:3000"
    SitemapGenerator::Sitemap.search_engines = {}
end
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add '/app/magazine', :changefreq => 'daily', :priority => 0.9
  add '/app/shops', :changefreq => 'daily', :priority => 0.8
  add '/app/features', :changefreq => 'daily', :priority => 0.8
  add '/about', :changefreq => 'yearly', :priority => 0.5
  Post.find_each do |post|
    if post.status == 1
      add '/app/post/' + post.id.to_s, :lastmod => post.updated_at, :changefreq => 'weekly'
    end
  end
  Shop.find_each do |shop|
    add '/app/shop/' + shop.id.to_s, :lastmod => shop.updated_at, :changefreq => 'weekly'
  end
  Feature.find_each do |feature|
    if feature.status == 1
      add '/app/feature/' + feature.id.to_s, :lastmod => feature.updated_at, :changefreq => 'weekly'
    end
  end
  User.find_each do |user|
    if user.role == 1 || user.role == 2
      add '/app/writer/' + user.id.to_s, :lastmod => user.updated_at, :changefreq => 'weekly'
    end
  end

  # SEO対応
  Period.find_each do |period|
    add '/app/magazine?period=' + period.id.to_s, :changefreq => 'weekly'
    add '/app/shops?period=' + period.id.to_s, :changefreq => 'weekly'
    add '/app/features?period=' + period.id.to_s, :changefreq => 'weekly'
  end

  Person.find_each do |person|
    add '/app/shops?person=' + person.id.to_s, :changefreq => 'weekly'
  end

  add '/app/shops?province=東京都', :changefreq => 'weekly'
  add '/app/shops?province=京都府', :changefreq => 'weekly'
  add '/app/shops?province=神奈川県', :changefreq => 'weekly'
  add '/app/shops?province=島根県', :changefreq => 'weekly'
  add '/app/shops?province=静岡県', :changefreq => 'weekly'
  add '/app/shops?province=愛知県', :changefreq => 'weekly'


end
