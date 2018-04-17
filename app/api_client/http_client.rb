class HttpClient
  def post(path, headers={}, data={})
    uri = URI("#{path}")
    req = Net::HTTP::Post.new(uri)

    req.body = data unless data.empty?

    headers.each do |k, v|
      req[k.to_s]=v
    end
    log("[REQUEST] headers:#{headers} uri: #{path} data#{data}")
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end
    log("[RESPONSE] #{res}")
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      return res.body
    else
      return res.value
    end
  end

  def get(path, headers={"Accept": 'application/json',"Authorization": "Bearer #{@access_token}"})
    uri = URI("#{path}")
    req = Net::HTTP::Get.new(uri)

    headers.each do |k, v|
      req[k.to_s]=v
    end
    log("[REQUEST] headers:#{headers} uri: #{path}")
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end
    log("[RESPONSE] #{res.body}")
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      res.body
    else
      res.value
    end
  end
  private
  def log(msg)
    p msg
  end
end