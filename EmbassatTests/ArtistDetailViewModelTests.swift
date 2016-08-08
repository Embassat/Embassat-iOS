//
//  ArtistDetailViewModelTests.swift
//  Embassat
//
//  Created by Joan Romano on 08/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import XCTest

extension NSDate {
    static func date(fromYear year: Int, month: Int, day: Int, hour: Int, minute: Int) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute
        
        return NSCalendar(identifier: NSCalendarIdentifierGregorian)!.dateFromComponents(c)!
    }
}

class FakeArtistDetailInteractor: ArtistDetailInteractorProtocol {
    
    var updateHandler: ((CADEMArtist) -> ())?
    
    private var artists: [CADEMArtist]
    private(set) var model: CADEMArtist
    
    var previousArtistCalled: Bool = false
    var nextArtistCalled: Bool = false
    var toggleFavoriteCalled: Bool = false
    
    required init(artists: [CADEMArtist], index: Int) {
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
        toggleFavoriteCalled = true
    }
}

class FakeArtistDetailCoordinator: ArtistDetailCoordinatorProtocol {
    weak var viewController: ArtistDetailViewController?
    
    var actionShared: Bool = false
    
    func showShareAction(withURL URL: NSURL, title: String) {
        actionShared = true
    }
}

class ArtistDetailViewModelTests: XCTestCase {
    
    let artists = [
        CADEMArtist(artistId: 1,
                    name: "Joan",
                    longDescription: "Long Description",
                    artistURL: NSURL(string: "www.test.com")!,
                    imageURL: NSURL(string: "www.test.com")!,
                    startDate: NSDate.date(fromYear: 2016, month: 11, day: 02, hour: 20, minute: 45),
                    endDate: NSDate(),
                    stage: "First Stage",
                    youtubeId: "123",
                    favorite: false),
        CADEMArtist(artistId: 2,
                    name: "Alex",
                    longDescription: "Long Description 2",
                    artistURL: NSURL(string: "www.test.com")!,
                    imageURL: NSURL(string: "www.test.com")!,
                    startDate: NSDate(),
                    endDate: NSDate(),
                    stage: "Second Stage",
                    youtubeId: "455",
                    favorite: true),
        CADEMArtist(artistId: 3,
                    name: "Hector",
                    longDescription: "Long Description 3",
                    artistURL: NSURL(string: "www.test.com")!,
                    imageURL: NSURL(string: "www.test.com")!,
                    startDate: NSDate(),
                    endDate: NSDate(),
                    stage: "Third Stage",
                    youtubeId: "",
                    favorite: true)
    ]
    
    var sut: ArtistDetailViewModel<FakeArtistDetailCoordinator, FakeArtistDetailInteractor>?

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testViewModelDefaultValues() {
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 0), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertEqual(sut!.artistName, "Joan")
        XCTAssertTrue(sut!.artistDescription.containsString("Long Description"))
        XCTAssertTrue(sut!.artistStartTimeString.containsString("20:45"))
        XCTAssertEqual(sut!.artistDay, "Diumenge")
        XCTAssertEqual(sut!.artistStage, "First Stage")
        XCTAssertEqual(sut!.artistVideoId, "123")
        XCTAssertTrue(sut!.shouldShowArtistVideo())
        XCTAssertEqual(sut?.favTintColor(), .whiteColor())
        XCTAssertEqual(sut!.artistImageURL, NSURL(string: "www.test.com"))
    }
    
    func testFavoriteTintColor() {
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 1), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertEqual(sut?.favTintColor(), .lightGrayColor())
        
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 2), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertEqual(sut?.favTintColor(), .lightGrayColor())
        
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 0), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertEqual(sut?.favTintColor(), .whiteColor())
    }
    
    func testShowArtistVideo() {
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 1), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertTrue(sut!.shouldShowArtistVideo())
        
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 2), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertFalse(sut!.shouldShowArtistVideo())
        
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 0), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertTrue(sut!.shouldShowArtistVideo())
    }
    
    func testViewModelNextAndPreviousIndex() {
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 0), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertFalse(sut!.interactor.nextArtistCalled)
        XCTAssertFalse(sut!.interactor.previousArtistCalled)
        
        sut?.showNext()
        sut?.showPrevious()
        
        XCTAssertTrue(sut!.interactor.nextArtistCalled)
        XCTAssertTrue(sut!.interactor.previousArtistCalled)
    }
    
    func testViewModelFavorite() {
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 0), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertFalse(sut!.interactor.toggleFavoriteCalled)
        
        sut?.toggleFavorite()
        
        XCTAssertTrue(sut!.interactor.toggleFavoriteCalled)
    }
    
    func testShareAction() {
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 0), coordinator: FakeArtistDetailCoordinator())
        
        XCTAssertFalse(sut!.coordinator.actionShared)
        
        sut?.shareAction()
        
        XCTAssertTrue(sut!.coordinator.actionShared)
    }
}
