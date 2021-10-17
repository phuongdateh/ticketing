//
//  Application.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation
import UIKit

final class Application {
    static let `default` = Application()
    var window: UIWindow?
    private let navigator: Navigator

    init() {
        self.navigator = Navigator.default
    }

    func presentView(with window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        self.window?.rootViewController = UINavigationController(rootViewController: HomeViewController.instance(navigator: self.navigator))
    }
}
