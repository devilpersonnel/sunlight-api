module ProcessApiRequests

  VALID_ACTIONS_AND_OPTIONS = {
    'Price': ['quantity', 'zip_code', 'warehouseID']
  }.with_indifferent_access.freeze

  BASE_URL = 'https://services.sunlightsupply.com/v1/'

  API_KEY = 'AaBbCcDdEdFfGgHhJjKkMmNnPpQqRrSsTtUuVvWwXxYyZz23456789'
  API_SECRET = 'Sample'

  def process_api_request(action, options = {})
    options = build_the_options(options)
    signed_url = build_signed_url(action, options)
    request_to_api(signed_url)
  end

  private

  def build_the_options(options)
    options.merge(
      'format': 'json',
      'X-ApiKey': API_KEY,
      'time': Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    )
  end

  def build_signed_url(action, options)
    initial_url = BASE_URL + "#{action}" + build_option_url(options)
    sign_the_url(initial_url)
  end

  def build_option_url(options)
    option_url = options[:id].present? ? "/#{options[:id]}?" : '?'
    options = options.except(:id)
    options.each do |opt|
      option_url = option_url + "#{opt[0]}=#{opt[1]}&"
    end
    option_url
  end

  def sign_the_url(initial_url)
    initial_url + signature(initial_url)
  end

  def signature(initial_url)
    digest  = OpenSSL::Digest::Digest.new('sha256')
    signature = OpenSSL::HMAC.hexdigest(digest, API_SECRET, initial_url).upcase
    "signature=#{signature}"
  end

  def request_to_api(signed_url)
    # HTTParty.get(signed_url)
    render json: {message: 'requested to signed url'}
  end

end
