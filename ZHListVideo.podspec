Pod::Spec.new do |s|
  s.name     = 'ZHListVideo' 
  s.version  = ‘1.0’ 
  s.license  = "MIT"  //开源协议
  s.summary  = 'Short list of videos, decoupling, automatically detect play and pause'   s.homepage = 'https://github.com/jinkh/ZHListVideo'
  s.author   = { ‘jinkh’ => '542745553@qq.com' }
  s.source   = { :git => 'https://github.com/jinkh/ZHListVideo.git', :tag => “1.0” }   s.platform = :ios 
  s.source_files = 'ZHListVideo/ShortVideo/*’
  s.framework = 'UIKit'
  s.requires_arc = true
end