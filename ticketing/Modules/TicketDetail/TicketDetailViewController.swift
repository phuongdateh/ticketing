//
//  TicketDetailViewController.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 17/10/2021.
//

import Foundation
import UIKit

final class TicketDetailViewController: ViewController {

    class func instance(navigator: Navigator,
                        ticketId: Int) -> ViewController {
        let vc = TicketDetailViewController()
        vc.navigator = navigator
        vc.view.backgroundColor = .white
        vc.viewModel = TicketDetailViewModel(ticketId: ticketId)
        return vc
    }

    private var viewModel: TicketDetailViewModel!

    private let scrollView = UIScrollView()
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var addToCartView: UIView = {
        return self.createAddToCartButtonView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle(title: "Ticket Details")
        self.addToCartView.isUserInteractionEnabled = true
        self.addSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard self.viewModel.shouldFetchData() else { return }
        self.willFetchData()
    }

    private func willFetchData() {
        self.viewModel.retrieveTicketDetail(success: { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.addArrangedSubviews()
            }
        }, failure: {
            
        })
    }

    private func addSubviews() {
        self.addSubContentView(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        self.stackView.fitToSuperView()
        self.addBackButtonView()
    }

    private func addArrangedSubviews() {
        guard let ticket = viewModel.ticket else { return }
        self.stackView.addArrangedSubview(self.createTopImageView())
        self.stackView.addArrangedSubview(self.createSeparateView(height: 40))
        self.stackView.addArrangedSubview(self.createLabel(text: ticket.title ?? "",
                                                           font: .interBold(size: 18)))
        self.stackView.addArrangedSubview(self.createSeparateView(height: 13))
        if ticket.price == 0 {
            self.stackView.addArrangedSubview(self.createLabel(text: "Free",
                                                               font: .interRegular(size: 16)))
        } else {
            self.stackView.addArrangedSubview(self.createLabel(text: "$ \(ticket.price)",
                                                               font: .interRegular(size: 16)))
        }
        self.stackView.addArrangedSubview(self.createSeparateView(height: 13))
        self.stackView.addArrangedSubview(self.createLabel(text: "Description",
                                                           font: .interRegular(size: 12)))
        self.stackView.addArrangedSubview(self.createSeparateView(height: 13))
        self.stackView.addArrangedSubview(self.createLabel(text: ticket.description ?? "",
                                                           font: .interRegular(size: 11)))
        self.stackView.addArrangedSubview(self.createSeparateView(height: 25))
        self.stackView.addArrangedSubview(self.addToCartView)
        self.addToCartView.isHidden = CartManager.shared.isExit(ticket: ticket)
    }
}

extension TicketDetailViewController {
    func createTopImageView() -> UIView {
        let imageView = UIImageView(image: UIImage(named: "mock_image"))
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return imageView
    }

    func createLabel(text: String,
                     font: UIFont?) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = text
        label.textColor = ColorPalette.black
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.fitToSuperView(top: 0, leading: 20, trailing: -20, bottom: 0)
        label.numberOfLines = 0
        return view
    }

    func createSeparateView(height: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }

    func createAddToCartButtonView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        let viewButton = UIView()
        viewButton.backgroundColor = ColorPalette.background
        let title = UILabel()
        title.text = "Add To Cart"
        title.font = .interBold(size: 16)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        viewButton.addSubview(title)
        viewButton.layer.cornerRadius = 4
        viewButton.isUserInteractionEnabled = true
        viewButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(addToCartAction)))
        title.fitToSuperView(top: 10,
                             leading: 20,
                             trailing: -20,
                             bottom: -10)
        view.addSubview(viewButton)
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        viewButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                             constant: -20).isActive = true
        return view
    }

    @objc private func addToCartAction() {
        print(#function)
        self.showCalendarView()
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
        calendarView.didSelectDay = { day in
            guard let ticket = self.viewModel.ticket, let day = day else { return }
            CartManager.shared.dateOfVisit = "\(day)"
            self.showItemView(with: ticket)
        }
    }

    func showItemView(with ticket: Ticket) {
        guard let itemView = UINib(nibName: "\(ItemView.self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ItemView else { return }
        itemView.ticket = self.viewModel.ticket
        itemView.renderItemView()
        itemView.addToCartButton.alpha = CartManager.shared.isExit(ticket: itemView.ticket) ? 0 : 1

        let view = UIView()
        view.backgroundColor = UIColor(red: 0.858, green: 0.858, blue: 0.858, alpha: 0.86)
        self.contentView.addSubview(view)
        view.fitToSuperView()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        stackView.addArrangedSubview(itemView)
        itemView.closeAction = {
            view.removeFromSuperview()
        }
        itemView.addToCartButtonAction = {
            self.addToCartView.alpha = 0
            self.addToCartView.isUserInteractionEnabled = false
        }
    }
}
