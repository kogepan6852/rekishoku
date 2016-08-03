module ApiGeocoder
  # 緯度経度の計算
  def get_geocoder(address)
    Geocoder.configure(:language  => :ja,  :units => :km )
    return Geocoder.coordinates(address);
  end
end
