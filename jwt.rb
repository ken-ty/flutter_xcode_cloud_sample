# App Store Connect API 用の JWT トークンを生成するスクリプト
# 以下のコマンドで実行することができます。
# 例:
# ruby jwt.rb --help
# ruby jwt.rb --issuer-id YOUR_ISSUER_ID --key-id YOUR_PRIVATE_KEY_ID --private-key-path /path/to/AuthKey_ABC123.p8
#
# 必要な値は App Store Connect から取得してください。

require "base64"
require "jwt"
require "openssl"
require "optparse"

# 引数の解析
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: jwt.rb [options]"

  opts.on("--issuer-id ISSUER_ID", "App Store Connect Issuer ID") do |v|
    options[:issuer_id] = v
  end

  opts.on("--key-id KEY_ID", "Private Key ID") do |v|
    options[:key_id] = v
  end

  opts.on("--private-key-path PATH", "Path to the private key file") do |v|
    options[:private_key_path] = v
  end

  opts.on("--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

# 必須パラメータのチェック
[:issuer_id, :key_id, :private_key_path].each do |key|
  if options[key].nil?
    puts "Error: Missing required option --#{key.to_s.gsub('_', '-')}"
    exit 1
  end
end

# パラメータの取得
issuer_id = options[:issuer_id]
key_id = options[:key_id]
private_key_path = options[:private_key_path]

# プライベートキーを読み込む
begin
  private_key = OpenSSL::PKey::EC.new(File.read(private_key_path))
rescue Errno::ENOENT
  puts "Error: Private key file not found at #{private_key_path}"
  exit 1
rescue OpenSSL::PKey::ECError => e
  puts "Error: Failed to read private key - #{e.message}"
  exit 1
end

# JWT トークンを生成

# POSTMAN だとこんな感じ
# {
#   "iss": "xxxx-xx-xx-xx-xxxxx",
#   "exp": 00000000,
#   "aud": "appstoreconnect-v1"
# }
payload = {
  iss: issuer_id,
  exp: Time.now.to_i + 20 * 60, # 有効期限（20分後）
  aud: "appstoreconnect-v1"
}
token = JWT.encode(
  payload,
  private_key,
  "ES256",
  {
    kid: key_id
  }
)

# トークンを出力
puts token
