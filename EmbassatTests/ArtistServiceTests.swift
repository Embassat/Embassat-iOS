//
//  EmbassatTests.swift
//  EmbassatTests
//
//  Created by Joan Romano on 23/04/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import XCTest
import Kakapo

struct Artist: Storable, Serializable {
    let description: String
    let image_url: String
    let share_url: String
    let youtube_video_id: String
    let name: String
    let stage: String
    let start_date: String
    let end_date: String
    let id: String
    
    init(id: String, store db: Store) {
        self.init(description: "some_description",
                  image_url: "http://www.embassat.com/wp-content/uploads/gullen1.jpg",
                  share_url: "http://www.embassat.com/wp-content/uploads/gullen1.jpg",
                  youtube_video_id : "ec5PyegiGJg",
                  name: "some_name",
                  stage: "some_stage",
                  start_date: "2015-06-12T21:15:00",
                  end_date: "2015-06-14T15:15:00",
                  id: id)
    }
    
    init(description: String,
         image_url: String,
         share_url: String,
         youtube_video_id: String,
         name: String,
         stage: String,
         start_date: String,
         end_date: String,
         id: String) {
        self.description = description
        self.image_url = image_url
        self.share_url = share_url
        self.youtube_video_id = youtube_video_id
        self.name = name
        self.stage = stage
        self.start_date = start_date
        self.end_date = end_date
        self.id = id
    }
}

class ArtistServiceTests: XCTestCase {
    
    var sut: ArtistService!
    let db = Store()
    var router: Router!
    
    override func setUp() {
        super.setUp()
        
        sut = ArtistService()
        router = Router.register("https://scorching-torch-2707.firebaseio.com")
    }
    
    override func tearDown() {
        let _ = try? FileManager.default.removeItem(atPath: sut!.store.documentsPath + ArtistService.kArtistsStoreKey)
        sut = nil
        Router.unregister("https://scorching-torch-2707.firebaseio.com")
        
        super.tearDown()
    }
    
    func testGet1Artist() {
        router.get("/:artists") { request in
            return self.db.create(Artist.self)
        }
        let expectation = self.expectation(description: "Should properly get 1 artist")
        
        sut.artists { (artists, error) in
            guard let artists = artists else { return }
            
            let artist = artists.first!
            
            XCTAssertEqual(artists.count, 1)
            XCTAssertEqual(artist.artistId, 0)
            XCTAssertTrue(artist.name.characters.count > 0)
            XCTAssertTrue((artist.imageURL.absoluteString.characters.count) > 0)
            XCTAssertTrue(artist.stage.characters.count > 0)
            XCTAssertTrue(artist.longDescription.characters.count > 0)
            XCTAssertTrue((artist.artistURL.absoluteString.characters.count) > 0)
            XCTAssertTrue(artist.youtubeId.characters.count > 0)
            XCTAssertTrue(artist.scheduleDayString.characters.count > 0)
            XCTAssertFalse(artist.favorite)
            XCTAssertNotNil(artist.startDate)
            XCTAssertNotNil(artist.endDate)
            XCTAssertNotNil(artist.scheduleDate)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in }
    }
    
    func testGet50Artists() {
        router.get("/:artists") { request in
            return self.db.create(Artist.self, number: 50)
        }
        let expectation = self.expectation(description: "Should properly get 50 artists")
        
        sut.artists { (artists, error) in
            guard let artists = artists else { return }
            
            let artist = artists[30]
            
            XCTAssertEqual(artists.count, 50)
            XCTAssertEqual(artist.artistId, 30)
            XCTAssertTrue(artist.name.characters.count > 0)
            XCTAssertTrue((artist.imageURL.absoluteString.characters.count) > 0)
            XCTAssertTrue(artist.stage.characters.count > 0)
            XCTAssertTrue(artist.longDescription.characters.count > 0)
            XCTAssertTrue((artist.artistURL.absoluteString.characters.count) > 0)
            XCTAssertTrue(artist.youtubeId.characters.count > 0)
            XCTAssertTrue(artist.scheduleDayString.characters.count > 0)
            XCTAssertFalse(artist.favorite)
            XCTAssertNotNil(artist.startDate)
            XCTAssertNotNil(artist.endDate)
            XCTAssertNotNil(artist.scheduleDate)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in }
    }
    
    func testGetArtistError() {
        router.get("/:artists") { request in
            return Response(statusCode: 400, body: Optional.some("none"))
        }
        
        let expectation = self.expectation(description: "Should error when invalid response")
        
        sut.artists { (artists, error) in
            XCTAssertNil(artists)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in }
    }
    
}
