//
//  CoordinatorType.swift
//  Github Repositories
//
//  Created by Nicholas Meschke on 11/25/17.
//  Copyright © 2017 Nicholas Meschke. All rights reserved.
//

import UIKit

protocol Transitionable: class {
    weak var navigationCoordinator: CoordinatorType? { get }
}

protocol CoordinatorType: class {
    
    var baseController: UIViewController { get }
    
    func performTransition(transition: Transition)
}

enum Transition {
    
    case showRepository(Repository)
}

class MainCoordinator: CoordinatorType {
    var baseController: UIViewController
    
    init() {
        let viewModel = RepositoryViewModel(with: RepositoryNetworking())
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        viewController.viewModel = viewModel
        baseController = UINavigationController(rootViewController: viewController)
        viewModel.navigationCoordinator = self
    }
    
    func performTransition(transition: Transition) {
        switch transition {
        case .showRepository(let repository):
            UIApplication.shared.open(URL(string: repository.url ?? "")!, options: [:], completionHandler: nil)
        }
    }
}

