require 'minitest/reporters'
require 'minitest/autorun'
require 'net/https'
require 'uri'

# curl -k https://admin.leter.test
# curl -k https://eduardosasso.leter.test
describe 'NGINX config' do
  Minitest::Reporters.use!

  it 'redirects to rails admin page' do
    uri = URI.parse('https://admin.leter.test')

    response = request(uri)

    assert response.code.to_i == 302
  end

  it 'shows the home page' do
    uri = URI.parse('https://eduardosasso.leter.test')

    response = request(uri)

    assert response.code.to_i == 200
  end

  it 'shows internal page' do
    uri = URI.parse('https://eduardosasso.leter.test/resume')

    response = request(uri)

    assert response.code.to_i == 200
  end

  def request(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)

    http.request(req)
  end
end
