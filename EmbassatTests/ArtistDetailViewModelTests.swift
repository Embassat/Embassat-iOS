//
//  ArtistDetailViewModelTests.swift
//  Embassat
//
//  Created by Joan Romano on 08/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import XCTest

@testable import Embassat

extension Date {
    static func date(fromYear year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute
        
        return Calendar(identifier: Calendar.Identifier.gregorian).date(from: c)!
    }
}

class FakeArtistDetailInteractor: ArtistDetailInteractorProtocol {
    
    var updateHandler: ((CADEMArtist) -> ())?
    
    fileprivate var artists: [CADEMArtist]
    fileprivate(set) var model: CADEMArtist
    
    var previousArtistCalled: Bool = false
    var nextArtistCalled: Bool = false
    var toggleFavoriteCalled: Bool = false
    
    required init(artists: [CADEMArtist], index: Int, service: ArtistServiceProtocol) {
        self.artists = artists
        self.model = artists[index]
    }
    
    func nextArtist() {
        nextArtistCalled = true
    }
    
    func previousArtist() {
        previousArtistCalled = true
    }
    
    func toggleFavorite() {
        model.favorite = !model.favorite
        toggleFavoriteCalled = true
    }
}

class FakeArtistDetailCoordinator: ArtistDetailCoordinatorProtocol {
    weak var viewController: ArtistDetailViewController?
    
    var actionShared: Bool = false
    
    func showShareAction(withURL URL: Foundation.URL, title: String) {
        actionShared = true
    }
}

class ArtistDetailViewModelTests: XCTestCase {
    
    let artists = [
        CADEMArtist(artistId: 1,
                    name: "Joan",
                    longDescription: "Long Description",
                    artistURL: URL(string: "www.test.com")!,
                    imageURL: URL(string: "www.test.com")!,
                    startDate: Date.date(fromYear: 2016, month: 11, day: 02, hour: 20, minute: 45),
                    endDate: Date(),
                    stage: "First Stage",
                    youtubeId: "123",
                    favorite: false),
        CADEMArtist(artistId: 2,
                    name: "Alex",
                    longDescription: "Long Description 2",
                    artistURL: URL(string: "www.test.com")!,
                    imageURL: URL(string: "www.test.com")!,
                    startDate: Date(),
                    endDate: Date(),
                    stage: "Second Stage",
                    youtubeId: "455",
                    favorite: true),
        CADEMArtist(artistId: 3,
                    name: "Hector",
                    longDescription: "Long Description 3",
                    artistURL: URL(string: "www.test.com")!,
                    imageURL: URL(string: "www.test.com")!,
                    startDate: Date(),
                    endDate: Date(),
                    stage: "Third Stage",
                    youtubeId: "",
                    favorite: true)
    ]
    
    var sut: ArtistDetailViewModel!

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testViewModelDefaultValues() {
        let interactor = FakeArtistDetailInteractor(artists: artists, index: 0, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertEqual(sut.artistName, "Joan")
        XCTAssertTrue(sut.artistDescription.contains("Long Description"))
        XCTAssertTrue(sut.artistStartTimeString.contains("20:45"))
        XCTAssertEqual(sut.artistDay, "Dissabte")
        XCTAssertEqual(sut.artistStage, "First Stage")
        XCTAssertEqual(sut.artistVideoId, "123")
        XCTAssertTrue(sut.shouldShowArtistVideo())
        XCTAssertEqual(sut.favTintColor(), .secondary)
        XCTAssertEqual(sut.artistImageURL as URL, URL(string: "www.test.com"))
    }
    
    func testFavoriteTintColor() {
        var interactor = FakeArtistDetailInteractor(artists: artists, index: 0, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        XCTAssertEqual(sut.favTintColor(), .secondary)
        
        interactor = FakeArtistDetailInteractor(artists: artists, index: 1, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        XCTAssertEqual(sut.favTintColor(), .favorite)
        
        interactor = FakeArtistDetailInteractor(artists: artists, index: 2, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        XCTAssertEqual(sut.favTintColor(), .favorite)
    }
    
    func testShowArtistVideo() {
        var interactor = FakeArtistDetailInteractor(artists: artists, index: 0, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        XCTAssertTrue(sut.shouldShowArtistVideo())
        
        interactor = FakeArtistDetailInteractor(artists: artists, index: 1, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        XCTAssertTrue(sut.shouldShowArtistVideo())
        
        interactor = FakeArtistDetailInteractor(artists: artists, index: 2, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        XCTAssertFalse(sut.shouldShowArtistVideo())
    }
    
    func testViewModelNextAndPreviousIndex() {
        let interactor = FakeArtistDetailInteractor(artists: artists, index: 0, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertFalse(interactor.nextArtistCalled)
        XCTAssertFalse(interactor.previousArtistCalled)
        
        sut.showNext()
        sut.showPrevious()
        
        XCTAssertTrue(interactor.nextArtistCalled)
        XCTAssertTrue(interactor.previousArtistCalled)
    }
    
    func testViewModelFavorite() {
        let interactor = FakeArtistDetailInteractor(artists: artists, index: 0, service: FakeArtistService())
        sut = ArtistDetailViewModel(interactor: interactor, coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertFalse(interactor.toggleFavoriteCalled)
        
        sut.toggleFavorite()
        
        XCTAssertTrue(interactor.toggleFavoriteCalled)
    }
    
    func _testShareAction() {
        let coordinator = FakeArtistDetailCoordinator()
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 0, service: FakeArtistService()),
                                    coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertFalse(coordinator.actionShared)
        
        sut.shareAction()
        
        XCTAssertTrue(coordinator.actionShared)
    }
}
