//
//  DetailViewController.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/18/21.
//

import UIKit
import SDWebImage

//TODO: CONVERT TO PROGRAMATIC UI
class DetailViewController: UIViewController {
    var titleLabel = UILabel()
    var imgView = UIImageView()
    var dateLabel = UILabel()
    var locationLabel = UILabel()
    var favButton = UIButton()
    
    let viewModel = HomeViewModel.shared
    var event = Event(id: 000, title: "", datetimeUTC: "", venue: Venue(location: ""), performers: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        titleLabel.text = event.title
        let eventImageURL = event.performers.first?.image
        imgView.sd_setImage(with: eventImageURL)
        imgView.layer.cornerRadius = 10
        
        let formattedDate = viewModel.formatDate(date: event.datetimeUTC ?? "")
        dateLabel.text = formattedDate

        locationLabel.text = event.venue.location
        favButton.tintColor = viewModel.contains(event) ? .red : .black
        favButton.setBackgroundImage(viewModel.contains(event) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }
    
    @IBAction func favBtnTapped(_ sender: UIButton) {
        if viewModel.contains(event) {
            viewModel.remove(event)
        } else {
            viewModel.add(event)
        }
        setupView()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }
}
