Pod::Spec.new do |s|
  s.name         = "SocketIO"
  s.version      = "0.0.1"
  s.summary      = "SocketIO v0.1.x via JavaScriptCore"
  s.platform     = :ios, "7.0"

  s.description  = <<-DESC
                   A longer description of SocketIO in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://github.com/hden/SocketIO.JSCore"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author                = { "Hao-kang Den" => "haokang.den@gmail.com" }
  s.social_media_url      = "http://twitter.com/_hden"
  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/hden/SocketIO.JSCore.git", :tag => "0.0.1" }
  s.source_files = "SocketIO/**/*.{h,m}"
  s.requires_arc = true

  s.public_header_files = "SocketIO/**/*.h"
  s.dependency "Emitter"
  s.resource_bundle = {
    "SocketIO" => "SocketIO/*.html"
  }
end
