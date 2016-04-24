RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  # 宣言したDBを表示させないようにする
  config.excluded_models = ["Price","PeopleShop","CategoriesShop","CategoriesPerson","Category","Post","PostDetail","Period","PostsShop","PeoplePeriod","PeoplePost"]

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
    label "ユーザー管理DB"
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
      field :role  do
        label "管理レベル"
        help "必須　0:管理者　1:ライター 2:一般ユーザー"
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
        help "必須　例)菓子"
        required true
      end
      field :slug  do
        label "管理用記事カテゴリ"
        help "必須　英語　例)tea"
        required true
      end
      field :people do
        label "関係がある人"
        help "対象カテゴリを右に移動してくだい"
      end
      field :shops do
        label "関係があるお店"
        help "対象カテゴリを右に移動してくだい"
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
         help "必須　例)菓子"
         required true
       end
       field :slug  do
         label "管理用人物カテゴリ"
         help "必須　英語　例)tea"
         required true
       end
       field :people do
         label "関係がある人"
         help "対象カテゴリを右に移動してくだい"
       end
       field :shops do
         label "関係があるお店"
         help "対象カテゴリを右に移動してくだい"
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
      field :people do
        label "関係がある人"
        help "対象カテゴリを右に移動してくだい"
      end
      field :shops do
        label "関係があるお店"
        help "対象カテゴリを右に移動してくだい"
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
       field :rating  do
         label "ランク"
         help "1-3段階　有名だと3"
         required true
       end
       field :periods do
           label "関係がある時代"
           help "対象カテゴリを右に移動してくだい"
        end
        field :shops do
          label "関係があるお店"
          help "対象カテゴリを右に移動してくだい"
        end
      end
    end

  ## 店舗
  config.model 'Shop' do
    label "お店登録"
    weight 1

    list do
      field :id
      field :name do
        label "店舗名"
      end
      field :description do
        label "店舗説明"
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
        help "必要に応じて"
      end
      field :image_quotation_name do
        label "画像掲載元名称"
        help "必要に応じて"
      end
      field :post_quotation_name do
        label "記事参照元URL"
        help "必要に応じて"
      end
      field :post_quotation_name do
        label "記事参照元名称"
        help "必要に応じて"
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
        help "必要に応じて"
      end
      field :phone_no do
        label "電話番号"
        help "必須 例) 080-1234-5678"
        required true
      end
      field :daytime_price_id do
        label "日中価格帯"
        help "必須　例）6 :〜5999"
      end
      field :nighttime_price_id do
        label "夜間価格帯"
        help "必須 例) 1 :〜999"
      end
      field :shop_hours do
        label "営業時間"
        help "必須　例) 9:00〜21:00　フリーフォーマット"
      end
      field :is_closed_sun do
        label "日曜定休"
        help "正しければチェックをいれてください"
      end
      field :is_closed_mon do
        label "月曜定休"
        help "正しければチェックをいれてください"
      end
      field :is_closed_tue do
        label "火曜定休"
        help "正しければチェックをいれてください"
      end
      field :is_closed_wed do
        label "水曜定休"
        help "正しければチェックをいれてください"
      end
      field :is_closed_thu do
        label "木曜定休"
        help "正しければチェックをいれてください"
      end
      field :is_closed_fri do
        label "金曜定休"
        help "正しければチェックをいれてください"
      end
      field :is_closed_sat do
        label "土曜定休"
        help "正しければチェックをいれてください"
      end
      field :is_closed_hol do
        label "祝日定休"
        help "正しければチェックをいれてください"
      end
      field :closed_pattern do
        label "その他定休日"
        help "フリーフォーマット"
      end
      field :people do
        label "関係がある人物"
        help "必須 対象カテゴリを右に移動してくだい"
      end
      field :is_approved do
        label "承認確認"
        help "承認を取得した場合は、チェックを追加してください"
      end
    end
  end

end
