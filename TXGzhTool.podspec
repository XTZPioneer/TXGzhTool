Pod::Spec.new do |s|
  s.name         = 'TXGzhTool'         
  s.version      = '0.0.1'             
  s.summary      = 'Just Testing.'     
  s.description  = <<-DESC
                       Testing Private Podspec.
                       DESC
  s.homepage     = 'https://github.com/XTZPioneer/TXGzhTool'                           
  s.license      = 'MIT'                                 
  s.author       = { 'zhangxiong' => 'xtz_pioneer@163.com' }
  s.source       = { :git => 'https://github.com/XTZPioneer/TXGzhTool.git', :tag => '0.0.1' }    
  s.platform     = :ios, '7.0'            
  s.requires_arc = true                   
  s.source_files = 'TXGzhTool/**/*.{h,m}'
  s.dependency 'AFNetworking', '~> 3.1.0' 
end