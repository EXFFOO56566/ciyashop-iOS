# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
    end
  end
end

target 'CiyaShop' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
   use_frameworks!

  # Pods for CiyaShop
      pod 'SDWebImage', '~> 5.0'
      pod 'SwiftyJSON', '~> 4.0'
#      pod 'HCSStarRatingView', '~> 1.5'
      pod 'Cosmos','~> 23.0'
      pod 'IQKeyboardManagerSwift', '6.3.0'
      pod 'RangeSeekSlider'
      pod 'CountryPickerView'
      pod 'Firebase/Core'
      pod 'Firebase/Auth'
      pod 'Firebase/DynamicLinks'
      pod 'GoogleSignIn'
      pod 'OneSignal', '>= 2.11.2', '< 3.0'
      pod 'FBSDKCoreKit'
      pod 'FBSDKLoginKit'

      target 'NotificationService' do
          pod 'OneSignal', '>= 2.11.2', '< 3.0'
      end

end

