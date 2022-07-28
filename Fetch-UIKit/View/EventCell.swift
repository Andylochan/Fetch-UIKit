//
//  EventCell.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/17/21.
//

import UIKit

class EventCell: UITableViewCell {
    static let identifier = "EventCell"
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    lazy var eventImage: UIImageView = {
        let eventImage = UIImageView()
        return eventImage
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return locationLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return dateLabel
    }()
    
    lazy var favButton: UIButton = {
        let favButton = UIButton()
        favButton.setImage(UIImage(systemName: "heart.circle"), for: .normal)
        return favButton
    }()
    
    lazy var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fillProportionally
        contentStackView.spacing = 10
        return contentStackView
    }()
    
    lazy var labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        labelStackView.spacing = -10
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(locationLabel)
        labelStackView.addArrangedSubview(dateLabel)
        
        return labelStackView
    }()
    
// MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(eventImage)
        eventImage.addSubview(favButton)
        contentStackView.addArrangedSubview(labelStackView)
        
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        favButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentStackView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        
        NSLayoutConstraint.activate([
            eventImage.widthAnchor.constraint(equalToConstant: 130),
           
            favButton.widthAnchor.constraint(equalToConstant: 25),
            favButton.heightAnchor.constraint(equalToConstant: 25),
            favButton.topAnchor.constraint(equalTo: eventImage.topAnchor),
            favButton.rightAnchor.constraint(equalTo: eventImage.rightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
