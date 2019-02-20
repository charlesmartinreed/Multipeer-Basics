//
//  Message.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/19/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class Message: NSObject {
    var contents: String
    var sender: String
    
    init(sender: String, contents: String) {
        self.sender = sender
        self.contents = contents
    }
}
