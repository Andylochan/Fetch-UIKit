//
//  DataHandler.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/17/21.
//

import Alamofire
import SwiftyJSON

class DataHandler {
    static let shared = DataHandler()
    
    func fetchEvents(with queryParameter: String, closure: @escaping (Bool?, [Event]?) -> Void) {

        let url = "https://api.seatgeek.com/2/events?q=\(queryParameter)&client_id=\(clientID)"
        var events = [Event]()
        
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.error != nil {
                closure(nil, nil)
                return
            }
            
            if let data = response.data, let json = try? JSON(data: data) {
                //Parse data into a [Event] array
                let container = json["events"]
                let eventsArray = container.array ?? []

                for event in eventsArray {
                    let id = event.dictionaryObject?["id"] as? Int ?? 000
                    let title = event.dictionaryObject?["title"] as? String ?? ""
                    let dateTime = event.dictionaryObject?["datetime_utc"] as? String ?? ""
                    
                    let venue = event["venue"]
                    let location = venue.dictionaryObject?["display_location"] as? String ?? ""
                    
                    let performerCont = event["performers"]
                    let performerArr = performerCont.array ?? []
                    let imageURL = performerArr[0].dictionaryObject?["image"] as? String ?? ""

                    let eventToAppend = Event(id: id, title: title, dateTime: dateTime, location: location, imageURL: imageURL)
                    events.append(eventToAppend)
                }
                closure(true, events)
            }
        }
    }
}

// MARK:-  ClientID
extension DataHandler {
    private var clientID: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Creds", ofType: "plist") else {
                fatalError("Couldn't find the file 'Creds.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "clientID") as? String else {
                fatalError("Couldn't find 'ClientID' in 'Creds.plist'.")
            }
            return value
        }
    }
}
