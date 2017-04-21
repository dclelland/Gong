## Gong

### Todo

Now:

- Fix timestamp issue
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
