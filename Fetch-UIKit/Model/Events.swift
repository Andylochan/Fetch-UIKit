//
//  Events.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/19/21.
//

import UIKit

struct Events: Decodable {
    let events: [Event]
}

struct Event: Decodable, Identifiable {
    let id: Int
    let title: String?
    let datetimeUTC: String?
    let venue: Venue
    let performers: [Performer]
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case datetimeUTC = "datetime_utc"
        case venue
        case performers
    }
}

struct Venue: Decodable {
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case location = "display_location"
    }
}

struct Performer: Decodable {
    let image: URL?
}
