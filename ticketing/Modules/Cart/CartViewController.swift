//
//  CartViewController.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 20/10/2021.
//

import Foundation
import UIKit

final class CartViewController: ViewController {
    class func instance(navigator: Navigator) -> ViewController {
        let vc = CartViewController()
        vc.navigator = navigator
        vc.view.backgroundColor = .white
        return vc
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .plain)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubContentView(self.stackView)
        self.stackView.fitToSuperView()

        self.stackView.addArrangedSubview(self.createTitleView())
        self.stackView.addArrangedSubview(self.tableView)
        self.stackView.addArrangedSubview(self.createSpaceView())
        self.stackView.addArrangedSubview(self.createSubTotalView())
    }
}

extension CartViewController {
    private func createTitleView() -> UIView {
        let view = UIView()
        let title = UILabel()
        title.text = "Admissions"
        title.font = .interBold(size: 15)
        title.textColor = ColorPalette.black
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            title.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -14),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        return view
    }

    private func createSubTotalView() -> UIView {
        guard let view = CartSummaryView.instance as? CartSummaryView else { return .init()}
        view.didTapConfirmButton = {
            
        }
        return view
    }

    private func createSpaceView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = ColorPalette.grayu
        return view
    }
}
