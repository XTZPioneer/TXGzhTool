Pod::Spec.new do |s|
  s.name         = 'TXGzhTool'
  s.version      = '0.0.1'
  s.summary      = '微信公众号开发工具。'
  s.description  = <<-DESC
			这是一个微信公众号开发工具。
                   DESC
  s.homepage     = 'https://github.com/XTZPioneer/TXGzhTool'
  s.license      = 'MIT'
  s.author       = { 'zhangxiong' => 'xtz_pioneer@163.com' }
  s.platform     = :ios
  s.source       = { :git => 'https://github.com/XTZPioneer/TXGzhTool.git', :tag => s.version.to_s }
  s.source_files = 'TXGzhTool/**/*.{h,m}'
  s.requires_arc = true  
  s.dependency 'AFNetworking', '~> 3.1.0'
end