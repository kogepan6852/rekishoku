module Prerender

  # API実行用のURLを返却
  def api_url(set_url)
    if Rails.env == 'production'
      # 通信用
      http_client = HTTPClient.new

      # prerender.ioの対応
      endpoint_uri = 'http://api.prerender.io/recache'
      request_content = {:prerenderToken => "zeJzE6OXcjajAT4aENY9", :url => set_url}
      content_json = request_content.to_json
      http_client.set_auth(endpoint_uri, "rekishoku@gmail.com", "@Startup2015")
      http_client.post_content(endpoint_uri, content_json, 'Content-Type' => 'application/json')

      # Facebook対応
      endpoint_uri = 'https://graph.facebook.com'
      request_content = {:scrape => "true", :id => set_url}
      content_json = request_content.to_json
      http_client.post_content(endpoint_uri, content_json, 'Content-Type' => 'application/json')
    end
  end
end
