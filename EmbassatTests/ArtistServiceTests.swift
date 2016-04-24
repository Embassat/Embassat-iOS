//
//  EmbassatTests.swift
//  EmbassatTests
//
//  Created by Joan Romano on 23/04/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import XCTest

struct ArtistFactory: Storable, Serializable {
    let description: String
    let image_url: String
    let share_url: String
    let name: String
    let stage: String
    let start_date: String
    let end_date: String
    let id: Int
    
    init(id: Int, db: KakapoDB) {
        self.init(description: randomString(),
                  image_url: "http://www.embassat.com/wp-content/uploads/gullen1.jpg",
                  share_url: "http://www.embassat.com/wp-content/uploads/gullen1.jpg",
                  name: randomString(),
                  stage: randomString(),
                  start_date: "2015-06-12T21:15:00",
                  end_date: "2015-06-14T15:15:00",
                  id: id)
    }
    
    init(description: String,
         image_url: String,
         share_url: String,
         name: String,
         stage: String,
         start_date: String,
         end_date: String,
         id: Int) {
        self.description = description
        self.image_url = image_url
        self.share_url = share_url
        self.name = name
        self.stage = stage
        self.start_date = start_date
        self.end_date = end_date
        self.id = id
    }
}

extension ArtistFactory: Equatable {}

func ==(lhs: ArtistFactory, rhs: ArtistFactory) -> Bool {
    return lhs.name == rhs.name && lhs.description == rhs.description && lhs.stage == rhs.stage && lhs.id == rhs.id
}

class ArtistServiceTests: XCTestCase {
    
    let sut = ArtistService()
    let db = KakapoDB()
    
    override func setUp() {
        super.setUp()
        
        KakapoServer.enable()
    }
    
    override func tearDown() {
        KakapoServer.disable()
        
        super.tearDown()
    }
    
    func testGet1Artist() {
        KakapoServer.get("https://scorching-torch-2707.firebaseio.com/:artists") { request in
            return self.db.create(ArtistFactory)
        }
        let expectation = expectationWithDescription("Should properly get 1 artist")
        
        sut.artists().subscribeNext { artists in
            guard let artists = artists as? [CADEMArtist] else { XCTFail(); return }
            
            let artist = artists.first!
            
            XCTAssertEqual(artists.count, 1)
            XCTAssertEqual(artist.artistId, 0)
            XCTAssertTrue(artist.name.characters.count > 0)
            XCTAssertTrue(artist.imageURL.absoluteString.characters.count > 0)
            XCTAssertTrue(artist.stage.characters.count > 0)
            XCTAssertTrue(artist.longDescription.characters.count > 0)
            XCTAssertTrue(artist.artistURL.absoluteString.characters.count > 0)
            XCTAssertTrue(artist.scheduleDayString.characters.count > 0)
            XCTAssertFalse(artist.favorite)
            XCTAssertNotNil(artist.startDate)
            XCTAssertNotNil(artist.endDate)
            XCTAssertNotNil(artist.scheduleDate)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { _ in }
    }
    
    func testGet50Artists() {
        KakapoServer.get("https://scorching-torch-2707.firebaseio.com/:artists") { request in
            return self.db.create(ArtistFactory.self, number: 50)
        }
        let expectation = expectationWithDescription("Should properly get 50 artists")
        
        sut.artists().subscribeNext { artists in
            guard let artists = artists as? [CADEMArtist] else { XCTFail(); return }
            
            let artist = artists[30]
            
            XCTAssertEqual(artists.count, 50)
            XCTAssertEqual(artist.artistId, 30)
            XCTAssertTrue(artist.name.characters.count > 0)
            XCTAssertTrue(artist.imageURL.absoluteString.characters.count > 0)
            XCTAssertTrue(artist.stage.characters.count > 0)
            XCTAssertTrue(artist.longDescription.characters.count > 0)
            XCTAssertTrue(artist.artistURL.absoluteString.characters.count > 0)
            XCTAssertTrue(artist.scheduleDayString.characters.count > 0)
            XCTAssertFalse(artist.favorite)
            XCTAssertNotNil(artist.startDate)
            XCTAssertNotNil(artist.endDate)
            XCTAssertNotNil(artist.scheduleDate)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { _ in }
    }
    
    func testGetArtistError() {
        KakapoServer.get("https://scorching-torch-2707.firebaseio.com/:artists") { request in
            return Response(code: 400, body: Optional.Some("none"))
        }
        
        let expectation = expectationWithDescription("Should error when invalid response")
        
        sut.artists().subscribeNext({ artists in
            XCTFail()
            }, error: { error in
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1) { _ in }
    }
    
}
