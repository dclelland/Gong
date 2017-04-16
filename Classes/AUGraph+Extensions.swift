//
//  AUGraph+Extensions.swift
//  Hibiscus
//
//  Created by Daniel Clelland on 15/04/17.
//  Copyright © 2017 Daniel Clelland. All rights reserved.
//

import Foundation
import AudioToolbox

extension AUGraph {
    
    init() throws {
        var graph: AUGraph? = nil
        try NewAUGraph(&graph).check("Creating AUGraph")
        self = graph!
    }
    
    func start() throws {
        try AUGraphStart(self).check("Starting AUGraph")
    }
    
    func open() throws {
        try AUGraphOpen(self).check("Opening AUGraph")
    }
    
    func initialize() throws {
        try AUGraphInitialize(self).check("Initializing AUGraph")
    }
    
    func addNode(with description: AudioComponentDescription) throws -> AUNode {
        var description = description
        var node: AUNode = 0
        try AUGraphAddNode(self, &description, &node).check("Adding node to AUGraph")
        return node
    }
    
    func connect(_ source: AUNode, output: UInt32 = 0, to destination: AUNode, input: UInt32 = 0) throws {
        try AUGraphConnectNodeInput(self, source, output, destination, input).check("Connecting nodes on AUGraph")
    }
    
    func description(for node: AUNode) throws -> AudioComponentDescription {
        var description = AudioComponentDescription()
        try AUGraphNodeInfo(self, node, &description, nil).check("Getting node description from AUGraph")
        return description
    }
    
    func audioUnit(for node: AUNode) throws -> AudioUnit {
        var audioUnit: AudioUnit? = nil
        try AUGraphNodeInfo(self, node, nil, &audioUnit).check("Getting node audio unit from AUGraph")
        return audioUnit!
    }
    
}
