class AppRouteController < ApplicationController
  before_action :set_params, only: [:post, :shop]

  # 詳細データ表示
  def show
    path = Rails.root.to_s + "/public/main.html"
    render :file => path, :layout => false
  end

  # 記事データ表示
  def post
    if @urls[0].present?
      @data = Post.find(@urls[0].to_s)
      # SEO用keywordsの設定
      @data.people.each do |person|
        @keywords.push(person.name)
      end
      @data.shops.each do |shop|
        @keywords.push(shop.name)
      end
      # SEO用metaタグ設定
      set_meta_tags title: @data.title
      set_meta_tags description: @data.content.gsub(/(\r\n|\r|\n|\f)/,"")
      set_meta_tags keywords: @keywords.join(",")
      @opg["title"] = @data.title
      @opg["image"] = @data.image.md.url
      @opg["description"] = @data.content.gsub(/(\r\n|\r|\n|\f)/,"")

      set_meta_tags open_graph: @opg
    end

  end

  # 店舗データ表示
  def shop
    if @urls[0].present?
      @data = Shop.find(@urls[0].to_s)
      # SEO用keywordsの設定
      @keywords.push(@data.name)
      @data.people.each do |person|
        @keywords.push(person.name)
      end
      categories = Array.new
      @data.categories.each do |category|
        categories.push(category.name)
      end
      @categories = categories.join("・")
      @address = @data.province + @data.city + @data.address1 + @data.address2
      # SEO用metaタグ設定
      set_meta_tags title: @data.name
      set_meta_tags description: @data.description.gsub(/(\r\n|\r|\n|\f)/,"")
      set_meta_tags keywords: @keywords.join(",")
      @opg["title"] = @data.name
      @opg["image"] = @data.image.md.url
      @opg["description"] = @data.description.gsub(/(\r\n|\r|\n|\f)/,"")

      set_meta_tags open_graph: @opg
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_params
      url = params[:path]
      @urls = url.split('/')
      # SEO用keywordsの作成
      @keywords = Array.new
      @keywords.push("歴食")
      @opg = {
        title: "",
        type: 'website',
        image: "",
        site_name: "歴食",
        description: "",
        locale: 'ja_JP'
      }

      # ionic用jsを先に読み込んでおく
      vendor = Dir.glob(Rails.root.to_s + "/public/scripts/vendor*.js")
      scripts = Dir.glob(Rails.root.to_s + "/public/scripts/scripts*.js")
      @vendor_js =  'http://' + request.host_with_port + '/scripts/' + File.basename(vendor[0])
      @scripts_js =  'http://' + request.host_with_port + '/scripts/' + File.basename(scripts[0])

    end

end
