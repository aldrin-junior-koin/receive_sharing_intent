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
  
  # Source files
  s.source_files = 'Classes/**/*.{swift,h,m}'
  s.public_header_files = 'Classes/**/*.h'
  
  # Include privacy manifest - CRITICAL for App Store
  s.resources = 'Classes/PrivacyInfo.xcprivacy'
  
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  
  # Dependencies
  s.dependency 'Flutter'
  
  # Pod target configuration
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end