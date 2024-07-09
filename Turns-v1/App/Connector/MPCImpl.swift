//
//  MPCImpl.swift
//  MultipeerChat
//
//  Created by dave on 04/07/24.
//

import MultipeerConnectivity
import os

@Observable class MPCImpl: NSObject {
    
    private let serviceType = "mpc-service"
    
    public let serviceAdvertiser: MCNearbyServiceAdvertiser
    public let serviceBrowser: MCNearbyServiceBrowser
    public let session: MCSession
    
    var viewModel: ViewModel
    
    private let log = Logger()
    
    var myPeerID: MCPeerID
    var availablePeers: [MCPeerID] = []
    var recvdInvite: Bool = false
    var recvdInviteFrom: MCPeerID? = nil
    var paired: Bool = false
    var username: String = ""
    var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    init(username: String, viewModel: ViewModel) {
        let peerID = MCPeerID(displayName: username)
        self.viewModel = viewModel
        self.username = username
        self.myPeerID = peerID
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
                
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func send() {
        if !session.connectedPeers.isEmpty {
            log.info("sendState: \(String(describing: self.viewModel.currentState)) to \(self.session.connectedPeers[0].displayName)")
            do {
                //try session.send(state.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
                try session.send(
                    //state.data(using: .utf8)!,
                    GameState.encodeJSON(state: self.viewModel.currentState).data(using: .utf8)!,
                    toPeers: session.connectedPeers,
                    with: .reliable
                )
            } catch {
                log.error("Error sending: \(String(describing: error))")
            }
        }
    }
}

extension MPCImpl: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        
        DispatchQueue.main.async {
            self.recvdInvite = true
            self.recvdInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
}

extension MPCImpl: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBroser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        DispatchQueue.main.async {
            print("Append new peer: \(peerID)")
            self.availablePeers.append(peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
        DispatchQueue.main.async {
            self.availablePeers.removeAll(where: {
                $0 == peerID
            })
        }
    }
}

extension MPCImpl: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        
        switch state {
        case MCSessionState.notConnected:
            DispatchQueue.main.async {
                self.paired = false
            }
            serviceAdvertiser.startAdvertisingPeer()
            break
        case MCSessionState.connected:
            DispatchQueue.main.async {
                self.paired = true
            }
            serviceAdvertiser.stopAdvertisingPeer()
            break
        default:
            DispatchQueue.main.async {
                self.paired = false
            }
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let dataString = String(data: data, encoding: .utf8) {
            log.info("didReceive state \(dataString)")
            
            DispatchQueue.main.async {
                //self.receivedState = dataString
                //self.receivedState = GameState.decodeJSON(json: dataString)
                self.viewModel.currentState = GameState.decodeJSON(json: dataString)
            }
        } else {
            log.info("didReceive invalid value \(data.count) bytes")
        }
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
    
    public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
}
