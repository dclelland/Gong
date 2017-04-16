## Gong

### Todo

- Finish API coverage
- Make MIDI messages better
- Fix up CFData/CFDictionary stuff
- Start on AudioUnit/CoreAudio stuff
- Separate libraries: CoreAudioExtensions, CoreMIDIExtensions
- Object subscription or lazy dictionary
- Fix find(with:type:)
- System exclusive messages
- Chords (lazy sequence or protocol?)
- Arpeggiator?
- Combinator system
- Time system

- Chord/Note etc should mimic Buffer as much as possible
- Perhaps use SoundPipe for low level audio stuff?

//    kMIDIPropertyName                    : device/entity/endpoint,     string
//    kMIDIPropertyManufacturer            : device/endpoint,            string
//    kMIDIPropertyModel                   : device/endpoint,            string
//    kMIDIPropertyUniqueID                : device/entity/endpoint,     integer
//    kMIDIPropertyDeviceID                : device/entity,              integer
//    kMIDIPropertyReceiveChannels         : endpoint,                   integer
//    kMIDIPropertyTransmitChannels        : endpoint,                   integer
//    kMIDIPropertyMaxSysExSpeed           : device/entity/endpoint,     integer
//    kMIDIPropertyAdvanceScheduleTimeMuSec: device/entity/endpoint,     integer
//    kMIDIPropertyIsEmbeddedEntity        : entity/endpoint,            integer
//    kMIDIPropertyIsBroadcast             : entity/endpoint,            integer
//    kMIDIPropertySingleRealtimeEntity    : device,                     integer
//    kMIDIPropertyConnectionUniqueID      : device/entity/endpoint,     integer or data
//    kMIDIPropertyOffline                 : device/entity/endpoint,     integer
//    kMIDIPropertyPrivate                 : device/entity/endpoint,     integer
//    kMIDIPropertyDriverOwner             : device/entity/endpoint,     string
//    kMIDIPropertyNameConfiguration       : device/entity/endpoint,     dictionary
//    kMIDIPropertyImage                   : device,                     string
//    kMIDIPropertyDriverVersion           : device/entity/endpoint,     integer
//    kMIDIPropertySupportsGeneralMIDI     : device/entity,              boolean integer
//    kMIDIPropertySupportsMMC             : device/entity,              boolean integer
//    kMIDIPropertyCanRoute                : device/entity,              boolean integer
//    kMIDIPropertyReceivesClock           : device/entity,              boolean integer
//    kMIDIPropertyReceivesMTC             : device/entity,              boolean integer
//    kMIDIPropertyReceivesNotes           : device/entity,              boolean integer
//    kMIDIPropertyReceivesProgramChanges  : device/entity,              boolean integer
//    kMIDIPropertyReceivesBankSelectMSB   : device/entity,              boolean integer
//    kMIDIPropertyReceivesBankSelectLSB   : device/entity,              boolean integer
//    kMIDIPropertyTransmitsClock          : device/entity,              boolean integer
//    kMIDIPropertyTransmitsMTC            : device/entity,              boolean integer
//    kMIDIPropertyTransmitsNotes          : device/entity,              boolean integer
//    kMIDIPropertyTransmitsProgramChanges : device/entity,              boolean integer
//    kMIDIPropertyTransmitsBankSelectMSB  : device/entity,              boolean integer
//    kMIDIPropertyTransmitsBankSelectLSB  : device/entity,              boolean integer
//    kMIDIPropertyPanDisruptsStereo       : device/entity,              boolean integer
//    kMIDIPropertyIsSampler               : device/entity,              boolean integer
//    kMIDIPropertyIsDrumMachine           : device/entity,              boolean integer
//    kMIDIPropertyIsMixer                 : device/entity,              boolean integer
//    kMIDIPropertyIsEffectUnit            : device/entity,              boolean integer
//    kMIDIPropertyMaxReceiveChannels      : device/entity,              integer
//    kMIDIPropertyMaxTransmitChannels     : device/entity,              boolean integer
//    kMIDIPropertyDriverDeviceEditorApp   : device,                     string
//    kMIDIPropertySupportsShowControl     : device/entity,              boolean integer
//    kMIDIPropertyDisplayName             : device/entity/endpoint,     string
