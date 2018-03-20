//
//  RepositoryType.swift
//  Github Repositories
//
//  Created by Nicholas Meschke on 11/26/17.
//  Copyright © 2017 Nicholas Meschke. All rights reserved.
//

import Foundation
import RxSwift

protocol RepositoryType: class {
    
    func fetchRepositories(for username: String) -> Observable<[Repository]>
}
