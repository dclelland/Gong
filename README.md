# ProtonomeAudioKitControls

ProtonomeAudioKitControls is my kitchen sink framework of IBDesignable controls for use with AudioKit 2.

## Installation:

```ruby
pod 'ProtonomeAudioKitControls', '~> 0.3'
```

## Podspec:

```ruby
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['PROTONOME_AUDIOKIT_ENABLED'] = true
        end
    end
end
```