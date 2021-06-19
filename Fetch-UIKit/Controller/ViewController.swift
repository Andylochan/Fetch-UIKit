//
//  ViewController.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/17/21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = HomeViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "dataFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }
    
    @objc func refresh() {
       self.tableView.reloadData()
   }
}

// MARK:- TableView Datasource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        if let fetchedEvent = viewModel.fetchedEvents?[indexPath.row] {
            let eventImageURL = fetchedEvent.imageURL
            cell.eventImage.sd_setImage(with: URL(string: eventImageURL))
            cell.eventImage.layer.cornerRadius = 10
            
            cell.titleLabel.text = fetchedEvent.title
            cell.locationLabel.text = fetchedEvent.location
            
            let formattedDate = viewModel.formatDate(date: fetchedEvent.dateTime)
            cell.DateLabel.text = formattedDate
            
            cell.favBtn.tintColor = viewModel.contains(fetchedEvent) ? .red : .clear
        }
        return cell
    }
}

// MARK:- TableView Delegate
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        if let eventToPass = viewModel.fetchedEvents?[indexPath.row] {
            controller.event = eventToPass
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK:- Searchbar Delegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            viewModel.searchQuery = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
