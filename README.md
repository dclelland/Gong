## Gong

Gong is a simple library for sending and recieving MIDI messages to and from virtual and physical devices.

Gong aims to provide a fairly transparent Swift interface to Apple's CoreMIDI library.

[The files in the `/Sources/Core` directory](/Sources/Core) are simple, unopinionated wrappers around CoreMIDI's C APIs.

[The files outside of `/Sources/Core`](/Sources) are generally more opinionated, but let you perform common tasks with a minimum of setup.

More specifically: there is a [global `MIDI` singleton](/Sources/MIDI.swift), which:

- Creates a `MIDIClient` and subscribes to `MIDINotification` events (e.g., MIDI device connections and disconnections).
- Creates a `MIDIInput`, connects it to all available `MIDISource` instances and subscribes to `MIDIPacket` events (e.g., MIDI note or control change messages).
- Creates a `MIDIOutput`, which you can use to send `MIDIPackets` to devices.
- Implements an observer pattern so classes implementing the `MIDIObserver` protocol can recieve `MIDINotification` and `MIDIPacket` messages.

If you prefer to write this kind of thing yourself, the CoreMIDI wrapper can be installed independently of the opinionated code.

An [example project](/Examples/Gong-macOS) is provided to help you get started.

### Installation:

The entire library:

```ruby
pod 'Gong', '~> 0.1'
```

Just the CoreMIDI wrapper:

```ruby
pod 'Gong/Core', '~> 0.1'
```

Just the CoreMIDI wrapper, plus `MIDINote` events:

```ruby
pod 'Gong/Events', '~> 0.1'
```

### Core class hierarchy:

```
MIDIObject <-----+--- MIDIClient
                 |
                 +--- MIDIPort <-------+--- MIDIInput
MIDINotification |                     |
                 |                     +--- MIDIOutput
MIDIPacket       +--- MIDIDevice
                 |
                 +--- MIDIEntity
MIDIError        |
                 +--- MIDIEndpoint <---+--- MIDISource
                                       |
                                       +--- MIDIDestination
```

### Core class architecture:

```
MIDIClient                                 MIDIDevice
    |                                          |
 creates                                      owns
    |                                          |
    |                                          v
    |                                      MIDIEntity
    |                                          |
    |                                         owns
    |                                          |
    v          receives packets from           v
MIDIInput <------------------------------+ MIDISource
   and           sends packets to             and
MIDIOutput +---------------------------> MIDIDestination

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
