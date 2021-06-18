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
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
}

// MARK:- TableView Datasource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        if let eventImageURL = viewModel.fetchedEvents?[indexPath.row].imageURL {
            cell.eventImage.sd_setImage(with: URL(string: eventImageURL))
        }
        return cell
    }
}

// MARK:- TableView Delegate
extension ViewController: UITableViewDelegate {
    // Select and go to detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        if let eventToPass = viewModel.fetchedEvents?[indexPath.row] {
            controller.event = eventToPass
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK:- Searchbar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            viewModel.searchQuery = searchText
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}


