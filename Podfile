platform :ios,              '8.0'

use_frameworks!
inhibit_all_warnings!

pod 'ShareKit/Facebook',         '~> 4.0.4'
pod 'ShareKit/Twitter',          '~> 4.0.4'
pod 'youtube-ios-player-helper', '~> 0.1.4'
pod 'SwiftyJSON',                '~> 2.3.0'
pod 'ReactiveCocoa',             '~> 2.2.4'
pod 'SDWebImage',                '~> 3.7.2'
pod 'TTTAttributedLabel',        '~> 1.13.3'

target 'EmbassatTests' do
pod 'ReactiveCocoa',             '~> 2.2.4'
pod 'ShareKit/Facebook',         '~> 4.0.4'
pod 'ShareKit/Twitter',          '~> 4.0.4'
end

post_install do |installer|  
  installer.pods_project.build_configuration_list.build_configurations.each do |configuration|  
    configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'  
  end  
end 

