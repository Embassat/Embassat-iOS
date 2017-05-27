//
//  ArtistDetailInteractorTests.swift
//  Embassat
//
//  Created by Joan Romano on 08/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import XCTest

@testable import Embassat

let artistsArray = [
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

class FakeArtistService: ArtistServiceProtocol {
    
    var artistsCalled: Bool = false
    var cachedArtistsCalled: Bool = false
    var toggleFavoriteCalled: Bool = false
    
    func artists(_ completion: @escaping ([CADEMArtist]?, NSError?) -> ()) {
        completion([], nil)
        artistsCalled = true
    }
    
    func persistedArtists(_ completion: ([CADEMArtist]) -> ()) {
        completion([])
        cachedArtistsCalled = true
    }
    
    func toggleFavorite(forArtist artist: CADEMArtist, completion: (CADEMArtist) -> ()) {
        completion(artistsArray[0])
        toggleFavoriteCalled = true
    }
    
}

class ArtistDetailInteractorTests: XCTestCase {
    var sut: ArtistDetailInteractor!

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testNextAndPrevious() {
        sut = ArtistDetailInteractor(artists: artistsArray, index: 0, service: FakeArtistService())
        
        XCTAssertEqual(sut.model.artistId, 1)
        XCTAssertEqual(sut.model.name, "Joan")
        XCTAssertEqual(sut.model.longDescription, "Long Description")
        
        sut?.previousArtist()
        
        XCTAssertEqual(sut.model.artistId, 1)
        XCTAssertEqual(sut.model.name, "Joan")
        XCTAssertEqual(sut.model.longDescription, "Long Description")
        
        sut?.nextArtist()
        
        XCTAssertEqual(sut.model.artistId, 2)
        XCTAssertEqual(sut.model.name, "Alex")
        XCTAssertEqual(sut.model.longDescription, "Long Description 2")
        
        sut?.previousArtist()
        
        XCTAssertEqual(sut.model.artistId, 1)
        XCTAssertEqual(sut.model.name, "Joan")
        XCTAssertEqual(sut.model.longDescription, "Long Description")
        
        sut?.nextArtist()
        sut?.nextArtist()
        
        XCTAssertEqual(sut.model.artistId, 3)
        XCTAssertEqual(sut.model.name, "Hector")
        XCTAssertEqual(sut.model.longDescription, "Long Description 3")
        
        sut?.nextArtist()
        
        XCTAssertEqual(sut.model.artistId, 3)
        XCTAssertEqual(sut.model.name, "Hector")
        XCTAssertEqual(sut.model.longDescription, "Long Description 3")
    }
    
    func testToggleFavourite() {
        sut = ArtistDetailInteractor(artists: artistsArray, index: 0, service: FakeArtistService())
        
        let service = sut.service as! FakeArtistService
        
        XCTAssertFalse(service.toggleFavoriteCalled)
        
        sut.toggleFavorite()
        
        XCTAssertTrue(service.toggleFavoriteCalled)
    }

}
