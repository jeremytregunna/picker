Pod::Spec.new do |s|
  s.name                  = 'Picker'
  s.version               = '1.0.1'
  s.license               = { :type => 'MIT' }
  s.summary               = 'Lightweight A/B testing library for Swift'
  s.homepage              = 'https://github.com/jeremytregunna/picker'
  s.authors               = { 'Jeremy Tregunna' => 'jeremy@tregunna.ca' }
  s.source                = { :git => 'https://github.com/jeremytregunna/picker.git', :tag => '1.0.1' }
  s.social_media_url      = 'https://twitter.com/jtregunna'
  s.platform              = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc          = true
  s.source_files          = "Picker/*"
end
