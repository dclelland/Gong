## Gong

### Todo

- Sort out MIDIPacketList
    - Figure out what to do about timestamps (this could be nicer - perhaps a MIDIEvent object to go with MIDIMessage...?)
    - Perhaps simple send(message:timestamp:) and send(messages:timestamp:)...? (That won't work, separate timestamps requied)
- Remove cruft (e.g. unnecessary throws statements)
- Test out createDestination alongside createInput
- CFDictionary stuff
- Finish the zero-state singleton
    - Device configuration
    - Name configuration
    - Notification and note delegate...?

Then:

- Do documentation
- Try writing a sequencer on top
- Better name...? (Could have Gong for audio and Glockenspiel or something for MIDI)
- Look into CoreAudio wrapper too
- Publish it and get feedback!

Arch:

- MIDI wrapper library
- MIDI combinator library
- Audio wrapper library
- Audio combinator library
