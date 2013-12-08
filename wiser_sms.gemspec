# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wiser_sms/version'

Gem::Specification.new do |spec|
  spec.name          = "wiser_sms"
  spec.version       = WiserSms::VERSION
  spec.authors       = ["Kenneth John Balgos"]
  spec.email         = ["kennethjohnbalgos@gmail.com"]
  spec.description   = "Medium Rare Outgoing SMS"
  spec.summary       = ""
  spec.homepage      = "https://github.com/kennethjohnbalgos/wiser_sms"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
end