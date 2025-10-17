Pod::Spec.new do |s|
  s.name             = 'receive_sharing_intent'
  s.version          = '1.8.1'
  s.summary          = 'A flutter plugin that enables flutter apps to receive sharing photos, text or url from other apps.'
  s.description      = <<-DESC
A flutter plugin that enables flutter apps to receive sharing photos, text or url from other apps.
                       DESC
  s.homepage         = 'https://kasem.dev'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kasem' => 'kasem.jaffer@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'receive_sharing_intent/Sources/receive_sharing_intent/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Xcode 26 specific fixes
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'CLANG_MODULES_AUTOLINK' => 'YES',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'OTHER_SWIFT_FLAGS' => '-Xcc -fmodule-map-file="${PODS_ROOT}/Flutter/Flutter.modulemap"',
    'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/Flutter"',
    'LIBRARY_SEARCH_PATHS' => '"${PODS_ROOT}/Flutter"',
    'SWIFT_INCLUDE_PATHS' => '"${PODS_ROOT}/Flutter"',
    'OTHER_CFLAGS' => '-fmodule-map-file=${PODS_ROOT}/Flutter/Flutter.modulemap',
    'SWIFT_OBJC_BRIDGING_HEADER' => '${PODS_TARGET_SRCROOT}/receive_sharing_intent/Sources/receive_sharing_intent/receive_sharing_intent-Bridging-Header.h'
  }
  s.swift_version = '5.0'

  s.resource_bundles = {'receive_sharing_intent_privacy' => ['receive_sharing_intent/Sources/receive_sharing_intent/PrivacyInfo.xcprivacy']}
end