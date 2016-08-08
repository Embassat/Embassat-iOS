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
    
    required init(artists: [CADEMArtist], index: Int) {
        self.artists = artists
        model = artists.first!
    }
    
    func currentIndex() -> Int {
        return artists.indexOf(model)!
    }
    
    func updateModel(withNexIndex index: Int) {
        var theIndex: Int = index
        
        if theIndex > artists.count - 1 {
            theIndex = artists.count - 1
        }
        
        if theIndex < 0 {
            theIndex = 0
        }
        
        model = artists[theIndex]
    }
    
    func toggleFavorite() {
        artists[currentIndex()].favorite = !artists[currentIndex()].favorite
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
                    youtubeId: "123"),
        CADEMArtist(artistId: 2,
                    name: "Alex",
                    longDescription: "Long Description 2",
                    artistURL: NSURL(string: "www.test.com")!,
                    imageURL: NSURL(string: "www.test.com")!,
                    startDate: NSDate(),
                    endDate: NSDate(),
                    stage: "Second Stage",
                    youtubeId: "455"),
        CADEMArtist(artistId: 3,
                    name: "Hector",
                    longDescription: "Long Description 3",
                    artistURL: NSURL(string: "www.test.com")!,
                    imageURL: NSURL(string: "www.test.com")!,
                    startDate: NSDate(),
                    endDate: NSDate(),
                    stage: "Third Stage",
                    youtubeId: "678")
    ]
    
    var sut: ArtistDetailViewModel<FakeArtistDetailCoordinator, FakeArtistDetailInteractor>?

    override func setUp() {
        super.setUp()
        
        sut = ArtistDetailViewModel(interactor: FakeArtistDetailInteractor(artists: artists, index: 0), coordinator: FakeArtistDetailCoordinator())
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testViewModelDefaultValues() {
        XCTAssertEqual(sut!.artistName, "Joan")
        XCTAssertTrue(sut!.artistDescription.containsString("Long Description"))
        XCTAssertTrue(sut!.artistStartTimeString.containsString("20:45"))
        XCTAssertEqual(sut!.artistDay, "Diumenge")
        XCTAssertEqual(sut!.artistStage, "First Stage")
        XCTAssertEqual(sut!.artistVideoId, "123")
        XCTAssertFalse(sut!.artistIsFavorite)
        XCTAssertEqual(sut!.artistImageURL, NSURL(string: "www.test.com"))
    }
    
    func testViewModelCurrentIndex() {
        XCTAssertEqual(sut?.currentIndex, 0)
        
        sut?.currentIndex = 1
        
        XCTAssertEqual(sut!.artistName, "Alex")
        XCTAssertTrue(sut!.artistDescription.containsString("Long Description 2"))
        XCTAssertEqual(sut!.artistStage, "Second Stage")
        XCTAssertEqual(sut!.artistVideoId, "455")
        
        sut?.currentIndex = 2
        
        XCTAssertEqual(sut!.artistName, "Hector")
        XCTAssertTrue(sut!.artistDescription.containsString("Long Description 3"))
        XCTAssertEqual(sut!.artistStage, "Third Stage")
        XCTAssertEqual(sut!.artistVideoId, "678")
    }
    
    func testViewModelFavorite() {
        XCTAssertFalse(sut!.artistIsFavorite)
        
        sut?.toggleFavorite()
        
        XCTAssertTrue(sut!.artistIsFavorite)
        
        sut?.currentIndex = 2
        
        XCTAssertFalse(sut!.artistIsFavorite)
        
        sut?.toggleFavorite()
        
        XCTAssertTrue(sut!.artistIsFavorite)
        
        sut?.currentIndex = 0
        
        XCTAssertTrue(sut!.artistIsFavorite)
        
        sut?.toggleFavorite()
        
        XCTAssertFalse(sut!.artistIsFavorite)
        
        sut?.currentIndex = 1
        
        XCTAssertFalse(sut!.artistIsFavorite)
    }
    
    func testShareAction() {
        XCTAssertFalse(sut!.coordinator.actionShared)
        
        sut?.shareAction()
        
        XCTAssertTrue(sut!.coordinator.actionShared)
    }
}
