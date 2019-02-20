//
//  MainCoordinator.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/20/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LandingVC()
        vc.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func moveToChat() {
//        let child = ChatCoordinator(navigationController: navigationController)
//        child.parentCoordinator = self
//        childCoordinators.append(child)
//        child.start()
        let vc = ChatVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    //MARK:- Navigation
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        //called by delegate when VC has been shown
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        //if vc array already has fromVC, dealing with a push from another VC
        if navigationController.viewControllers.contains(fromVC) {
             return
        }
        
        if let chatVC = fromVC as? ChatVC {
            childDidFinish(chatVC.coordinator!)
        }
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            //identity operator, check if two class instances point to the same memory, i.e, if they are the same objec
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
