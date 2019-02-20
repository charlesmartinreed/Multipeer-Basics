//
//  User.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/19/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct User {
    var name: String?
    var photo: UIImage?
    var peerID: MCPeerID?
    
    init(name: String?, photo: UIImage?, peerID: MCPeerID?) {
        self.name = name
        self.photo = photo
        self.peerID = peerID
    }
}
