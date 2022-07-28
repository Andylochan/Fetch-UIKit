//
//  DetailViewController.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/18/21.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        return dateLabel
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return locationLabel
    }()
    
    lazy var favButton: UIButton = {
        let favButton = UIButton()
        return favButton
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
    
    lazy var labelVStack: UIStackView = {
        let labelVStack = UIStackView()
        labelVStack.axis = .vertical
        labelVStack.distribution = .fillEqually
        
        labelVStack.addArrangedSubview(dateLabel)
        labelVStack.addArrangedSubview(locationLabel)
        
        return labelVStack
    }()
    
    let viewModel = HomeViewModel.shared
    var event = Event(id: 000, title: "", datetimeUTC: "", venue: Venue(location: ""), performers: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(imgView)
        containerView.addSubview(labelVStack)
        containerView.addSubview(favButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        labelVStack.translatesAutoresizingMaskIntoConstraints = false
        favButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            imgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            imgView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            imgView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 300),
            
            labelVStack.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 20),
            labelVStack.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            labelVStack.rightAnchor.constraint(equalTo: favButton.leftAnchor, constant: 15),
            labelVStack.heightAnchor.constraint(equalToConstant: 75),
            
            favButton.centerYAnchor.constraint(equalTo: labelVStack.centerYAnchor),
            favButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15),
            favButton.heightAnchor.constraint(equalToConstant: 45),
            favButton.widthAnchor.constraint(equalToConstant: 55),
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
    
    @objc func action(sender: UIButton) {
        if viewModel.contains(event) {
            viewModel.remove(event)
        } else {
            viewModel.add(event)
        }
        setupView()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
    }
}
