//
//  MIDINotice.swift
//  Pods
//
//  Created by Daniel Clelland on 19/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import CoreMIDI

public enum MIDINotice {
    case setupChanged    
    case objectAdded(parent: MIDIObject, child: MIDIObject)    
    case objectRemoved(parent: MIDIObject, child: MIDIObject)    
    case propertyChanged(object: MIDIObject, property: String)    
    case throughConnectionsChanged    
    case serialPortOwnerChanged    
    case ioError(device: MIDIDevice, error: MIDIError)
}

extension MIDINotice {
    
    public init(_ reference: UnsafePointer<MIDINotification>) {
        let notification = reference.pointee
        switch notification.messageID {
        case .msgSetupChanged:
            self = .setupChanged
        case .msgObjectAdded:
            self = reference.withMemoryRebound(to: MIDIObjectAddRemoveNotification.self, capacity: Int(notification.messageSize)) { pointer in
                let notification = pointer.pointee
                let parent = MIDIObject.create(with: notification.parent, type: notification.parentType)
                let child = MIDIObject.create(with: notification.child, type: notification.childType)
                return .objectAdded(parent: parent, child: child)
            }
        case .msgObjectRemoved:
            self = reference.withMemoryRebound(to: MIDIObjectAddRemoveNotification.self, capacity: Int(notification.messageSize)) { pointer in
                let notification = pointer.pointee
                let parent = MIDIObject.create(with: notification.parent, type: notification.parentType)
                let child = MIDIObject.create(with: notification.child, type: notification.childType)
                return .objectRemoved(parent: parent, child: child)
            }
        case .msgPropertyChanged:
            self = reference.withMemoryRebound(to: MIDIObjectPropertyChangeNotification.self, capacity: Int(notification.messageSize)) { pointer in
                let notification = pointer.pointee
                let object = MIDIObject.create(with: notification.object, type: notification.objectType)
                let property = notification.propertyName.takeUnretainedValue()
                return .propertyChanged(object: object, property: property as String)
            }
        case .msgThruConnectionsChanged:
            self = .throughConnectionsChanged
        case .msgSerialPortOwnerChanged:
            self = .serialPortOwnerChanged
        case .msgIOError:
            self = reference.withMemoryRebound(to: MIDIIOErrorNotification.self, capacity: Int(notification.messageSize)) { pointer in
                let notification = pointer.pointee
                let device = MIDIDevice(notification.driverDevice)
                let error = MIDIError(status: notification.errorCode, comment: "Notification error")
                return .ioError(device: device, error: error)
            }
        @unknown default:
            fatalError("Unrecognized notification message ID")
        }
    }

}
