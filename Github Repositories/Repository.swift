//
//  Repository.swift
//  Github Repositories
//
//  Created by Nicholas Meschke on 11/25/17.
//  Copyright © 2017 Nicholas Meschke. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

class RepositoryNetworking: RepositoryType {
    
    func fetchRepositories(for username: String) -> Observable<[Repository]> {
        return RxAlamofire
            .data(.get, "https://api.github.com/users/\(username)/repos").debug()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { data -> [Repository] in
                let decoder = JSONDecoder()
                return try decoder.decode([Repository].self, from: data)
        }
    }
}

class Repository: Codable, Equatable {

    enum Codingkeys: String, CodingKey {
        case identfier = "id"
        case language
        case url
        case name
    }
    
    var identfier: Int?
    var language: String?
    var url: String?
    var name: String?
    
    static func ==(lhs: Repository, rhs: Repository) -> Bool {
        return lhs.identfier == rhs.identfier &&
            lhs.language == rhs.language &&
            lhs.url == rhs.url &&
            lhs.name == rhs.name
    }
    
}
