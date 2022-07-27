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
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        return dateLabel
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        return locationLabel
    }()
    
    lazy var favButton: UIButton = {
        let favButton = UIButton()
        return favButton
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .orange
        return containerView
    }()
    
    lazy var centerVStack: UIStackView = {
        let centerVStack = UIStackView()
        centerVStack.axis = .vertical
        centerVStack.distribution = .fillProportionally
        return centerVStack
    }()
    
    let viewModel = HomeViewModel.shared
    var event = Event(id: 000, title: "", datetimeUTC: "", venue: Venue(location: ""), performers: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
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
    
    //TODO: Handle This Button Tap As @OBJC Func
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
