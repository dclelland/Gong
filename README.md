## Gong

Gong is a simple library for sending and recieving MIDI messages to and from virtual and physical devices.

Gong aims to provide a fairly transparent Swift interface to Apple's CoreMIDI library.

The library is built in two layers:

- The files in the [`/Sources/Core`](/Sources/Core) directory are straightforward, unopinionated wrappers around CoreMIDI's C APIs.
- The files outside of the [`/Sources/Core`](/Sources) directory are slightly more opinionated, but let you perform common tasks with a minimum of setup.

More specifically: there is a global [`MIDI`](/Sources/MIDI.swift) singleton, which:

- Creates a `MIDIClient` and subscribes to `MIDINotice` events (e.g., MIDI device connections and disconnections).
- Creates a `MIDIInput`, connects it to all available `MIDISource` instances and subscribes to `MIDIPacket` events (e.g., MIDI note or control change messages).
- Creates a `MIDIOutput`, which you can use to send `MIDIPackets` to devices.
- Implements an observer pattern so classes implementing the `MIDIObserver` protocol can recieve `MIDINotice` and `MIDIPacket` messages.
- Wraps any CoreMIDI wrapper calls that might `throw` in `try ~ catch` blocks and prints any exceptions that get thrown.

If you prefer to write this kind of thing yourself, the CoreMIDI wrapper can be installed independently of the opinionated code.

An [example project](/Examples/Gong-macOS) is provided to help you get started.

### Installation

The entire library:

```ruby
pod 'Gong', '~> 1.2'
```

Just the CoreMIDI wrapper:

```ruby
pod 'Gong/Core', '~> 1.2'
```

Just the CoreMIDI wrapper, plus `MIDINote` events:

```ruby
pod 'Gong/Events', '~> 1.2'
```
#### Virtual MIDI buses

One of Gong's core use cases is sending MIDI messages into DAW software such as Ableton Live.

This necessitates setting up a virtual MIDI bus. The Ableton folks have a [tutorial](https://help.ableton.com/hc/en-us/articles/209774225-Using-virtual-MIDI-buses-in-Live) on how to do this.

### Core library architecture

#### Class hierarchy

```
MIDIObject <----+--+ MIDIClient
                |
                +--+ MIDIPort <------+--+ MIDIInput
MIDINotice      |                    |
                |                    +--+ MIDIOutput
MIDIPacket      +--+ MIDIDevice
                |
                +--+ MIDIEntity
MIDIError       |
                +--+ MIDIEndpoint <--+--+ MIDISource
                                     |
                                     +--+ MIDIDestination
```

#### Data flow

```
MIDIClient                                 MIDIDevice
 creates                                      owns
    +                                          +
    |                                          v
    |                                      MIDIEntity
    |                                         owns
    |                                          +
    v          receives packets from           v
MIDIInput <------------------------------+ MIDISource
   and           sends packets to             and
MIDIOutput +---------------------------> MIDIDestination

```

### Common tasks

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

let note = MIDINote(pitch: c5)

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
    
    func receive(_ notice: MIDINotice) {
        print(notice)
    }
    
    func receive(_ packet: MIDIPacket, from source: MIDISource) {
        switch packet.message {
        case .noteOn, .noteOff, .controlChange, .pitchBendChange:
            print(packet.message, source)
        default:
            break
        }
    }
    
}
```