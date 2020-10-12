#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name = "Gong"
  s.version = "1.2.1"
  s.summary = "Gong is a MIDI library for iOS and macOS."
  s.homepage = "https://github.com/dclelland/Gong"
  s.license = { :type => 'MIT' }
  s.author = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source = { :git => "https://github.com/dclelland/Gong.git", :tag => "1.2.1" }
  s.source_files = 'Sources/Gong/*.swift'
  s.swift_versions = ['5.1', '5.2']

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Gong/Core/**/*.swift'
    ss.frameworks = 'CoreMIDI'
  end

  s.subspec 'Events' do |ss|
    ss.source_files = 'Sources/Gong/Events/**/*.swift'
    ss.dependency 'Gong/Core'
  end

  s.subspec 'Constants' do |ss|
    ss.source_files = 'Sources/Gong/Constants/**/*.swift'
  end

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
end
