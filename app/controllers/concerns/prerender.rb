module Prerender
  BASE_API_URL = "http://api.prerender.io/recache".freeze

  # API実行用のURLを返却
  def api_url(report_type, report_id)
    case Rails.env
    when 'production'
      set_url = "http://www.rekishoku.jp/app/" + report_type + "/" + report_id.to_s
    end

    parameters = {
      "prerenderToken" => ENV['PRERENDER_TOKEN'],
      "url" => set_url,
    }
    return BASE_API_URL + "?" + parameters.map{|key,value| URI.encode(key.to_s) + "=" + URI.encode(value.to_s)}.join("&")
  end
end
