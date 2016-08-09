require "rails_admin/config/actions"
require "rails_admin/config/actions/base"

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
                register_instance_option :controller do
                    Proc.new do
                        if request.get?
                            # 一覧表示　（モデル内容を全て取得）
                            @objects = list_entries(@model_config, :destroy, get_association_scope_from_params, false)
                        elsif request.put?
                            # 表示順の更新
                            objects = list_entries(@model_config, :destroy)
                            params[:products].each do |params_product|
                                object = objects.find(params_product[:id])
                                object.update_attributes(order: params_product[:order])
                            end
                            redirect_to(:back)
                        else
                            raise "エラーメッセージ"
                        end
                    end
                end
            end
        end
    end
end
