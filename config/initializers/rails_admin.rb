RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  # 宣言したDBを表示させないようにする
  config.excluded_models = ["Price","PeopleShop","CategoriesShop","CategoriesPerson","CategoriesFeature","Category","Period","PostsShop","PeoplePeriod","PeoplePost"]

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  ## ユーザーの管理レベル調整
  config.model 'User' do
    label "ユーザー管理"
    weight 4
    list do
      field :id
      field :email do
        label "メールアドレス"
      end
      field :username do
        label "公開する名前"
      end
      field :role do
        label "管理レベル"
      end
    end
    edit do
      field :email  do
        label "メールアドレス"
        help "必須"
        required true
      end
      field :password  do
        label "パスワード"
        help "8-32文字"
      end
      field :password_confirmation do
        label "再パスワード入力"
        help "8-32文字"
      end
      field :username do
        label "公開する名前"
        help "必須"
        required true
      end
      field :last_name do
        label "苗字"
        help "必須"
        required true
      end
      field :first_name do
        label "名前"
        help "必須"
        required true
      end
      field :profile do
        label "プロフィール"
        help "任意"
      end
      field :image do
        label "プロフィール画面"
        help "必須"
        required true
      end
      field :role, :enum do
      enum do
        Hash[ ['管理者', '一般ユーザー','ライター','編集者'].zip(['0','1','2','3']) ]
      end
        label "管理レベル"
        help "必須　0:管理者　1:一般ユーザー 2:ライター 3:編集者"
        required true
      end
    end
   end

   ## 記事カテゴリ
  config.model 'PostCategory' do
     label "記事カテゴリ"
     weight 3
     list do
       field :name
       field :slug
       field :updated_at
     end
    edit do
      field :name  do
        label "記事カテゴリ名"
        help "必須　例)歴食ニュース"
        required true
      end
      field :slug  do
        label "管理用記事カテゴリ"
        help "必須　英語　例)information"
        required true
      end
    end
  end

   ## 人物カテゴリ
   config.model 'PersonCategory' do
     label "人物カテゴリ"
     weight 3
     list do
       field :name
       field :slug
       field :updated_at
     end
     edit do
       field :name  do
         label "人物カテゴリ名"
         help "必須　例)武将"
         required true
       end
       field :slug  do
         label "管理用人物カテゴリ"
         help "必須　英語　例)military_commander"
         required true
       end
      end
    end

  ## お店カテゴリ
  config.model 'ShopCategory' do
    label "ショップカテゴリ"
    weight 3
    list do
      field :name
      field :slug
      field :updated_at
    end
    edit do
      field :name  do
        label "ショップカテゴリ名"
        help "必須　例)菓子"
        required true
      end
      field :slug  do
        label "管理用カテゴリ名"
        help "必須　英語　例)tea"
        required true
      end
    end
   end

   ## お店カテゴリ
   config.model 'FeatureCategory' do
     label "特集カテゴリ"
     weight 3
     list do
       field :name
       field :slug
       field :updated_at
     end
     edit do
       field :name  do
         label "特集カテゴリ名"
         help "必須　例)菓子"
         required true
       end
       field :slug  do
         label "管理用カテゴリ名"
         help "必須　英語　例)tea"
         required true
       end
     end
    end

   ## 人物
   config.model 'Person' do
     label "人物登録"
     weight 2
     list do
       field :id
       field :name do
         label "名前"
       end
       field :rating  do
         label "ランク"
       end
     end

     edit do
       field :name  do
         label "名前"
         help "必須"
         required true
       end
       field :furigana  do
         label "ふりがな"
         help "必須"
         required true
       end
       field :rating do
         label "ランク"
         required true
       end
       field :periods do
           label "関係がある時代"
           help "対象カテゴリを右に移動してくだい"
        end
      end
    end

  ## 店舗
  config.model 'Shop' do
    label "お店"
    weight 1

    list do
      field :id
      field :name do
        label "店舗名"
      end
      field :description do
        label "店舗説明"
      end
      field :total_level do
        label "歴食度合計"
      end
      field :is_approved do
        label "承認確認"
      end
    end

    edit do
      field :name do
        label "店舗名"
        help "必須"
        required true
      end
      field :description do
        label "店舗説明"
        help "必須　フリーフォーマット"
        required true
      end
      field :url do
        label "店舗URL"
        help "必須"
        required true
      end
      field :menu do
        label "メニュー名"
        help "必須 例) うなぎ料理 3000円　フリーフォーマット"
        required true
      end
      field :image do
        label "メイン写真URL"
        help "必須"
        required true
      end
      field :subimage do
        label "サブ写真URL"
        help "必須"
        required true
      end
      field :image_quotation_url do
        label "画像掲載元URL"
      end
      field :image_quotation_name do
        label "画像掲載元名称"
      end
      field :post_quotation_name do
        label "記事参照元URL"
      end
      field :post_quotation_name do
        label "記事参照元名称"
      end
      field :province do
        label "都道府県"
        help "必須"
        required true
      end
      field :city do
        label "市町村"
        help "必須"
        required true
      end
      field :address1 do
        label "その他住所"
        help "必須 例) 銀座8-14-7"
        required true
      end
      field :address2 do
        label "建物名"
      end
      field :phone_no do
        label "電話番号"
        help "必須 例) 080-1234-5678"
        required true
      end
      field :daytime_price_id, :enum do
      enum do
        Hash[ ['0~999','1000~1999', '2000~2999','3000~3999','4000~4999', '5000~5999','6000~7999','8000~9999', '10000~14999','15000~19999','20000~29999', '30000~49999','50000~999999'].zip(['1','2','3','4','5','6','7','8','9','10','11','12','13']) ]
      end
        label "日中価格帯"
      end
      field :nighttime_price_id, :enum do
      enum do
        Hash[ ['0~999','1000~1999', '2000~2999','3000~3999','4000~4999', '5000~5999','6000~7999','8000~9999', '10000~14999','15000~19999','20000~29999', '30000~49999','50000~999999'].zip(['1','2','3','4','5','6','7','8','9','10','11','12','13']) ]
      end
        label "夜間価格帯"
      end
      field :shop_hours do
        label "営業時間"
        help "必須　例) 9:00〜21:00　フリーフォーマット"
        required true
      end
      field :is_closed_sun do
        label "日曜定休"
        help "定休の場合はチェック"
      end
      field :is_closed_mon do
        label "月曜定休"
        help "定休の場合はチェック"
      end
      field :is_closed_tue do
        label "火曜定休"
        help "定休の場合はチェック"
      end
      field :is_closed_wed do
        label "水曜定休"
        help "定休の場合はチェック"
      end
      field :is_closed_thu do
        label "木曜定休"
        help "定休の場合はチェック"
      end
      field :is_closed_fri do
        label "金曜定休"
        help "定休の場合はチェック"
      end
      field :is_closed_sat do
        label "土曜定休"
        help "定休の場合はチェック"
      end
      field :is_closed_hol do
        label "祝日定休"
        help "定休の場合はチェック"
      end
      field :closed_pattern do
        label "その他定休日"
        help "フリーフォーマット"
      end
      field :closed_pattern do
        label "その他定休日"
        help "フリーフォーマット"
      end
      field :history_level, :enum do
      enum do
        Hash[ ['不明','0:戦後', '1:明治以降から昭和戦前','2:江戸時代','3:江戸以前'].zip(['-1','0','1','2','3']) ]
      end
        label "創業"
        help "必須"
        required true
      end
      field :building_level, :enum do
      enum do
        Hash[ ['不明','0:どちらも戦後', '1:片方が戦前','2:片方が大正以前','3:建物が江戸以前'].zip(['-1','0','1','2','3']) ]
      end
        label "建物"
        help "必須　内装と建物で判断"
        required true
      end
      field :menu_level , :enum do
      enum do
        Hash[ ['不明','0:創作系', '1:復刻','2:当時から','3:オリジナル'].zip(['-1','0','1','2','3']) ]
      end
        label "メニュー"
        help "必須"
        required true
      end
      field :person_level, :enum do
      enum do
        Hash[ ['不明','1:庶民', '2:有名人1人','3:有名人2人以上'].zip(['-1','1','2','3']) ]
      end
        label "人物レベル"
        help "必須"
        required true
      end
      field :episode_level, :enum do
      enum do
        Hash[ ['不明','1:関連なし', '2:他店or移転前','3:実現場'].zip(['-1','1','2','3']) ]
      end
        label "エピソード"
        help "必須"
        required true
      end
      field :people do
        label "関係がある人物"
        help "対象人物を右に移動してください"
      end
      field :categories do
        label "関連があるカテゴリを選択"
        help "必須 対応するカテゴリを選択してください"
        required true
      end
      field :is_approved do
        label "承認確認"
        help "承認を取得した場合は、チェックを追加してください"
      end
    end
  end

  ## 投稿カテゴリ
  config.model 'Post' do
    label "記事"
    weight 0
    list do
      field :id
      field :title do
        label "題名"
      end
      field :image do
        label "トップ画像"
      end
      field :content  do
        label "内容"
      end
      field :user_id  do
        label "投稿者"
      end
      field :status, :enum do
      enum do
        Hash[ ['公開','非公開'].zip(['1','0']) ]
      end
        label "投稿状態"
      end
      field :shops do
        label "関連店舗"
      end
      field :people do
        label "関連人物"
      end
    end
    edit do
      field :title  do
        label "題名"
        help "必須"
        required true
      end
      field :content  do
        label "内容"
        help "必須"
        required true
      end
      field :image  do
        label "トップ画像"
        help "必須"
        required true
      end
      field :quotation_url  do
        label "引用したURL"
      end
      field :quotation_name  do
        label "引用したサイト名"
      end
      field :category  do
        label "対応するカテゴリを選択してください"
      end
      field :post_details do
        label "記事セクション"
        help "対応しているセクションは右にあるので、ダブルクリックで修正可能です"
      end
      field :status, :enum do
      enum do
        Hash[ ['公開','非公開'].zip(['1','0']) ]
      end
        label "公開状態"
        required true
      end
      field :published_at do
        label "公開時間"
        required true
      end
      field :shops  do
        label "関連店舗"
        help "関連する店舗は右にしてください"
      end
      field :people  do
        label "関連人物"
        help "関連する人は右にしてください"
      end
      field :user do
        label "ライター"
        required true
        help "必須"
      end
    end
   end

   ## 記事詳細
   config.model 'PostDetail' do
     label "投稿記事各セクション"
     weight 5
     list do
       field :post do
         label "記事名"
       end
       field :title do
         label "サブタイトル"
       end
       field :image do
         label "サブ画像"
       end
       field :content do
         label "内容"
       end
     end
     edit do
       field :title do
         label "サブタイトル"
         help "必須"
         required true
       end
       field :content do
         label "内容"
         help "必須"
         required true
       end
       field :image  do
         label "画像"
         help "必須"
         required true
       end
       field :quotation_url do
         label "引用したURL"
       end
       field :quotation_name do
         label "引用したサイト名"
       end
     end
    end


    ####  特集
    config.model 'Feature' do
      label "特集"
      weight 0
      list do
        field :id
        field :title do
          label "タイトル"
        end
        field :image do
          label "メイン写真"
        end
        field :is_map do
          label "マップ表示有無"
        end
        field :category do
          label "カテゴリ"
        end
      end
      edit do
          field :title do
            label "タイトル"
            help "必須"
            required true
          end
          field :content do
            label "内容"
            help "必須"
            required true
          end
          field :image  do
            label "画像"
            help "必須"
            required true
          end
          field :quotation_url do
            label "引用したURL"
          end
          field :quotation_name do
            label "引用したサイト名"
          end
          field :is_map do
            label "マップ表示有無"
          end
          field :category do
            label "カテゴリ"
            help "必須 対応するカテゴリを選択してください"
            required true
          end
          field :feature_details do
            label "特集詳細"
          end
          field :status, :enum do
          enum do
            Hash[ ['公開','非公開'].zip([ 1, 0]) ]
          end
            label "公開状態"
            required true
          end
          field :published_at do
            label "公開時間"
            required true
          end
          field :user do
            label "ライター"
            required true
            help "必須"
          end
      end
     end

     ## 特集詳細
      config.model 'FeatureDetail' do
        label "特集詳細"
        weight 0
        list do
          field :title do
            label "タイトル"
          end
          field :order do
            label "順番"
          end
          field :related_type , :enum do
          enum do
            Hash[ ['お店','記事', '外部リンク'].zip(['Shop','Post','ExternalLink']) ]
          end
            label "どのDBか"
          end
          field :related_id do
            label "参照DBのID"
          end
        end
        edit do
            field :title do
              label "タイトル"
            end
            field :content do
              label "コメント"
            end
            field :order , :enum do
            enum do
              Hash[ ['1','2','3','4','5','6','7','8','9','10'].zip(['1','2','3','4','5','6','7','8','9','10']) ]
            end
              label "順番"
              required true
              help "必須"
            end
            field :related do
              label "紐付けする情報"
              help "必須"
              required true
            end
        end
       end
      ##  外部リング
      config.model 'ExternalLink' do
        label "外部リンク"
        weight 1
        list do
          field :id
          field :name do
            label "タイトル"
          end
          field :image do
            label "メイン写真"
          end
          field :content do
            label "コメント"
          end
        end
        edit do
            field :name do
              label "タイトル"
              help "必須"
              required true
            end
            field :content do
              label "内容"
              help "必須"
              required true
            end
            field :image  do
              label "画像"
              help "必須"
              required true
            end
            field :quotation_url do
              label "引用したURL"
            end
            field :quotation_name do
              label "引用したサイト名"
            end
        end
       end

end
