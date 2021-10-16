//
//  HomeViewController.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation
import UIKit

final class HomeViewController: ViewController {

    class func instance(navigator: Navigator) -> ViewController {
        let vc = HomeViewController()
        vc.navigator = navigator
        return vc
    }

    private lazy var viewModel = HomeViewModel()
}
