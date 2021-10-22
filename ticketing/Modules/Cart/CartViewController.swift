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

    private var subTotalView: CartSummaryView?
    lazy var cartManager: CartManager = CartManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(title: "Cart")
        self.configureTableView()
        self.addSubContentView(self.stackView)
        self.stackView.fitToSuperView()

        self.stackView.addArrangedSubview(self.createBackButtonView())
        self.stackView.addArrangedSubview(self.createTitleView())
        self.stackView.addArrangedSubview(self.createSpaceView())
        self.stackView.addArrangedSubview(self.tableView)
        self.stackView.addArrangedSubview(self.createSpaceView())
        self.stackView.addArrangedSubview(self.createSubTotalView())
        self.cartManager.registerChange { [weak self] in
            self?.tableView.reloadData()
            self?.subTotalView?.updatePrice()
        }
    }

    private func configureTableView() {
        self.tableView.register(UINib(nibName: "\(CartItemTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(CartItemTableViewCell.self)")
        self.tableView.backgroundColor = .white
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.tableView.separatorColor = ColorPalette.grayu
        self.tableView.rowHeight = 109
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension CartViewController: UITableViewDelegate,
                              UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cartManager.items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CartItemTableViewCell.self)", for: indexPath) as? CartItemTableViewCell else { return .init()}
        cell.configureData(item: cartManager.items[indexPath.row])
        cell.selectionStyle = .none
        cell.removeItemAction = { item in
            self.showPopup(with: item)
        }
        return cell
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
            guard self.cartManager.items.isEmpty == false else { return }
            self.navigator.show(segue: .checkoutSuccess, sender: self, transition: .push)
        }
        self.subTotalView = view
        return view
    }

    private func createSpaceView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = ColorPalette.grayu
        return view
    }

    private func createBackButtonView() -> UIView {
        let view = UIView()
        view.addSubview(self.backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        self.backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        self.backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }

    private func showPopup(with item: Item) {
        let view = UIView()
        self.addSubContentView(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fitToSuperView()
        view.backgroundColor = .clear
        if let popupView = PopupView.instance {
            view.addSubview(popupView)
            popupView.translatesAutoresizingMaskIntoConstraints = false
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            popupView.removeAction = {
                CartManager.shared.removeFromCart(with: item.ticket)
                view.removeFromSuperview()
            }
            popupView.cancelAction = {
                view.removeFromSuperview()
            }
        }
    }
}
