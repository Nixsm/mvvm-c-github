//
//  ViewController.swift
//  Github Repositories
//
//  Created by Nicholas Meschke on 11/25/17.
//  Copyright © 2017 Nicholas Meschke. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var viewModel: RepositoryViewModelType?
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ViewController {
    
    func setup() {
        guard let viewModel = viewModel else {
            return
        }
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.titleView = searchController.searchBar
        
        searchController.searchBar
            .rx
            .text
            .orEmpty
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        
        let className = String(describing: RepositoryTableViewCell.self)
        tableView.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
        
        viewModel
            .repositories
            .bind(to: tableView.rx.items(cellIdentifier: className, cellType: RepositoryTableViewCell.self)) { _, repo, cell in
                cell.textLabel?.text = repo.name
            }
            .disposed(by: disposeBag)
    }
}



