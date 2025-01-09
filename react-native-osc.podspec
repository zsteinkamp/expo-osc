require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-osc"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-osc
                   DESC
  s.homepage     = "https://github.com/zsteinkamp/expo-osc"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Luis Fernando García Pérez" => "contacto@luiscript.com", "Zack Steinkamp" => "zack@steinkamp.us" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/zsteinkamp/expo-osc.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency 'SwiftOSC.git'
  s.swift_version = '4.2'
end

