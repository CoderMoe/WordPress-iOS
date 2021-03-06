source 'https://github.com/CocoaPods/Specs.git'

project 'WordPress/WordPress.xcodeproj'

inhibit_all_warnings!
use_frameworks!

platform :ios, '9.0'

abstract_target 'WordPress_Base' do
  pod 'WordPress-iOS-Shared', '0.7.0'
  ## This pod is only being included to support the share extension ATM - https://github.com/wordpress-mobile/WordPress-iOS/issues/5081
  pod 'WordPressComKit', :git => 'https://github.com/Automattic/WordPressComKit.git', :tag => '0.0.6'
  pod 'WordPressCom-Stats-iOS', '0.8.1'

  target 'WordPress' do
    # ---------------------
    # Third party libraries
    # ---------------------
    pod '1PasswordExtension', '1.8.1'
    pod 'AFNetworking',	'3.1.0'
    pod 'CocoaLumberjack', '~> 2.2.0'
    pod 'FormatterKit', '~> 1.8.1'
    pod 'Helpshift', '~> 5.7.1'
    pod 'HockeySDK', '~> 3.8.0', :configurations => ['Release-Internal', 'Release-Alpha']
    pod 'Lookback', '1.4.1', :configurations => ['Release-Internal', 'Release-Alpha']
    pod 'MRProgress', '~>0.7.0'
    pod 'Mixpanel', '2.9.4'
    pod 'Reachability',	'3.2'
    pod 'SVProgressHUD', '~>1.1.3'
    pod 'UIDeviceIdentifier', '~> 0.1'
    pod 'Crashlytics'
    pod 'BuddyBuildSDK', '~> 1.0.11', :configurations => ['Release-Alpha']
    pod 'FLAnimatedImage', '~> 1.0'
    pod 'Starscream', '~> 2.0'
    # ----------------------------
    # Forked third party libraries
    # ----------------------------
    pod 'WordPress-AppbotX', :git => 'https://github.com/wordpress-mobile/appbotx.git', :commit => '479d05f7d6b963c9b44040e6ea9f190e8bd9a47a'

    # --------------------
    # WordPress components
    # --------------------
    pod 'Automattic-Tracks-iOS', :git => 'https://github.com/Automattic/Automattic-Tracks-iOS.git', :tag => '0.1.2'
    pod 'Gridicons', :git => 'https://github.com/Automattic/Gridicons-iOS.git', :tag => '0.4'
    pod 'NSObject-SafeExpectations', '0.0.2'
    pod 'NSURL+IDN', '0.3'
    pod 'WPMediaPicker', '~> 0.10.2'
    pod 'WordPress-iOS-Editor', '1.8.1'
    pod 'WordPressCom-Analytics-iOS', '0.1.21'
    pod 'WordPress-Aztec-iOS', :git => 'https://github.com/wordpress-mobile/WordPress-Aztec-iOS.git', :branch => 'swift-3/gridicons-bump'
    pod 'wpxmlrpc', '~> 0.8'

    target :WordPressTest do
      inherit! :search_paths
      pod 'OHHTTPStubs'
      pod 'OHHTTPStubs/Swift'
      pod 'OCMock', '3.1.2'
      pod 'Specta', '1.0.5'
      pod 'Expecta', '1.0.5'
      pod 'Nimble', '~> 5.0.0'
    end
  end

  target 'WordPressShareExtension' do
  end

  target 'WordPressTodayWidget' do
  end

end
