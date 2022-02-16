#
# Be sure to run `pod lib lint ZZMedia.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZZMedia'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ZZMedia.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/iPhoneHH/ZZMedia'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iPhoneHH' => 'zheng.jia@immomo.com' }
  s.source           = { :git => 'https://github.com/iPhoneHH/ZZMedia.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZZMedia/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZZMedia' => ['ZZMedia/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
#  pod 'SDWebImage','4.4.1'
#  pod 'YYModel','1.0.4'
#  pod 'ReactiveCocoa','2.5'
#  #pod 'DDComponent','0.5.5'
#  pod 'DNMainFramework'
#  pod 'DDSkin','0.0.1'
#  pod 'YYCache','1.0.4'
#  pod 'AFNetworking' ,'3.2.1'
#  pod 'MJRefresh', '3.1.15.7'
#  pod 'YYText','1.0.7'
#  pod 'DNCommonKit'
#
  
  
  s.dependency 'AFNetworking' ,'3.2.1'
  s.dependency 'Masonry', '1.1.0'
  s.dependency 'SDWebImage','4.4.1'
  s.dependency 'YYCache','1.0.4'
  s.dependency 'YYText','1.0.7'
  s.dependency 'YYModel','1.0.4'
  s.dependency 'MJRefresh', '3.1.15.7'
  s.dependency 'Aspects','1.4.1'
  
end
