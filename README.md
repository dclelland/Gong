## Gong

### Todo

- Sort out MIDIPacketList
    - Figure out what to do about timestamps (this could be nicer - perhaps a MIDIEvent object to go with MIDIMessage...?)
    - Perhaps simple send(message:timestamp:) and send(messages:timestamp:)...? (That won't work, separate timestamps requied)
    - Perhaps: disregard MIDIPacketList entirely, only ever put one packet in there
    - https://github.com/audiokit/AudioKit/blob/dd91071bdeb617b18f8d551120ce2a6efbb97cbf/AudioKit/Common/MIDI/AKMIDI%2BSendingMIDI.swift#L75
- Remove cruft (e.g. unnecessary throws statements)
- Test out createDestination alongside createInput
- CFDictionary stuff
- Finish the zero-state singleton
    - Device configuration
    - Name configuration
    - Notification and note delegate...?
- Add debugging utilities
    - verboseDescription
    - print object tree
    - print object parameters tree

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
- Audiobus helper

Inspiration:

- objc.io's Functional Signal Processing using Swift
- Overtone
- Tidal Cycles

Combinator ideas (don't forget, @autoclosure for parameters):

- simultaneous
- sequential
- chord
- key
- chord progression
- loop
- after
- before
- polyrhythms
- polyphony
- arpeggiate
- repeat
- staccato
- velocity
- random
- smooth
- striate
- glissando
- portamento
- transpose
- trill
- mordent
- turn
- arpeggiatura
- paradiddle
- swing
- tremolo
- gate
- random gate
- and/or
- map
- filter
- reduce
