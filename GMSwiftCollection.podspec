#
#  Be sure to run `pod spec lint GMSwiftCollection.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "GMSwiftCollection"
  s.version      = "0.1.7"
  s.summary      = "Collection of various Swift sources"
  s.description  = <<-DESC
Collection of various Swift sources: Controllers, Classes, Extensions, and more, that I have put together my self and from samples found while googling around.
                   DESC

  s.homepage     = "https://github.com/gintsmurans/SwiftCollection"
  s.license      = "MIT"

  s.author       = { "Gints Murāns" => "gm@gm.lv" }
  s.social_media_url   = "https://twitter.com/gintsmurans"

  s.platform     = :ios, "9.3"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/gintsmurans/SwiftCollection.git", :tag => s.version }
  s.source_files  = "Sources/**/*.swift"
  s.exclude_files = "README.md", "LICENSE"

end
