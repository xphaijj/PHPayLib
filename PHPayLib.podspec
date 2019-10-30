

Pod::Spec.new do |s|
  s.name             = 'PHPayLib'
  s.version          = '0.0.6'
  s.summary          = '支付集成'

  s.description      = <<-DESC
                        支付SDK集成，方便日常使用
                       DESC

  s.homepage         = 'https://github.com/xphaijj/PHPayLib.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xphaijj0305@126.com' => '2112787533@qq.com' }
  s.source           = { :git => 'https://github.com/xphaijj/PHPayLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.subspec 'Core' do |sp|
    sp.source_files = 'PHPayLib/Classes/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/*.h'
    sp.dependency 'OpenSSL-Universal'
    sp.dependency 'ReactiveObjC'
    sp.dependency 'YLT_BaseLib'
  end
  
  s.subspec 'AliPay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/AliPay/*.{h,m}','PHPayLib/Classes/Channel/AliPay/Util/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/AliPay/*.h','PHPayLib/Classes/Channel/AliPay/Util/*.h'
    sp.dependency 'AlipaySDK-iOS'
    sp.dependency 'PHPayLib/Core'
  end
  
  s.subspec 'WeChatPay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/WxPay/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/WxPay/*.h'
    sp.dependency 'WechatOpenSDK'
    sp.dependency 'PHPayLib/Core'
  end
  
  s.subspec 'UnionPay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/UnionPay/*.{h,m,mm}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/UnionPay/*.h'
    sp.vendored_libraries = 'PHPayLib/Classes/Channel/UnionPay/*.a'
    sp.frameworks = 'CoreMotion'
    sp.dependency 'PHPayLib/Core'
  end
  
  s.subspec 'ApplePay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/ApplePay/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/ApplePay/*.h'
    sp.dependency 'PHPayLib/Core'
  end
  
  s.subspec 'IapPay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/IapPay/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/IapPay/*.h'
    sp.dependency 'PHPayLib/Core'
  end
  
  
end
