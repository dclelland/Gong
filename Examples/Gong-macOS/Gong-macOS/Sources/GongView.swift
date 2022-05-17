//
//  ContentView.swift
//  Gong-macOS
//
//  Created by Daniel Clelland on 17/05/22.
//

import SwiftUI
import Gong

struct GongView: View {
    
    var body: some View {
        HStack(spacing: 8.0) {
            Button(action: { playNote(c5) }, label: { Text("C").frame(width: 24.0) })
            Button(action: { playNote(d5) }, label: { Text("D").frame(width: 24.0) })
            Button(action: { playNote(e5) }, label: { Text("E").frame(width: 24.0) })
            Button(action: { playNote(f5) }, label: { Text("F").frame(width: 24.0) })
            Button(action: { playNote(g5) }, label: { Text("G").frame(width: 24.0) })
            Button(action: { playNote(a5) }, label: { Text("A").frame(width: 24.0) })
            Button(action: { playNote(b5) }, label: { Text("B").frame(width: 24.0) })
        }
        .padding()
    }
    
}

extension GongView {
    
    func playNote(_ pitch: Int) {
//        guard let output = MIDI.output else {
//            return
//        }
//
//        let note = MIDINote(pitch: pitch)
//
//        for device in MIDIDevice.all {
//            device.send(note, via: output)
//        }
    }
    
}

struct GongView_Previews: PreviewProvider {
    
    static var previews: some View {
        GongView()
    }
    
}
