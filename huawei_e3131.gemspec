Gem::Specification.new do |s|
  s.name = 'huawei_e3131'
  s.version = '0.1.0'
  s.summary = 'Checks the Huawei E3131 SMS inbox for new messages using the HTTP API.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/huawei_e3131.rb']
  s.add_runtime_dependency('rexle', '~> 1.5', '>=1.5.2')
  s.add_runtime_dependency('rest-client', '~> 2.1', '>=2.1.0')
  s.signing_key = '../privatekeys/huawei_e3131.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/huawei_e3131'
end
