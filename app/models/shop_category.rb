class ShopCategory < Category
  has_and_belongs_to_many :shops
end
