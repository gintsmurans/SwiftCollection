#
#  Be sure to run `pod spec lint SwiftExtensions.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "GMSwiftExtensions"
  s.version      = "0.0.5"
  s.summary      = "Various Swift Extensions"
  s.description  = <<-DESC
Various Swift Extensions, that I have put together my self and from samples found while googling away, doing all kinds of stuff like: UIImage().resize(), UIImage().crop(), NSDictionary().jsonString(), UIView().viewWithTagRecursive(), and more.
                   DESC

  s.homepage     = "https://github.com/gintsmurans/SwiftExtensions"
  s.license      = "MIT"

  s.author       = { "Gints Murāns" => "gm@gm.lv" }
  s.social_media_url   = "https://twitter.com/gintsmurans"

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/gintsmurans/SwiftExtensions.git", :branch => "master" }
  s.source_files  = "*.swift"
  s.exclude_files = "README.md", "LICENSE"

end
