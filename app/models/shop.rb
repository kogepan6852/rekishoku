class Shop < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :posts
  mount_uploader :image, ImageUploader
  mount_uploader :subimage, ImageUploader
  # 住所から緯度経度を代入する
  geocoded_by :address1
  after_validation :geocode, if: Proc.new { |a| a.address1_changed? }

  # 距離の設定が100km以内を判断する
  validates :shopDistance, numericality:{ only_interger: true,less_than: 100001}
  validates :placeAddress, presence: true
end
