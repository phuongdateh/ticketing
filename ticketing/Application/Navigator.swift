//
//  Navigator.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation
import UIKit

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()

    // MARK: - segues list, all app scenes
    enum Scene {
        case homeViewController
        case ticketDetail(ticketId: Int)
        case cart
    }
    
    enum Transition {
        case root(in: UIWindow)
        case push
    }
}

extension Navigator {
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .homeViewController:
            return HomeViewController.instance(navigator: self)
        case .ticketDetail(ticketId: let id):
            return TicketDetailViewController.instance(navigator: self,
                                                       ticketId: id)
        case .cart:
            return CartViewController.instance(navigator: self)
        }
    }
    
    func show(segue: Scene, sender: UIViewController?, transition: Transition) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            let navigationController = UINavigationController(rootViewController: target)
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = navigationController
            }, completion: nil)
            return
        case .push:
            if let navitaionController = sender?.navigationController {
                navitaionController.pushViewController(target, animated: true)
            }
        }
    }
}

