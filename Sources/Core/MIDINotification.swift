//
//  MIDIEvent.swift
//  Pods
//
//  Created by Daniel Clelland on 19/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public enum MIDINotification {
    
    case setupChanged
    
    case objectAdded(parent: MIDIObject, child: MIDIObject)
    
    case objectRemoved(parent: MIDIObject, child: MIDIObject)
    
    case propertyChanged(object: MIDIObject, property: CFString)
    
    case throughConnectionsChanged
    
    case serialPortOwnerChanged
    
    case ioError(device: MIDIDevice, error: MIDIError)

}

extension MIDINotification {
    
    internal init(_ notificationPointer: UnsafePointer<CoreMIDI.MIDINotification>) {
        let notification = notificationPointer.pointee
        switch notification.messageID {
        case .msgSetupChanged:
            self = .setupChanged
        case .msgObjectAdded:
            let notification: MIDIObjectAddRemoveNotification = notificationPointer.unwrap(size: Int(notification.messageSize))
            let parent = MIDIObject.create(with: notification.parent, type: notification.parentType)
            let child = MIDIObject.create(with: notification.child, type: notification.childType)
            self = .objectAdded(parent: parent, child: child)
        case .msgObjectRemoved:
            let notification: MIDIObjectAddRemoveNotification = notificationPointer.unwrap(size: Int(notification.messageSize))
            let parent = MIDIObject.create(with: notification.parent, type: notification.parentType)
            let child = MIDIObject.create(with: notification.child, type: notification.childType)
            self = .objectRemoved(parent: parent, child: child)
        case .msgPropertyChanged:
            let notification: MIDIObjectPropertyChangeNotification = notificationPointer.unwrap(size: Int(notification.messageSize))
            let object = MIDIObject.create(with: notification.object, type: notification.objectType)
            let property = notification.propertyName.takeUnretainedValue()
            self = .propertyChanged(object: object, property: property)
        case .msgThruConnectionsChanged:
            self = .throughConnectionsChanged
        case .msgSerialPortOwnerChanged:
            self = .serialPortOwnerChanged
        case .msgIOError:
            let notification: MIDIIOErrorNotification = notificationPointer.unwrap(size: Int(notification.messageSize))
            let device = MIDIDevice(notification.driverDevice)
            let error = MIDIError(status: notification.errorCode, message: "Notification error")
            self = .ioError(device: device, error: error)
        }
    }

}
