module Prerender

  # API実行用のURLを返却
  def create_page_cache(cache_url)
    if Rails.env == 'production'
      # 通信用
      http_client = HTTPClient.new

      # prerender.ioの対応
      endpoint_uri = 'http://api.prerender.io/recache'
      begin
        request_content = {:prerenderToken => ENV["PRERENDER_TOKEN"], :url => cache_url}
        content_json = request_content.to_json
        http_client.set_auth(endpoint_uri, ENV["PRERENDER_MEAL"], ENV["PRERENDER_PASSWORD"])
        http_client.post_content(endpoint_uri, content_json, 'Content-Type' => 'application/json')
      rescue => ex
        puts("prerender Error")
      end


      # Facebook対応
      endpoint_uri = 'https://graph.facebook.com'
      request_content = {:scrape => "true", :id => cache_url}
      content_json = request_content.to_json
      begin
        http_client.post_content(endpoint_uri, content_json, 'Content-Type' => 'application/json')
      rescue => ex
        puts("Facebook Error")
      end

    end
  end
end
