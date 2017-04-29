## Gong

Gong is a simple library for sending and recieving MIDI messages to and from virtual and physical devices.

Gong aims to provide a fairly transparent Swift interface to Apple's CoreMIDI library. The files in the `/Sources/Core` directory are unopinionated, simple wrappers around CoreMIDI's C APIs. The files outside `/Sources/Core` are generally more opinionated, but let you perform common tasks with a minimum of setup. If you prefer to write this kind of stuff yourself, the CoreMIDI wrapper can be installed independently of the opinionated code.

### Installation:

The entire library:

```ruby
pod 'Gong', '~> 0.1'
```

Just the CoreMIDI wrapper:

```ruby
pod 'Gong/Core', '~> 0.1'
```

Just the CoreMIDI wrapper, plus MIDINote events:

```ruby
pod 'Gong/Events', '~> 0.1'
```

### Common tasks:

Starting the MIDI client:

```swift
MIDI.connect()
```

Stopping the MIDI client:

```swift
MIDI.disconnect()
```

Listing devices:

```swift
for device in MIDIDevice.all {
    print(device.name)
}
```

Sending MIDI events:

```swift
guard let device = MIDIDevice(named: "minilogue"), let output = MIDI.output else {
    return
}

let note = MIDINote(key: 60)

device.send(note, via: output)
```

Receiving MIDI packets:

```swift
class ViewController: NSViewController {

    override func viewWillAppear() {
        super.viewWillAppear()
        
        MIDI.addObserver(self)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        MIDI.removeObserver(self)
    }

}

extension ViewController: MIDIObserver {
    
    func receive(_ notification: MIDINotification) {
        print(notification)
    }
    
    func receive(_ packet: MIDIPacket, from source: MIDISource) {
        switch packet.message {
        case .noteOn, .noteOff, .controlChange, .pitchBendChange:
            print(packet, source)
        default:
            break
        }
    }
    
}
```
