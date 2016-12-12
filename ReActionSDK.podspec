Pod::Spec.new do |s|
  s.name         = "ReActionSDK"
  s.version      = "0.0.27"
  s.summary      = "ReActionSDK"

  s.description  = <<-DESC
        ReActionSDK - GCM notifications
                   DESC

  s.homepage     = "https://github.com/ironSource/reaction-ios"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "g8y3e" => "valentine.pavchuk@ironsrc.com" }
  s.platform     = :ios, '8.0'

  s.source       = { :git => "https://github.com/ironSource/reaction-ios.git", :tag => "dev" }
  s.source_files  = "reaction_sdk/ReActionSDK/ReActionSDK/**/*.{h,m}"

  s.requires_arc = true

  s.dependency 'AtomSDK'
  s.dependency 'Google/CloudMessaging'

  s.xcconfig     = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$PODS_CONFIGURATION_BUILD_DIR/AtomSDK" "$PODS_CONFIGURATION_BUILD_DIR/sqlite3" "${PODS_ROOT}/GoogleIPhoneUtilities/Frameworks" "${PODS_ROOT}/GoogleInterchangeUtilities/Frameworks/frameworks" "${PODS_ROOT}/GoogleNetworkingUtilities/Frameworks/frameworks" "${PODS_ROOT}/GoogleSymbolUtilities/Frameworks/frameworks" "${PODS_ROOT}/GoogleUtilities/Frameworks/frameworks"',

    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) COCOAPODS=1',
    'HEADER_SEARCH_PATHS' => '$(inherited) ${PODS_ROOT}/Google/Headers $(inherited) "${PODS_ROOT}/Headers/Public" "${PODS_ROOT}/Headers/Public/GGLInstanceID" "${PODS_ROOT}/Headers/Public/Google" "${PODS_ROOT}/Headers/Public/GoogleCloudMessaging" "${PODS_ROOT}/Headers/Public/GoogleIPhoneUtilities" "${PODS_ROOT}/Headers/Public/GoogleInterchangeUtilities" "${PODS_ROOT}/Headers/Public/GoogleNetworkingUtilities" "${PODS_ROOT}/Headers/Public/GoogleSymbolUtilities" "${PODS_ROOT}/Headers/Public/GoogleUtilities"',

    'LD_RUNPATH_SEARCH_PATHS' => '$(inherited) "@executable_path/Frameworks" "@loader_path/Frameworks"',
    'LIBRARY_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/GGLInstanceID/Libraries" $(inherited) "${PODS_ROOT}/Google/Libraries" $(inherited) "${PODS_ROOT}/GoogleCloudMessaging/Libraries"',

    'OTHER_CFLAGS' => '$(inherited) -iquote "$PODS_CONFIGURATION_BUILD_DIR/AtomSDK/AtomSDK.framework/Headers" -iquote "$PODS_CONFIGURATION_BUILD_DIR/sqlite3/sqlite3.framework/Headers" -isystem "${PODS_ROOT}/Headers/Public" -isystem "${PODS_ROOT}/Headers/Public/GGLInstanceID" -isystem "${PODS_ROOT}/Headers/Public/Google" -isystem "${PODS_ROOT}/Headers/Public/GoogleCloudMessaging" -isystem "${PODS_ROOT}/Headers/Public/GoogleIPhoneUtilities" -isystem "${PODS_ROOT}/Headers/Public/GoogleInterchangeUtilities" -isystem "${PODS_ROOT}/Headers/Public/GoogleNetworkingUtilities" -isystem "${PODS_ROOT}/Headers/Public/GoogleSymbolUtilities" -isystem "${PODS_ROOT}/Headers/Public/GoogleUtilities"',

    'OTHER_LDFLAGS' => '$(inherited) -ObjC -l"GGLCloudMessaging" -l"GGLCore" -l"GGLInstanceIDLib" -l"GcmLib" -l"sqlite3" -l"stdc++" -l"z" -framework "AddressBook" -framework "AssetsLibrary" -framework "AtomSDK" -framework "CoreFoundation" -framework "CoreGraphics" -framework "CoreLocation" -framework "CoreMotion" -framework "GoogleIPhoneUtilities" -framework "GoogleInterchangeUtilities" -framework "GoogleNetworkingUtilities" -framework "GoogleSymbolUtilities" -framework "GoogleUtilities" -framework "MessageUI" -framework "Security" -framework "SystemConfiguration" -framework "sqlite3"'
  }
end
