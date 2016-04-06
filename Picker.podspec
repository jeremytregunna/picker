Pod::Spec.new do |s|
  s.name             = 'Picker'
  s.version          = '1.0.0'
  s.license          = { :type => 'MIT' }
  s.summary          = 'Lightweight A/B testing library for Swift'
  s.homepage         = 'https://github.com/jeremytregunna/Picker'
  s.authors          = { 'Jeremy Tregunna' => 'jeremy@tregunna.ca' }
  s.source           = { :git => 'https://github.com/jeremytregunna/Picker.git', :tag => '1.0.0' }
  s.social_media_url = 'https://twitter.com/jtregunna'
  s.requires_arc     = true
  s.source_files     = "Picker/*"
end
