//
//  HomeViewModel.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/17/21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    var searchCancellable: AnyCancellable? = nil
    
    @Published var searchQuery = ""
    @Published var fetchedEvents: [Event]? = nil
    @Published var events: Set<Int>
    
    init() {
        //Favorites data store
        let decoder = JSONDecoder()
        if let data = defaults.data(forKey: "Favorites-3") {
            let eventData = try? decoder.decode(Set<Int>.self, from: data)
            self.events = eventData ?? []
        } else {
            self.events = []
        }
        
        //Wait 0.6 sec after user is done typing, then fetch
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str == "" {
                    //Reset Data
                    self.fetchedEvents = nil
                }
                else {
                    self.searchEvents()
                }
            })
    }

    func searchEvents() {
        let originalQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
        
        DataHandler.shared.fetchEvents(with: originalQuery) { [unowned self] (events) in
            self.fetchedEvents = events?.events
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataFetched"), object: nil)
            }
        }
    }
}

// MARK: -  Favorites Methods
extension HomeViewModel {
    func getEventIds() -> Set<Int> {
        return self.events
    }
    
    func isEmpty() -> Bool {
        events.count < 1
    }
    
    func contains(_ event: Event) -> Bool {
        events.contains(event.id)
    }
    
    func add(_ event: Event) {
        objectWillChange.send()
        events.insert(event.id)
        save()
    }
    
    func remove(_ event: Event) {
        objectWillChange.send()
        events.remove(event.id)
        save()
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(events) {
            defaults.set(encoded, forKey: "Favorites-3")
        }
    }
}

// MARK: - Date Formatter
extension HomeViewModel {
    func formatDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "zzz")
        let convertedDate = dateFormatter.date(from: date)

        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }

        //DAY MONTH DATE, YEAR HOUR:MIN AM/PM
        dateFormatter.dateFormat = "EEEE MMM d, yyyy h:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "EST") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }
}
