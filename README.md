## Gong

### Todo

Notes:

- monoCat, polyCat
    - a 'then' function, a 'next', or 'during' function (simultaneous and not simultaneous)
        - probably takes 'after' as an argument
    - then catMono is just reduce([], then)
- remove type system (need to solve key/interval name clash issue)
    - Chords and Scales are just key sequences (majorChord, majorScale)
    - MIDIKey is just an Int or whatever
    - MIDIInterval goes to be 
- Simple file structure:
    - MIDI
    - MIDINote
    - MIDIConstants
    - MIDIFunctions
- Fix name overloading
    - MIDIPacketEvent
    - MIDINotificationEvent
- bring back event model
    - MIDIControl, MIDIPitchBend, MIDIRest
    - These support ramps with rates, different curve types etc
    - copy MIDIWord thing from audioKit
- Publish Gong properly

Now:

- Test out all the functions
- Do documentation
- Try writing a sequencer on top
- Better name...? (Could have Gong for audio and Glockenspiel or something for MIDI)
- Look into CoreAudio wrapper too
- Publish it and get feedback!

Architecture:

- MIDI wrapper library
- MIDI combinator library
- Audio wrapper library
- Audio combinator library
- Audiobus helper
- Bridge
    - (Perhaps have a MIDIReceiver protocol so we can send the same kinds of messages or packets to MIDIDevice and AudioUnit...?)
- Example projects

Questions:

- Do we need to connect/disconnect each time?
- RxSwift vs combinators
- Send/receive nomenclature
- Singleton architecture and sensible defaults

Inspiration:

- [Functional Signal Processing Using Swift](https://www.objc.io/issues/24-audio/functional-signal-processing/)
- [Overtone](https://toplap.org/overtone/)
- [Tidal Cycles](https://tidalcycles.org)
- [Recurrent Neural Networks with Swift and Accelerate](http://machinethink.net/blog/recurrent-neural-networks-with-swift/)
- [Musical L-Systems](http://carlosreynoso.com.ar/archivos/manousakis.pdf)

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
