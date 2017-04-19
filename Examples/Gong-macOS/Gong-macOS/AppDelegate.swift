//
//  AppDelegate.swift
//  hibiscus-macOS
//
//  Created by Daniel Clelland on 17/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Cocoa
import Gong

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        MIDI.connect()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        MIDI.disconnect()
    }

}
