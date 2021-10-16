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
    private var apiService: TicketApi?
    
    init() {
        self.apiService = TicketAPIService()
    }
    
    func presentView(with window: UIWindow?) {
        guard let window = window,
        let apiService = apiService else {
            return
        }
        self.window = window
        let navigationController = UINavigationController(rootViewController: ViewController())
        self.window?.rootViewController = navigationController
    }
}
