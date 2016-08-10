require "rails_admin/config/actions"
require "rails_admin/config/actions/base"

module RailsAdmin
    module Config
        module Actions
            class CacheMake < RailsAdmin::Config::Actions::Base
                require 'net/http'
                include Prerender
                RailsAdmin::Config::Actions.register(self)

                # カスタムコントローラを作成するため、以下を true にする
                register_instance_option :collection? do
                    true
                end

                register_instance_option :bulkable do
                    true
                end

                register_instance_option :http_methods do
                    [:get, :put]
                end

                # コントローラーアクションの処理
                register_instance_option :controller do
                    Proc.new do
                        if request.get?
                            # 一覧表示　（モデル内容を全て取得）
                            @objects = list_entries(@model_config, :destroy, get_association_scope_from_params, false)
                        elsif request.put?
                            # 表示順の更新
                            http_client = HTTPClient.new

                            # prerender.ioの対応
                            endpoint_uri = 'http://api.prerender.io/recache'
                            set_url = "http://www.rekishoku.jp/app/"+ params[:model_name] + "/" + params[:page][:name].to_s
                            request_content = {:prerenderToken => ENV["PRERENDER_TOKEN"], :url => set_url}
                            content_json = request_content.to_json

                            http_client.set_auth(endpoint_uri, ENV["PRERENDER_MEAL"], ENV["PRERENDER_PASSWORD"])
                            http_client.post_content(endpoint_uri, content_json, 'Content-Type' => 'application/json')

                            # Facebook対応
                            endpoint_uri = 'https://graph.facebook.com'
                            request_content = {:scrape => true, :id => set_url}
                            content_json = request_content.to_json
                            http_client.post_content(endpoint_uri, content_json, 'Content-Type' => 'application/json')
                        else
                            raise "エラーメッセージ"
                        end
                    end
                end
            end
        end
    end
end
