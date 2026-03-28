#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint device_identity.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'device_identity'
  s.version          = '1.1.0'
  s.summary          = '用于获取设备标识的插件（androidId、Imei、oaid、idfa等）'
  s.description      = <<-DESC
用于获取设备标识的插件（androidId、Imei、oaid、idfa等）
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # AdSupport 提供 ASIdentifierManager（IDFA）
  # AppTrackingTransparency 提供 ATT 权限申请（iOS 14+），弱引用以兼容 iOS 12/13
  s.frameworks = 'AdSupport'
  s.weak_frameworks = 'AppTrackingTransparency'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
