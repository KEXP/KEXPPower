Pod::Spec.new do |s|
  s.name             = 'KEXPPower'
  s.version          = '3.0.0'
  s.summary          = 'A lightweight swift library that is used to communicate with the KEXP services to retrieve play and show information.'
  s.homepage         = 'https://github.com/KEXP'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dustin Bergman' => 'dustin.bergman@gmail.com' }
  s.source           = { :git => 'https://github.com/KEXP/KEXPPower.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kexp'

  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'

  s.source_files = 'KEXPPower/**/*.swift'
  s.swift_version = '5.0'
end

