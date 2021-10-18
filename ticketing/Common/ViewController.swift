//
//  ViewController.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 15/10/2021.
//

import UIKit

class ViewController: UIViewController {

    var navigator: Navigator!
    var headerView: TopHeaderView!
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var mainStackView: UIStackView = {
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

    func addBackButtonView() {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "back_ic"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backAction),
                         for: .touchUpInside)
        self.contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 36),
            button.widthAnchor.constraint(equalToConstant: 36),
            button.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 17),
            button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17)
        ])
        self.contentView.bringSubviewToFront(button)
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
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

    func addSubContentView(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(subView)
        subView.fitToSuperView()
    }

    func showCalendarView() {
        guard let calendarView = UINib(nibName: "\(CalendarWrapperView.self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as? CalendarWrapperView else { return }
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.858, green: 0.858, blue: 0.858, alpha: 0.86)
        self.contentView.addSubview(view)
        view.fitToSuperView()
        view.addSubview(calendarView)
        calendarView.layer.cornerRadius = 10
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true

        calendarView.closeAction = {
            view.removeFromSuperview()
        }
    }
}
