//
//  Gong_macOSApp.swift
//  Gong-macOS
//
//  Created by Daniel Clelland on 17/05/22.
//

import SwiftUI

@main struct GongApp: App {
    
    var body: some Scene {
        WindowGroup {
            GongView()
        }
    }
    
}

//@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {
//
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        MIDI.connect()
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        MIDI.disconnect()
//    }
//
//}
