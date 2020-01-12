# Uncomment the next line to define a global platform for your project
require 'resolv-replace'
install! 'cocoapods', :deterministic_uuids => false, :preserve_pod_file_structure => true
use_frameworks!

source 'git@github.com:applicaster/CocoaPods.git'
source 'git@github.com:applicaster/CocoaPods-Private.git'
source 'https://cdn.cocoapods.org/'

# Zaptool sources - Do not remove or change.



def read_build_params_for_type()
  filename = "./build_params"
  if File.exists?(filename)
    JSON.parse(File.read(filename), :symbolize_names => true)
  end

end

pre_install do |installer|
	# workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
	Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end

jsonObject = read_build_params_for_type()

isAppleTv = jsonObject.nil? == false && jsonObject.key?(:build_params) && jsonObject[:build_params].key?(:device_target) ? jsonObject[:build_params][:device_target] == "apple_tv" : false
puts("\n\nCocoaPods preparing for platform: #{isAppleTv ? "tvOS" : "iOS"}\n\n")

def shared_pods
    pod 'ZappPlugins', :git => 'https://github.com/applicaster/ZappPlugins-iOS', :tag => '11.3.0'
    pod 'ZappCore', :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git'
    pod 'ZappApple', :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git'
    pod 'QuickBrickApple', :path => './node_modules/@applicaster/quick-brick-native-apple/QuickBrickApple.podspec'
    pod 'yoga', :path => './node_modules/react-native/ReactCommon/yoga'
    pod 'DoubleConversion', :podspec => './node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
    pod 'glog', :podspec => './node_modules/react-native/third-party-podspecs/GLog.podspec'
    pod 'Folly', :podspec => './node_modules/react-native/third-party-podspecs/Folly.podspec'

    # Zaptool pods - Do not remove or change.
    
end

if isAppleTv


  target 'ZappTvOS' do
    platform :tvos, '10.0'

    pod 'React', :path => './node_modules/react-native', :subspecs => [
      'Core',
      'CxxBridge',
      'DevSupport',
      'RCTAnimation',
      'RCTImage',
      'RCTLinkingIOS',
      'RCTNetwork',
      'RCTPushNotification',
      'RCTSettings',
      'RCTText',
      'RCTWebSocket',
      'tvOS',
    ]

    shared_pods
  end

else

target 'ZappiOS' do
  platform :ios, '10.0'
  pod 'React', :path => './node_modules/react-native', :subspecs => [
    'Core',
    'CxxBridge',
    'DevSupport',
    'RCTAnimation',
    'RCTImage',
    'RCTLinkingIOS',
    'RCTNetwork',
    'RCTPushNotification',
    'RCTSettings',
    'RCTText',
    'RCTWebSocket',
    'RCTActionSheet'
  ]
  shared_pods
  end

end


target 'ZappAppleTests' do
  platform :ios, '10.0'
  inherit! :search_paths
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['APPLICATION_TARGET'] = isAppleTv ? "ZappTvOS" : "ZappiOS"
            config.build_settings['ENABLE_BITCODE'] = 'YES'
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
            config.build_settings['OTHER_CFLAGS'] = ['$(inherited)', "-fembed-bitcode"]
            config.build_settings['BITCODE_GENERATION_MODE']  = "bitcode"
						# This works around a unit test issue introduced in Xcode 10.
            # We only apply it to the Debug configuration to avoid bloating the app size
            if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
                config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
						end
        end
    end
end
