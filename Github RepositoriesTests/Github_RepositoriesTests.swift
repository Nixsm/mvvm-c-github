//
//  Github_RepositoriesTests.swift
//  Github RepositoriesTests
//
//  Created by Nicholas Meschke on 11/25/17.
//  Copyright © 2017 Nicholas Meschke. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Github_Repositories

class Github_RepositoriesTests: XCTestCase {
    private var viewModel: RepositoryViewModel!
    private var disposeBag: DisposeBag!
    private var mockRepository: MockRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockRepository()
        viewModel = RepositoryViewModel(with: mockRepository)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRepositoryFetchSuccess() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let buttonTaps = scheduler.createHotObservable([next(0, "test")])

        buttonTaps
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        let observer = scheduler.createObserver([Repository].self)

        viewModel
            .repositories
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let correctValues = [
            next(0, mockRepository.expectedRepos)
        ]

        XCTAssert(observer.events.elementsEqual(correctValues, by: { rhs, lhs in
            guard let rhsValues = rhs.value.element else { return false }
            guard let lhsValues = lhs.value.element else { return false }
            
            return rhsValues == lhsValues
        }))
    }
}

class MockRepository: RepositoryNetworking {
    var expectedRepos = [Repository]()
    var givenError: Error?
    
    override func fetchRepositories(for username: String) -> Observable<[Repository]> {
        if let error = givenError {
            return .error(error)
        }
        
        return .just(expectedRepos)
    }
}
