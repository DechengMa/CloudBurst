//
//  WeekViewController.swift
//  CloudBurst
//
//  Created by Decheng Ma on 17/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import UIKit

protocol WeekViewControllerDelegate: class {
    func controllerDidRefresh(_ controller: WeekViewController)
}

final class WeekViewController: UIViewController {
    
    // Mark: - Properties
    
    weak var delegate: WeekViewControllerDelegate?
    
    var viewModel: WeekViewModel? {
        didSet {
            refreshControl.endRefreshing()
            
            if let viewModel = viewModel {
                setupViewModel(with: viewModel)
            }
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
            tableView.dataSource = self
            tableView.separatorInset = .zero
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableView.automaticDimension
            tableView.showsVerticalScrollIndicator = false
            
            tableView.refreshControl = refreshControl
        }
    }
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.startAnimating()
            activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = .baseTintColor
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View
        setupView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        // Configure View
        view.backgroundColor = .white
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        delegate?.controllerDidRefresh(self)
    }
    
    private func setupViewModel(with viewModel: WeekViewModel) {
        activityIndicatorView.stopAnimating()
        
        tableView.reloadData()
        tableView.isHidden = false
    }
}

extension WeekViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfDays ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekDayTableViewCell.reuseIdentifier, for: indexPath) as? WeekDayTableViewCell else {
            fatalError("Unable to Dequeue Week Day Table View Cell")
        }
        
        guard let viewModel = viewModel else {
            fatalError("No View Model Present")
        }
        
        cell.configure(with: viewModel.viewModel(for: indexPath.row))
        
        return cell
    }
    
}
