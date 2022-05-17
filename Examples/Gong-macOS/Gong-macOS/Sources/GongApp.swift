//
//  Gong_macOSApp.swift
//  Gong-macOS
//
//  Created by Daniel Clelland on 17/05/22.
//

import SwiftUI
import Gong

@main struct GongApp: App {
    
    var body: some Scene {
        WindowGroup {
            GongView()
        }
    }
    
    init() {
        MIDI.connect()
//        MIDI.disconnect()
    }
    
}
