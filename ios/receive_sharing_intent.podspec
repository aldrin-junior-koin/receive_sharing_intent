Pod::Spec.new do |s|
  s.name             = 'receive_sharing_intent'
  s.version          = '1.0.0'
  s.summary          = 'A flutter plugin that enables flutter apps to receive sharing photos, videos, text or urls from other apps.'
  s.description      = <<-DESC
A flutter plugin that enables flutter apps to receive sharing photos, videos, text or urls from other apps.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resources = 'Classes/PrivacyInfo.xcprivacy'
  
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  
  s.dependency 'Flutter'
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end