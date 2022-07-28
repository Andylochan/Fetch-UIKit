//
//  HomeView.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 7/27/22.
//

import UIKit

//TODO: Reference https://www.hackingwithswift.com/articles/89/how-to-move-view-code-out-of-your-view-controllers
class HomeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }

    func createSubviews() {
        // all the layout code from above
    }
}
