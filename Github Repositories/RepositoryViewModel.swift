//
//  RepositoryViewModel.swift
//  Github Repositories
//
//  Created by Nicholas Meschke on 11/25/17.
//  Copyright © 2017 Nicholas Meschke. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

protocol RepositoryViewModelType: Transitionable {
    
    var searchText: Variable<String> { get }
    
    var repositories: Observable<[Repository]> { get }
}

class RepositoryViewModel: RepositoryViewModelType {
    
    // MARK: Dependencies
    private let repository: RepositoryType
    
    // MARK: Input
    
    var searchText = Variable<String>("")
    
    // MARK: Output
    
    var repositories: Observable<[Repository]>
    
    // MARK: Transitionable
    
    weak var navigationCoordinator: CoordinatorType?
    

    init(with repository: RepositoryType) {
        self.repository = repository
        
        // MAybe we need to change this approach
         repositories = searchText
            .asObservable()
            .flatMapLatest { searchString -> Observable<[Repository]> in
                guard !searchString.isEmpty else {
                    return Observable.empty()
                }
                return repository.fetchRepositories(for: searchString)
            }
            .share(replay: 1)
    }
}
