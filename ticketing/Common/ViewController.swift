//
//  ViewController.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 15/10/2021.
//

import UIKit

class ViewController: UIViewController {

    var headerView: TopHeaderView!
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.mainStackView)
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mainStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.mainStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        self.configureTopHeaderView()
        self.addArrangedSubviews()
    }

    private func addArrangedSubviews() {
        self.mainStackView.addArrangedSubview(self.headerView)
        self.mainStackView.addArrangedSubview(self.contentView)
    }

}

extension ViewController {
    func configureTopHeaderView() {
        guard let view = UINib(nibName: "\(TopHeaderView.self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as? TopHeaderView
        else { return }
        self.headerView = view
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
