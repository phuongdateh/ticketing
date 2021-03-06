//
//  SceneDelegate.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 15/10/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        Application.default.presentView(with: window)
    }
}

