#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name = "Gong"
  s.version = "0.1.1"
  s.summary = "Gong is a MIDI library for iOS and macOS."
  s.homepage = "https://github.com/dclelland/Gong"
  s.license = { :type => 'MIT' }
  s.author = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source = { :git => "https://github.com/dclelland/Gong.git", :tag => "0.1.1" }

  s.subspec 'Audio' do |ss|
    ss.source_files = 'Sources/Audio/*.swift'

    ss.subspec 'Core' do |sss|
      sss.source_files = 'Sources/Audio/**/*.swift'
      sss.frameworks = 'AudioToolbox'
    end
  end

  s.subspec 'MIDI' do |ss|
    ss.source_files = 'Sources/MIDI/*.swift'

    ss.subspec 'Core' do |sss|
      sss.source_files = 'Sources/MIDI/Core/**/*.swift'
      sss.frameworks = 'CoreMIDI'
    end

    ss.subspec 'Events' do |sss|
      sss.source_files = 'Sources/MIDI/Events/**/*.swift'
      sss.dependency 'Gong/MIDI/Core'
    end
  end

  s.ios.deployment_target= '8.0'
  s.osx.deployment_target= '10.10'
end
