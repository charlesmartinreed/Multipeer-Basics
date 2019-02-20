//
//  Coordinator.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/20/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
