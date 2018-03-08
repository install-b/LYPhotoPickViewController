

Pod::Spec.new do |s|

  s.name         = "LYPhotoPickViewController"
  s.version      = "1.0.0"
  s.summary      = "an iOS photo pick view controller."
  s.description  = "a simple photo pick view controller for iOS"

  s.homepage     = "https://github.com/install-b"
  
  s.license      = "MIT"

  s.author       = { "ShangenZhang" => "645256685@qq.com" }

  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/install-b/LYPhotoPickViewController.git", :tag => s.version }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"

  s.public_header_files = "Classes/Controller/LYPhotoPickViewController.h"

  s.resource  = "Resources/*.bundle"
 
  s.framework  = "UIKit"
  
  s.requires_arc = true


end
