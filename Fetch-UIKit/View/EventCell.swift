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
        return locationLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        return dateLabel
    }()
    
    lazy var favBtn: UIButton = {
        let favBtn = UIButton()
        return favBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
        
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 5, y: 5, width: 250, height: contentView.frame.height-10)
    }
}
