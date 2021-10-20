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
        vc.view.backgroundColor = .white
        return vc
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return collectionView
    }()

    private lazy var ticketsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private lazy var viewModel = HomeViewModel()
    private var selectedCategoryId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutViews()
        self.addArrangedSubviews()
        self.configureCategoryCollectionView()
        self.configureTicketsCollectionView()
        self.bindingViewModel()
    }

    private func bindingViewModel() {
        self.viewModel.didFetchData = {[weak self] in
            self?.updateViews()
        }

        self.viewModel.didFailure = { error in
            
        }
    }
    
    private func updateViews() {
        DispatchQueue.main.async { [weak self] in
            self?.categoryCollectionView.reloadData()
            self?.ticketsCollectionView.reloadData()
        }
    }

    private func layoutViews() {
        self.contentView.addSubview(self.stackView)
        self.stackView.fitToSuperView()
    }

    private func addArrangedSubviews() {
        self.stackView.addArrangedSubview(self.createTitleView())
        self.stackView.addArrangedSubview(self.categoryCollectionView)
        self.stackView.addArrangedSubview(self.ticketsCollectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        guard self.viewModel.shouldFetchData() else {
            return
        }
        self.viewModel.willFetchData()
    }

    private func configureCategoryCollectionView() {
        self.categoryCollectionView.register(UINib(nibName: "\(CategoryCollectionViewCell.self)", bundle: nil),
                                             forCellWithReuseIdentifier: "\(CategoryCollectionViewCell.self)")
        self.categoryCollectionView.showsHorizontalScrollIndicator = false
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
    }

    private func configureTicketsCollectionView() {
        self.ticketsCollectionView.register(UINib(nibName: "\(TicketsCollectionViewCell.self)", bundle: nil),
                                            forCellWithReuseIdentifier: "\(TicketsCollectionViewCell.self)")
        self.ticketsCollectionView.isPagingEnabled = true
        self.ticketsCollectionView.showsHorizontalScrollIndicator = false
        self.ticketsCollectionView.delegate = self
        self.ticketsCollectionView.dataSource = self
    }
}

extension HomeViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSection()
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCollectionViewCell.self)",
                                                         for: indexPath) as? CategoryCollectionViewCell {
            if self.selectedCategoryId == nil {
                self.selectedCategoryId = self.viewModel.viewDataForCellAt(indexPath: indexPath).category.id
            }
            cell.configure(with: self.selectedCategoryId,
                           category: self.viewModel.viewDataForCellAt(indexPath: indexPath).category)
            return cell
        } else if collectionView == self.ticketsCollectionView,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TicketsCollectionViewCell.self)",
                                                                for: indexPath) as? TicketsCollectionViewCell {
            cell.configure(self.viewModel.viewDataForCellAt(indexPath: indexPath).tickets)
            cell.didSelectTicket = { [weak self] ticket in
                self?.navigator.show(segue: .ticketDetail(ticketId: ticket.id),
                                     sender: self, transition: .push)
            }
            return cell
        }
        return .init()
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView {
            self.selectedCategoryId = self.viewModel.viewDataForCellAt(indexPath: indexPath).category.id
            self.categoryCollectionView.reloadData()
            let indexPath = IndexPath(row: 0, section: indexPath.section)
            self.ticketsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    private func getCurrentIndexCategory() -> Int {
        let width = UIScreen.main.bounds.width
        let offsetX = self.ticketsCollectionView.contentOffset.x
        let currentIndex = Int.init(offsetX/width)
        return currentIndex
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.categoryCollectionView {
            return CGSize(width: 100,
                          height: self.categoryCollectionView.frame.height)
        } else if collectionView == self.ticketsCollectionView {
            return self.ticketsCollectionView.frame.size
        }
        return .zero
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectioView = scrollView as? UICollectionView, collectioView == self.ticketsCollectionView else { return }
        self.selectedCategoryId = self.viewModel.viewDataForCellAt(indexPath: IndexPath(row: 0, section: self.getCurrentIndexCategory())).category.id
        self.categoryCollectionView.scrollToItem(at: IndexPath(row: 0, section: self.getCurrentIndexCategory()),
                                                 at: .centeredHorizontally,
                                                 animated: true)
        self.categoryCollectionView.reloadData()
    }
}

extension HomeViewController {
    private func createTitleView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        let titleLabel = UILabel()
        titleLabel.text = "Brown"
        titleLabel.font = .interBold(size: 24)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
        return view
    }
}
