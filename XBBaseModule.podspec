Pod::Spec.new do |s|
  s.name = 'XBBaseModule'
  s.version = '0.0.1'
  s.license = 'Commercial'
  s.summary = 'XBBaseModule is base Module'
  s.homepage = 'https://happybobo.github.com/'
  s.author = { 'Bobby' => 'https://happybobo.github.com/' }
  s.source = { :git => 'https://github.com/happybobo/XBBaseModule' }
  s.platform = :ios, '8.0'
  s.source_files = '*.{h,m}'
  s.dependency 'ReactiveCocoa', '~> 2.5'
  s.dependency 'MJRefresh', '~> 3.0.2'
  s.dependency 'MBProgressHUD', '~> 0.9.1'
  s.dependency 'DZNEmptyDataSet', '~> 1.7.2'
  s.dependency 'SVPullToRefresh', '~> 0.4.1'
  s.dependency 'Masonry', '~> 0.6.3'
  s.dependency 'AFNetworking', '~> 2.5.0'
end