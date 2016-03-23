class AppRouteController < ApplicationController

  # 詳細データ表示
  def show
    path = Rails.root.to_s + "/public/main.html"
    description = "歴食は武将や文豪、その時代の人たちが愛した食を見るだけでなく食べる体験を提供するサイトです."
    keywords = "歴史,偉人,食事,歴食,郷土料理,暦食"

    url = params[:path]
    if url.nil?
      render :file => path, :layout => false
    else
      urls = url.split('/')
      if urls[0] == 'post' && urls[1].present?
        @post = Post.find(urls[1].to_s)

        keywords = Array.new
        keywords.push("歴食")
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
        opg = {
          title: @post.title,
          type: 'website',
          image: @post.image.md.url,
          site_name: "歴食",
          description: @post.content.gsub(/(\r\n|\r|\n|\f)/,""),
          locale: 'ja_JP'
        }
        set_meta_tags open_graph: opg

        # ionic用jsを先に読み込んでおく
        vendor = Dir.glob(Rails.root.to_s + "/public/scripts/vendor*.js")
        scripts = Dir.glob(Rails.root.to_s + "/public/scripts/scripts*.js")
        @vendor_js =  'http://' + request.host_with_port + '/scripts/' + File.basename(vendor[0])
        @scripts_js =  'http://' + request.host_with_port + '/scripts/' + File.basename(scripts[0])

      # elsif urls[0] == 'shop' && urls[1].present?
      #   @shop = Shop.find(urls[1].to_s)
      #
      #   keywords = Array.new
      #   @shop.people.each do |person|
      #     keywords.push(person.name)
      #   end
      #   # SEO用metaタグ設定
      #   set_meta_tags title: @shop.name
      #   set_meta_tags description: @shop.description.gsub(/(\r\n|\r|\n|\f)/,"")
      #   set_meta_tags keywords: keywords.join(",")

      else
        render :file => path, :layout => false
      end
    end

  end

end
