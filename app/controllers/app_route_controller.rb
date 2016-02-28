class AppRouteController < ApplicationController

  # 詳細データ表示
  def show
    path = Rails.root.to_s + "/public/main.html"
    if params[:_escaped_fragment_].nil?
      render :file => path, :layout => false
    else
      url = params[:path]
      urls = url.split('/')

      if urls[0] == 'post' && urls[1].present?
        @post = Post.find(urls[1].to_s)

        keywords = Array.new
        @post.people.each do |person|
          keywords.push(person.name)
        end
        @post.shops.each do |shop|
          keywords.push(shop.name)
        end
        # SEO用metaタグ設定
        set_meta_tags title: @post.title
        set_meta_tags description: @post.content.gsub(/(\r\n|\r|\n|\f)/,"")
        set_meta_tags keywords: keywords.join(",")
      elsif urls[0] == 'shop' && urls[1].present?
        @shop = Shop.find(urls[1].to_s)

        keywords = Array.new
        @shop.people.each do |person|
          keywords.push(person.name)
        end
        # SEO用metaタグ設定
        set_meta_tags title: @shop.name
        set_meta_tags description: @shop.description.gsub(/(\r\n|\r|\n|\f)/,"")
        set_meta_tags keywords: keywords.join(",")

      else
        render :file => path, :layout => false
      end
    end

  end

end
