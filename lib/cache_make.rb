require "rails_admin/config/actions"
require "rails_admin/config/actions/base"
include Prerender

module RailsAdmin
    module Config
        module Actions
            class CacheMake < RailsAdmin::Config::Actions::Base
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
                # 管理画面のキャッシュボタンのAction
                register_instance_option :controller do
                    Proc.new do
                        if request.get?
                          # 一覧表示　（モデル内容を全て取得）
                          @objects = list_entries(@model_config, :destroy, get_association_scope_from_params, false)
                        elsif request.put?
                          # 通信用
                          cache_url = "http://www.rekishoku.jp/app/"+ params[:model_name] + "/" + params[:page][:name].to_s
                          create_page_cache(cache_url)
                        else
                          raise "エラーメッセージ"
                        end
                    end
                end
            end
        end
    end
end
