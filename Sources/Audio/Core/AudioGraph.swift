//
//  AudioGraph.swift
//  Gong
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

public class AudioGraph {
    
    public let reference: AUGraph
    
    public init(_ reference: AUGraph) {
        self.reference = reference
    }
    
    public convenience init() throws {
        var reference: AUGraph? = nil
        try NewAUGraph(&reference).audioError("Creating AudioGraph")
        self.init(reference!)
    }
    
    public func dispose() throws {
        try DisposeAUGraph(reference).audioError("Disposing AudioGraph")
    }
    
}

extension AudioGraph {
    
    public class Node {
        
        public let reference: AUNode
        
        public init(_ reference: AUNode) {
            self.reference = reference
        }
        
    }
    
    public func addNode(with description: AudioComponentDescription) throws -> Node {
        var description = description
        var nodeReference: AUNode = 0
        try AUGraphAddNode(reference, &description, &nodeReference).audioError("Adding node to AudioGraph")
        return Node(nodeReference)
    }
    
    public func removeNode(_ node: Node) throws {
        try AUGraphRemoveNode(reference, node.reference).audioError("Removing node from AudioGraph")
    }
    
    public func info(for node: Node) throws -> (audioUnit: AudioUnit, description: AudioComponentDescription) {
        var audioUnitReference: AudioToolbox.AudioUnit? = nil
        var description = AudioComponentDescription()
        try AUGraphNodeInfo(reference, node.reference, &description, &audioUnitReference).audioError("Getting AudioGraph node info")
        return (audioUnit: AudioUnit(audioUnitReference!), description: description)
    }
    
    public func numberOfNodes() throws -> UInt32 {
        var numberOfNodes: UInt32 = 0
        try AUGraphGetNodeCount(reference, &numberOfNodes).audioError("Getting AudioGraph number of nodes")
        return numberOfNodes
    }
    
    public func node(at index: UInt32) throws -> Node {
        var nodeReference: AUNode = 0
        try AUGraphGetIndNode(reference, index, &nodeReference).audioError("Getting AudioGraph node at index")
        return Node(nodeReference)
    }
    
}

extension AudioGraph {
    
    public func addSubGraph() throws -> Node {
        var nodeReference: AUNode = 0
        try AUGraphNewNodeSubGraph(reference, &nodeReference).audioError("Adding subgraph to AudioGraph")
        return Node(nodeReference)
    }
    
    public func subGraph(for node: Node) throws -> AudioGraph {
        var graphReference: AUGraph? = nil
        try AUGraphGetNodeInfoSubGraph(reference, node.reference, &graphReference).audioError("Getting AudioGraph node subgraph")
        return AudioGraph(graphReference!)
    }
    
    public func isSubGraph(_ node: Node) throws -> Bool {
        var isSubGraph: DarwinBoolean = false
        AUGraphIsNodeSubGraph(reference, node.reference, &isSubGraph)
        return isSubGraph.boolValue
    }
    
}

extension AudioGraph {
    
    public func connect(_ source: Node, output: UInt32 = 0, to destination: Node, input: UInt32 = 0) throws {
        try AUGraphConnectNodeInput(reference, source.reference, output, destination.reference, input).audioError("Connecting nodes on AudioGraph")
    }
    
    public func disconnect(_ destination: Node, input: UInt32 = 0) throws {
        try AUGraphDisconnectNodeInput(reference, destination.reference, input).audioError("Disconnecting node from AudioGraph")
    }
    
    public func setNodeInputCallback(for destination: Node, input: UInt32 = 0, callback: AURenderCallbackStruct) throws {
        var callback = callback
        try AUGraphSetNodeInputCallback(reference, destination.reference, input, &callback).audioError("Setting AudioGraph node input callback")
    }
    
    public func clearConnections() throws {
        try AUGraphClearConnections(reference).audioError("Clearing AudioGraph connections")
    }
    
}

extension AudioGraph {
    
    public func numberOfInteractions() throws -> UInt32 {
        var numberOfInteractions: UInt32 = 0
        try AUGraphGetNumberOfInteractions(reference, &numberOfInteractions).audioError("Getting AudioGraph number of interactions")
        return numberOfInteractions
    }
    
    public func numberOfInteractions(for node: Node) throws -> UInt32 {
        var numberOfInteractions: UInt32 = 0
        try AUGraphCountNodeInteractions(reference, node.reference, &numberOfInteractions).audioError("Getting AudioGraph number of interactions for node")
        return numberOfInteractions
    }
    
    public func interaction(at index: UInt32) throws -> AUNodeInteraction {
        var interaction = AUNodeInteraction()
        try AUGraphGetInteractionInfo(reference, index, &interaction).audioError("Getting AudioGraph interaction at index")
        return interaction
    }
    
    // TODO: Test me
    
    public func interactions(for node: Node, count: UInt32) throws -> [AUNodeInteraction] {
        var count = count
        let interactions = UnsafeMutablePointer<AUNodeInteraction>.allocate(capacity: Int(count))
        defer {
            interactions.deallocate(capacity: Int(count))
        }
        try AUGraphGetNodeInteractions(reference, node.reference, &count, interactions).audioError("Getting AudioGraph node interactions")
        return (0..<Int(count)).map { index in
            return interactions[index]
        }
    }
    
}

extension AudioGraph {
    
    @discardableResult public func update() throws -> Bool {
        var isUpdated: DarwinBoolean = false
        try AUGraphUpdate(reference, &isUpdated).audioError("Updating AudioGraph")
        return isUpdated.boolValue
    }
    
}

extension AudioGraph {
    
    public func open() throws {
        try AUGraphOpen(reference).audioError("Opening AudioGraph")
    }
    
    public func close() throws {
        try AUGraphClose(reference).audioError("Closing AudioGraph")
    }
    
    public func initialize() throws {
        try AUGraphInitialize(reference).audioError("Initializing AudioGraph")
    }
    
    public func uninitialize() throws {
        try AUGraphUninitialize(reference).audioError("Uninitializing AudioGraph")
    }
    
    public func start() throws {
        try AUGraphStart(reference).audioError("Starting AudioGraph")
    }
    
    public func stop() throws {
        try AUGraphStop(reference).audioError("Stopping AudioGraph")
    }
    
}

extension AudioGraph {
    
    public func isOpen() throws -> Bool {
        var isOpen: DarwinBoolean = false
        try AUGraphIsOpen(reference, &isOpen).audioError("Getting AudioGraph open")
        return isOpen.boolValue
    }
    
    public func isInitialized() throws -> Bool {
        var isInitialized: DarwinBoolean = false
        try AUGraphIsInitialized(reference, &isInitialized).audioError("Getting AudioGraph initialized")
        return isInitialized.boolValue
        
    }
    
    public func isRunning() throws -> Bool {
        var isRunning: DarwinBoolean = false
        try AUGraphIsRunning(reference, &isRunning).audioError("Getting AudioGraph running")
        return isRunning.boolValue
    }
    
}

extension AudioGraph {
    
    public func currentCPULoad() throws -> Float32 {
        var cpuLoad: Float32 = 0.0
        try AUGraphGetCPULoad(reference, &cpuLoad).audioError("Getting AudioGraph current CPU load")
        return cpuLoad
    }
    
    public func maximumCPULoad() throws -> Float32 {
        var cpuLoad: Float32 = 0.0
        try AUGraphGetMaxCPULoad(reference, &cpuLoad).audioError("Getting AudioGraph maximum CPU load")
        return cpuLoad
    }
    
}

extension AudioGraph {
    
    public class RenderCallback {
        
        public typealias Callback = () -> OSStatus
        
        fileprivate let callback: AURenderCallback
        
        fileprivate let referenceContext: UnsafeMutablePointer<Callback>
        
        public init(_ callback: @escaping Callback) {
            self.callback = { (referenceContext, actionFlags, timeStamp, bus, numberOfFrames, bufferList) in
                guard let callback: Callback = referenceContext.unwrap() else {
                    return noErr
                }
                
                return callback()
            }
            
            self.referenceContext = UnsafeMutablePointer.wrap(callback)
        }
        
    }
    
    func add(renderCallback: RenderCallback) throws {
        try AUGraphAddRenderNotify(reference, renderCallback.callback, renderCallback.referenceContext).audioError("Adding render callback to AudioGraph")
    }
    
    func remove(renderCallback: RenderCallback) throws {
        try AUGraphRemoveRenderNotify(reference, renderCallback.callback, renderCallback.referenceContext).audioError("Removing render callback from AudioGraph")
    }
    
}
