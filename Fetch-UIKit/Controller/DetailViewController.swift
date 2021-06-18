//
//  DetailViewController.swift
//  Fetch-UIKit
//
//  Created by Andy Lochan on 6/18/21.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    var event: Event? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        print(event ?? "")
    }
}
