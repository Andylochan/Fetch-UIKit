//
//  HomeViewController.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/17/21.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    let viewModel = HomeViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "dataFetched") , object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "dataUpdated") , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "dataFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }
    
    @objc func refresh() {
       self.tableView.reloadData()
   }
}

// MARK: - TableView Datasource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as! EventCell
        
        if let fetchedEvent = viewModel.fetchedEvents?[indexPath.row] {
            let eventImageURL = fetchedEvent.performers.first?.image
            cell.eventImage.sd_setImage(with: eventImageURL)
            cell.eventImage.layer.cornerRadius = 10
            
            cell.titleLabel.text = fetchedEvent.title
            cell.locationLabel.text = fetchedEvent.venue.location
            
            let formattedDate = viewModel.formatDate(date: fetchedEvent.datetimeUTC ?? "")
            cell.dateLabel.text = formattedDate
            
            cell.favBtn.tintColor = viewModel.contains(fetchedEvent) ? .red : .clear
        }
        return cell
    }
}

// MARK: -  TableView Delegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        if let eventToPass = viewModel.fetchedEvents?[indexPath.row] {
            controller.event = eventToPass
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: -  Searchbar Delegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            viewModel.searchQuery = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
