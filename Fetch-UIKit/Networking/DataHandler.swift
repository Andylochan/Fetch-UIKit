//
//  DataHandler.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/17/21.
//

import UIKit

class DataHandler {
    static let shared = DataHandler()

    func fetchEvents(with queryParameter: String, closure: @escaping (Events?) -> Void) {
        
        let jsonUrlString = "https://api.seatgeek.com/2/events?q=\(queryParameter)&client_id=\(clientID)"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let error = err {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("Response: \(String(describing: response))")
                return
            }

            guard let data = data else { return }
            do {
                let events = try JSONDecoder().decode(Events.self, from: data)
                closure(events)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
    }
}    

// MARK: -  ClientID
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
