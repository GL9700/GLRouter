#
# Be sure to run `pod lib lint GLRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GLRouter'
  s.version          = '2.1.1'
  s.summary          = '一个极其简便灵活的iOS路由'
  s.description      = <<-DESC
  😜Without register anyclass !
  🥳Without more sourceCode !
  🥳Just one line code !
  🧑‍💻Launch !
  🎉Look! It working!
  DESC

  s.homepage         = 'https://github.com/GL9700/GLRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liguoliang' => '36617161@qq.com' }
  s.source           = { :git => 'https://github.com/GL9700/GLRouter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'GLRouter/Classes/**/*'

  # s.resource_bundles = {
  #   'GLRouter' => ['GLRouter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
