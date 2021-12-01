Pod::Spec.new do |spec|

  spec.name         = "Secp256k1Signing"
  spec.version      = "1.0.0"
  spec.summary      = "iOS端 椭圆曲线 Secp256k1 签名与验签的实现"

  spec.description = '椭圆曲线 Secp256k1 签名与验签的实现'

  spec.homepage     = "https://github.com/dbchaincloud/secp256k1-ios-ilb"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "YangtingTombay" => "m18620345206@163.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '9.0'

  # spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/dbchaincloud/secp256k1-ios-ilb.git", :tag => spec.version.to_s }

  spec.exclude_files = "Secp256k1Signing/**/*.h"
  spec.source_files  = "Secp256k1Signing", "Secp256k1Signing/**/*.{swift}"

  spec.requires_arc     = true
  spec.static_framework = true
  # spec.module_name   = "Secp256k1Signing"
  spec.dependency "secp256k1.swift", '~> 0.1.4'

  # spec.public_header_files = "Classes/**/*.h"

 if spec.respond_to? 'swift_version'
      spec.swift_version = "5.0"
  end


  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
