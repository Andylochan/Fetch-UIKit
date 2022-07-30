//
//  DetailViewController.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/18/21.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    let viewModel = HomeViewModel.shared
    var event = Event(id: 000, title: "", datetimeUTC: "", venue: Venue(location: ""), performers: [])
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var detailImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        return locationLabel
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        return favoriteButton
    }()
    
    private lazy var HStack: UIStackView = {
        let HStack = UIStackView(arrangedSubviews: [labelVStack, UIView(), favoriteButton])
        HStack.alignment = .center
        HStack.translatesAutoresizingMaskIntoConstraints = false
        return HStack
    }()
    
    private lazy var labelVStack: UIStackView = {
        let labelVStack = UIStackView(arrangedSubviews: [dateLabel, locationLabel])
        labelVStack.axis = .vertical
        labelVStack.distribution = .fillEqually
        labelVStack.translatesAutoresizingMaskIntoConstraints = false
        return labelVStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(detailImageView)
        view.addSubview(HStack)
        
        //TODO: Use an extension to make these shorter
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),

            detailImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            detailImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            detailImageView.heightAnchor.constraint(equalToConstant: 300),
            
            HStack.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 20),
            HStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            HStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            HStack.heightAnchor.constraint(equalToConstant: 75),
        ])
        
        setupView()
    }
    
    private func setupView() {
        titleLabel.text = event.title
        let eventImageURL = event.performers.first?.image
        detailImageView.sd_setImage(with: eventImageURL)
        detailImageView.layer.cornerRadius = 10
        
        let formattedDate = viewModel.formatDate(date: event.datetimeUTC ?? "")
        dateLabel.text = formattedDate

        locationLabel.text = event.venue.location
        favoriteButton.tintColor = viewModel.contains(event) ? .red : .black
        favoriteButton.setBackgroundImage(viewModel.contains(event) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
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
