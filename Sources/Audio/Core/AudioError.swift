//
//  AudioError.swift
//  Gong
//
//  Created by Daniel Clelland on 29/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public struct AudioError: Error {
    
    public enum Message {
        
        public enum AudioComponent {
            case instanceInvalidated
        }
        
        case audioComponent(AudioComponent)
        
        public enum AudioConverter {
            case formatNotSupported
            case operationNotSupported
            case propertyNotSupported
            case invalidInputSize
            case invalidOutputSize
            case unspecifiedError
            case badPropertySizeError
            case requiresPacketDescriptionsError
            case inputSampleRateOutOfRange
            case outputSampleRateOutOfRange
        }

        case audioConverter(AudioConverter)
        
        public enum AudioDevice {
            case unsupportedFormat
            case permissions
        }
        
        case audioDevice(AudioDevice)
        
        public enum AudioFile {
            case unspecified
            case unsupportedFileType
            case unsupportedDataFormat
            case unsupportedProperty
            case badPropertySize
            case permissions
            case notOptimized
            case invalidChunk
            case doesNotAllow64BitDataSize
            case invalidPacketOffset
            case invalidFile
            case operationNotSupported
            case notOpen
            case endOfFile
            case position
            case fileNotFound
        }
        
        case audioFile(AudioFile)
        
        public enum AudioFileStream {
            case unsupportedFileType
            case unsupportedDataFormat
            case unsupportedProperty
            case badPropertySize
            case notOptimized
            case invalidPacketOffset
            case invalidFile
            case valueUnknown
            case dataUnavailable
            case illegalOperation
            case unspecifiedError
            case discontinuityCantRecover
        }
        
        case audioFileStream(AudioFileStream)
        
        public enum AudioGraph {
            case nodeNotFound
            case invalidConnection
            case outputNodeError
            case cannotDoInCurrentContext
            case invalidAudioUnit
        }
        
        case audioGraph(AudioGraph)
        
        public enum AudioFormat {
            case unspecified
            case unsupportedProperty
            case badPropertySize
            case badSpecifierSize
            case unsupportedDataFormat
            case unknownFormat
        }
        
        case audioFormat(AudioFormat)
        
        public enum AudioHardware {
            case notRunning
            case unspecified
            case unknownProperty
            case badPropertySize
            case illegalOperation
            case badObject
            case badDevice
            case badStream
            case unsupportedOperation
        }
        
        case audioHardware(AudioHardware)
        
        public enum AudioQueue {
            case invalidBuffer
            case bufferEmpty
            case disposalPending
            case invalidProperty
            case invalidPropertySize
            case invalidParameter
            case cannotStart
            case invalidDevice
            case bufferInQueue
            case invalidRunState
            case invalidQueueType
            case permissions
            case invalidPropertyValue
            case primeTimedOut
            case codecNotFound
            case invalidCodecAccess
            case queueInvalidated
            case tooManyTaps
            case invalidTapContext
            case recordUnderrun
            case invalidTapType
            case bufferEnqueuedTwice
            case cannotStartYet
            case enqueueDuringReset
            case invalidOfflineMode
        }
        
        case audioQueue(AudioQueue)
        
        public enum AudioUnit {
            case invalidProperty
            case invalidParameter
            case invalidElement
            case noConnection
            case failedInitialization
            case tooManyFramesToProcess
            case invalidFile
            case unknownFileType
            case fileNotSpecified
            case formatNotSupported
            case uninitialized
            case invalidScope
            case propertyNotWritable
            case cannotDoInCurrentContext
            case invalidPropertyValue
            case propertyNotInUse
            case initialized
            case invalidOfflineRender
            case unauthorized
            case renderTimeout
        }

        case audioUnit(AudioUnit)
        
        case unknown(status: OSStatus)
        
    }
    
    public let message: Message
    
    public let comment: String
    
    public init(_ message: Message, comment: String) {
        self.message = message
        self.comment = comment
    }
    
}

extension AudioError {
    
    public init(status: OSStatus, comment: String) {
        switch status {
        case kAudioComponentErr_InstanceInvalidated:
            self.init(.audioComponent(.instanceInvalidated), comment: comment)
        case kAudioConverterErr_FormatNotSupported:
            self.init(.audioConverter(.formatNotSupported), comment: comment)
        case kAudioConverterErr_OperationNotSupported:
            self.init(.audioConverter(.operationNotSupported), comment: comment)
        case kAudioConverterErr_PropertyNotSupported:
            self.init(.audioConverter(.propertyNotSupported), comment: comment)
        case kAudioConverterErr_InvalidInputSize:
            self.init(.audioConverter(.invalidInputSize), comment: comment)
        case kAudioConverterErr_InvalidOutputSize:
            self.init(.audioConverter(.invalidOutputSize), comment: comment)
        case kAudioConverterErr_UnspecifiedError:
            self.init(.audioConverter(.unspecifiedError), comment: comment)
        case kAudioConverterErr_BadPropertySizeError:
            self.init(.audioConverter(.badPropertySizeError), comment: comment)
        case kAudioConverterErr_RequiresPacketDescriptionsError:
            self.init(.audioConverter(.requiresPacketDescriptionsError), comment: comment)
        case kAudioConverterErr_InputSampleRateOutOfRange:
            self.init(.audioConverter(.inputSampleRateOutOfRange), comment: comment)
        case kAudioConverterErr_OutputSampleRateOutOfRange:
            self.init(.audioConverter(.outputSampleRateOutOfRange), comment: comment)
        case kAudioDeviceUnsupportedFormatError:
            self.init(.audioDevice(.unsupportedFormat), comment: comment)
        case kAudioDevicePermissionsError:
            self.init(.audioDevice(.permissions), comment: comment)
        case kAudioFileUnspecifiedError:
            self.init(.audioFile(.unspecified), comment: comment)
        case kAudioFileUnsupportedFileTypeError:
            self.init(.audioFile(.unsupportedFileType), comment: comment)
        case kAudioFileUnsupportedDataFormatError:
            self.init(.audioFile(.unsupportedDataFormat), comment: comment)
        case kAudioFileUnsupportedPropertyError:
            self.init(.audioFile(.unsupportedProperty), comment: comment)
        case kAudioFileBadPropertySizeError:
            self.init(.audioFile(.badPropertySize), comment: comment)
        case kAudioFilePermissionsError:
            self.init(.audioFile(.permissions), comment: comment)
        case kAudioFileNotOptimizedError:
            self.init(.audioFile(.notOptimized), comment: comment)
        case kAudioFileInvalidChunkError:
            self.init(.audioFile(.invalidChunk), comment: comment)
        case kAudioFileDoesNotAllow64BitDataSizeError:
            self.init(.audioFile(.doesNotAllow64BitDataSize), comment: comment)
        case kAudioFileInvalidPacketOffsetError:
            self.init(.audioFile(.invalidPacketOffset), comment: comment)
        case kAudioFileInvalidFileError:
            self.init(.audioFile(.invalidFile), comment: comment)
        case kAudioFileOperationNotSupportedError:
            self.init(.audioFile(.operationNotSupported), comment: comment)
        case kAudioFileNotOpenError:
            self.init(.audioFile(.notOpen), comment: comment)
        case kAudioFileEndOfFileError:
            self.init(.audioFile(.endOfFile), comment: comment)
        case kAudioFilePositionError:
            self.init(.audioFile(.position), comment: comment)
        case kAudioFileFileNotFoundError:
            self.init(.audioFile(.fileNotFound), comment: comment)
        case kAudioFileStreamError_UnsupportedFileType:
            self.init(.audioFileStream(.unsupportedFileType), comment: comment)
        case kAudioFileStreamError_UnsupportedDataFormat:
            self.init(.audioFileStream(.unsupportedDataFormat), comment: comment)
        case kAudioFileStreamError_UnsupportedProperty:
            self.init(.audioFileStream(.unsupportedProperty), comment: comment)
        case kAudioFileStreamError_BadPropertySize:
            self.init(.audioFileStream(.badPropertySize), comment: comment)
        case kAudioFileStreamError_NotOptimized:
            self.init(.audioFileStream(.notOptimized), comment: comment)
        case kAudioFileStreamError_InvalidPacketOffset:
            self.init(.audioFileStream(.invalidPacketOffset), comment: comment)
        case kAudioFileStreamError_InvalidFile:
            self.init(.audioFileStream(.invalidFile), comment: comment)
        case kAudioFileStreamError_ValueUnknown:
            self.init(.audioFileStream(.valueUnknown), comment: comment)
        case kAudioFileStreamError_DataUnavailable:
            self.init(.audioFileStream(.dataUnavailable), comment: comment)
        case kAudioFileStreamError_IllegalOperation:
            self.init(.audioFileStream(.illegalOperation), comment: comment)
        case kAudioFileStreamError_UnspecifiedError:
            self.init(.audioFileStream(.unspecifiedError), comment: comment)
        case kAudioFileStreamError_DiscontinuityCantRecover:
            self.init(.audioFileStream(.discontinuityCantRecover), comment: comment)
        case kAudioFormatUnspecifiedError:
            self.init(.audioFormat(.unspecified), comment: comment)
        case kAudioFormatUnsupportedPropertyError:
            self.init(.audioFormat(.unsupportedProperty), comment: comment)
        case kAudioFormatBadPropertySizeError:
            self.init(.audioFormat(.badPropertySize), comment: comment)
        case kAudioFormatBadSpecifierSizeError:
            self.init(.audioFormat(.badSpecifierSize), comment: comment)
        case kAudioFormatUnsupportedDataFormatError:
            self.init(.audioFormat(.unsupportedDataFormat), comment: comment)
        case kAudioFormatUnknownFormatError:
            self.init(.audioFormat(.unknownFormat), comment: comment)
        case kAUGraphErr_NodeNotFound:
            self.init(.audioGraph(.nodeNotFound), comment: comment)
        case kAUGraphErr_InvalidConnection:
            self.init(.audioGraph(.invalidConnection), comment: comment)
        case kAUGraphErr_OutputNodeErr:
            self.init(.audioGraph(.outputNodeError), comment: comment)
        case kAUGraphErr_CannotDoInCurrentContext:
            self.init(.audioGraph(.cannotDoInCurrentContext), comment: comment)
        case kAUGraphErr_InvalidAudioUnit:
            self.init(.audioGraph(.invalidAudioUnit), comment: comment)
        case kAudioHardwareNotRunningError:
            self.init(.audioHardware(.notRunning), comment: comment)
        case kAudioHardwareUnspecifiedError:
            self.init(.audioHardware(.unspecified), comment: comment)
        case kAudioHardwareUnknownPropertyError:
            self.init(.audioHardware(.unknownProperty), comment: comment)
        case kAudioHardwareBadPropertySizeError:
            self.init(.audioHardware(.badPropertySize), comment: comment)
        case kAudioHardwareIllegalOperationError:
            self.init(.audioHardware(.illegalOperation), comment: comment)
        case kAudioHardwareBadObjectError:
            self.init(.audioHardware(.badObject), comment: comment)
        case kAudioHardwareBadDeviceError:
            self.init(.audioHardware(.badDevice), comment: comment)
        case kAudioHardwareBadStreamError:
            self.init(.audioHardware(.badStream), comment: comment)
        case kAudioHardwareUnsupportedOperationError:
            self.init(.audioHardware(.unsupportedOperation), comment: comment)
        case kAudioQueueErr_InvalidBuffer:
            self.init(.audioQueue(.invalidBuffer), comment: comment)
        case kAudioQueueErr_BufferEmpty:
            self.init(.audioQueue(.bufferEmpty), comment: comment)
        case kAudioQueueErr_DisposalPending:
            self.init(.audioQueue(.disposalPending), comment: comment)
        case kAudioQueueErr_InvalidProperty:
            self.init(.audioQueue(.invalidProperty), comment: comment)
        case kAudioQueueErr_InvalidPropertySize:
            self.init(.audioQueue(.invalidPropertySize), comment: comment)
        case kAudioQueueErr_InvalidParameter:
            self.init(.audioQueue(.invalidParameter), comment: comment)
        case kAudioQueueErr_CannotStart:
            self.init(.audioQueue(.cannotStart), comment: comment)
        case kAudioQueueErr_InvalidDevice:
            self.init(.audioQueue(.invalidDevice), comment: comment)
        case kAudioQueueErr_BufferInQueue:
            self.init(.audioQueue(.bufferInQueue), comment: comment)
        case kAudioQueueErr_InvalidRunState:
            self.init(.audioQueue(.invalidRunState), comment: comment)
        case kAudioQueueErr_InvalidQueueType:
            self.init(.audioQueue(.invalidQueueType), comment: comment)
        case kAudioQueueErr_Permissions:
            self.init(.audioQueue(.permissions), comment: comment)
        case kAudioQueueErr_InvalidPropertyValue:
            self.init(.audioQueue(.invalidPropertyValue), comment: comment)
        case kAudioQueueErr_PrimeTimedOut:
            self.init(.audioQueue(.primeTimedOut), comment: comment)
        case kAudioQueueErr_CodecNotFound:
            self.init(.audioQueue(.codecNotFound), comment: comment)
        case kAudioQueueErr_InvalidCodecAccess:
            self.init(.audioQueue(.invalidCodecAccess), comment: comment)
        case kAudioQueueErr_QueueInvalidated:
            self.init(.audioQueue(.queueInvalidated), comment: comment)
        case kAudioQueueErr_TooManyTaps:
            self.init(.audioQueue(.tooManyTaps), comment: comment)
        case kAudioQueueErr_InvalidTapContext:
            self.init(.audioQueue(.invalidTapContext), comment: comment)
        case kAudioQueueErr_RecordUnderrun:
            self.init(.audioQueue(.recordUnderrun), comment: comment)
        case kAudioQueueErr_InvalidTapType:
            self.init(.audioQueue(.invalidTapType), comment: comment)
        case kAudioQueueErr_BufferEnqueuedTwice:
            self.init(.audioQueue(.bufferEnqueuedTwice), comment: comment)
        case kAudioQueueErr_CannotStartYet:
            self.init(.audioQueue(.cannotStartYet), comment: comment)
        case kAudioQueueErr_EnqueueDuringReset:
            self.init(.audioQueue(.enqueueDuringReset), comment: comment)
        case kAudioQueueErr_InvalidOfflineMode:
            self.init(.audioQueue(.invalidOfflineMode), comment: comment)
        case kAudioUnitErr_InvalidProperty:
            self.init(.audioUnit(.invalidProperty), comment: comment)
        case kAudioUnitErr_InvalidParameter:
            self.init(.audioUnit(.invalidParameter), comment: comment)
        case kAudioUnitErr_InvalidElement:
            self.init(.audioUnit(.invalidElement), comment: comment)
        case kAudioUnitErr_NoConnection:
            self.init(.audioUnit(.noConnection), comment: comment)
        case kAudioUnitErr_FailedInitialization:
            self.init(.audioUnit(.failedInitialization), comment: comment)
        case kAudioUnitErr_TooManyFramesToProcess:
            self.init(.audioUnit(.tooManyFramesToProcess), comment: comment)
        case kAudioUnitErr_InvalidFile:
            self.init(.audioUnit(.invalidFile), comment: comment)
        case kAudioUnitErr_UnknownFileType:
            self.init(.audioUnit(.unknownFileType), comment: comment)
        case kAudioUnitErr_FileNotSpecified:
            self.init(.audioUnit(.fileNotSpecified), comment: comment)
        case kAudioUnitErr_FormatNotSupported:
            self.init(.audioUnit(.formatNotSupported), comment: comment)
        case kAudioUnitErr_Uninitialized:
            self.init(.audioUnit(.uninitialized), comment: comment)
        case kAudioUnitErr_InvalidScope:
            self.init(.audioUnit(.invalidScope), comment: comment)
        case kAudioUnitErr_PropertyNotWritable:
            self.init(.audioUnit(.propertyNotWritable), comment: comment)
        case kAudioUnitErr_CannotDoInCurrentContext:
            self.init(.audioUnit(.cannotDoInCurrentContext), comment: comment)
        case kAudioUnitErr_InvalidPropertyValue:
            self.init(.audioUnit(.invalidPropertyValue), comment: comment)
        case kAudioUnitErr_PropertyNotInUse:
            self.init(.audioUnit(.propertyNotInUse), comment: comment)
        case kAudioUnitErr_Initialized:
            self.init(.audioUnit(.initialized), comment: comment)
        case kAudioUnitErr_InvalidOfflineRender:
            self.init(.audioUnit(.invalidOfflineRender), comment: comment)
        case kAudioUnitErr_Unauthorized:
            self.init(.audioUnit(.unauthorized), comment: comment)
        case kAudioUnitErr_RenderTimeout:
            self.init(.audioUnit(.renderTimeout), comment: comment)
        default:
            self.init(.unknown(status: status), comment: comment)
        }
    }
    
}

extension AudioError: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "AudioError(message: \(message), comment: \(comment))"
    }
    
}

extension OSStatus {
    
    public func audioError(_ comment: String) throws {
        if self != noErr {
            throw AudioError(status: self, comment: comment)
        }
    }
    
}
