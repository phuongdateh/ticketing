//
//  CheckoutSuccessViewController.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 22/10/2021.
//

import Foundation
import UIKit

class CheckoutSuccessViewController: UIViewController {
    static var instance: UIViewController {
        return UIStoryboard(name: "CheckoutSuccess", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckoutSuccessViewController")
    }

    @IBOutlet weak var backToHomeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backToHomeButton.layer.cornerRadius = 4
        self.backToHomeButton.addTarget(self, action: #selector(backToHomeTouchUpInside), for: .touchUpInside)

        CartManager.shared.reset()
    }

    @objc private func backToHomeTouchUpInside() {
        guard let navigationController = navigationController else { return }
        let viewControllers = navigationController.viewControllers
        if let vc = viewControllers.first(where: { vc in
            if vc is HomeViewController {
                return true
            }
            return false
        }) {
            navigationController.popToViewController(vc, animated: true)
        }
    }
}
