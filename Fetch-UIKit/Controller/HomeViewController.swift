//
//  HomeViewController.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/17/21.
//

import UIKit
import SDWebImage

final class HomeViewController: UIViewController {
    let viewModel = HomeViewModel.shared
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        //TODO: Use an extension to make these shorter, look At "Pin Edges" Extension
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        /// Try Using Combine or Delegates
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "dataFetched") , object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "dataUpdated") , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "dataFetched"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }
    
    @objc func refresh() {
       tableView.reloadData()
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
            cell.dateLabel.text = viewModel.formatDate(date: fetchedEvent.datetimeUTC ?? "")
            
            cell.favButton.tintColor = viewModel.contains(fetchedEvent) ? .red : .clear
        }
        return cell
    }
}

// MARK: -  TableView Delegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailViewController()
        if let eventToPass = viewModel.fetchedEvents?[indexPath.row] {
            controller.event = eventToPass
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
