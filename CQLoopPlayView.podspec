

Pod::Spec.new do |s|

 
  s.name         = "CQLoopPlayView"
  s.version      = “1.0.0”
  s.summary      = "iOS 简易轮播图"

  s.homepage     = "https://github.com/weicunqing/CQLoopPlayView"
 
  s.license      = { :type => "MIT", :file => "LICENSE" }
 
  s.author             = { "weicunqing" => "weicunqing_iOS@163.com" }
  

  s.platform     = :ios
  s.platform     = :ios, "7.0"

 

  s.source       = { :git => "https://github.com/weicunqing/CQLoopPlayView.git", :tag => "#{s.version}" }




  s.source_files  = "CQLoopPlayView/**/*.{h,m}"
 
  s.requires_arc = true

  s.dependency 'SDWebImage', '~> 3.7'


end
