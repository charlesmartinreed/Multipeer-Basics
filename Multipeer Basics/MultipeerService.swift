//
//  MultipeerService.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/20/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MultipeerServiceDelegate {
    func setupMCPeering(for user: User)
}

class MultipeerService: NSObject {
    
    static let sharedInstance = MultipeerService()

    var delegate: MultipeerServiceDelegate?
    
    var currentUserIsHosting = false
    var peerId: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertisingAssistant: MCAdvertiserAssistant!
    var mcBrowser: MCBrowserViewController!
    
    override init() {
        super.init()
        
    }
    
    func setupMCPeering(for user: User) {
        peerId = MCPeerID(displayName: user.name ?? UIDevice.current.name)
        mcSession = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        if currentUserIsHosting {
            setupPeerHosting()
        } else {
            setupPeerJoining()
        }
    }
    
    func setupPeerHosting() {
        mcAdvertisingAssistant = MCAdvertiserAssistant(serviceType: "test-mc", discoveryInfo: nil, session: self.mcSession)
        mcAdvertisingAssistant.start()
        currentUserIsHosting = true
        
        //transition to chatVC
        
    }
    
    func setupPeerJoining() {
        mcBrowser = MCBrowserViewController(serviceType: "test-mc", session: self.mcSession)
        mcBrowser.delegate = self
        
        //self.present(mcBrowser, animated: true, completion: nil)
    }
    
//
//    private let peerId: MCPeerID?
//    private let mcSession: MCSession?
//    private let mcAdvertiserAssistant: MCAdvertiserAssistant?
//    private let deviceName = UIDevice.current.name
//    private let currentUser: User?
//
//
//    func hostSession() {
//
//    }
}

extension MultipeerService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

extension MultipeerService: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    
}
