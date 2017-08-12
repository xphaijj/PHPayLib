

Pod::Spec.new do |s|
  s.name             = 'PHPayLib'
  s.version          = '0.1.0'
  s.summary          = '支付集成'

  s.description      = <<-DESC
                        支付SDK集成，方便日常使用
                       DESC

  s.homepage         = 'https://github.com/xphaijj0305@126.com/PHPayLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xphaijj0305@126.com' => '2112787533@qq.com' }
  s.source           = { :git => 'https://github.com/xphaijj0305@126.com/PHPayLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PHPayLib/Classes/*.{h,m}'
  s.public_header_files = 'PHPayLib/Classes/*.h'
  
  s.dependency 'OpenSSL'
  s.dependency 'PHBaseLib'
  
  s.subspec 'AliPay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/AliPay/*.{h,m}','PHPayLib/Classes/Channel/AliPay/Util/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/AliPay/*.h','PHPayLib/Classes/Channel/AliPay/Util/*.h'
    sp.vendored_frameworks = 'PHPayLib/Classes/Channel/Alipay/*.framework'
    sp.resources = 'PHPayLib/Classes/Channel/Alipay/*.bundle'
  end
  
  s.subspec 'WeChatPay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/WxPay/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/WxPay/*.h'
    sp.dependency 'WechatOpenSDK'
  end
  
  s.subspec 'UnionPay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/UnionPay/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/UnionPay/*.h'
    sp.vendored_libraries = 'PHPayLib/Classes/Channel/UnionPay/*.a'
    sp.frameworks = 'CoreMotion'
  end
  
  s.subspec 'ApplePay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/ApplePay/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/ApplePay/*.h'
  end
  
  s.subspec 'IapPay' do |sp|
    sp.source_files = 'PHPayLib/Classes/Channel/IapPay/*.{h,m}'
    sp.public_header_files = 'PHPayLib/Classes/Channel/IapPay/*.h'
  end
  
  
end
