#
# Be sure to run `pod lib lint Parameterize.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Parameterize'
  s.version          = '1.0.5'
  s.summary          = 'Serialize object to API parameters'

  s.description      = <<-DESC
Serialize object to API parameters using convenience property wrapper.
                       DESC

  s.homepage         = 'https://github.com/kientux/Parameterize'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kientux' => 'ntkien93@gmail.com' }
  s.source           = { :git => 'https://github.com/kientux/Parameterize.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_versions = '5.5'

  s.source_files = 'Sources/Parameterize/**/*'
end
