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
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return titleLabel
    }()
    
    lazy var eventImage: UIImageView = {
        let eventImage = UIImageView()
        return eventImage
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return locationLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return dateLabel
    }()
    
    lazy var favButton: UIButton = {
        let favButton = UIButton()
        return favButton
    }()
    
    lazy var labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        return labelStackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
        
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(locationLabel)
        labelStackView.addArrangedSubview(dateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelStackView.frame = CGRect(x: 50, y: 0, width: 250, height: contentView.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
