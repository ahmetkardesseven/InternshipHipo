//
//  MemberDetailViewController.swift
//  Hipo
//
//  Created by ahmet kardesseven on 19.04.2023.
//

import UIKit

class MemberDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var positionLabel: UILabel!
        @IBOutlet weak var teamLabel: UILabel!
        @IBOutlet weak var emailLabel: UILabel!
        @IBOutlet weak var phoneNumberLabel: UILabel!
        
    @IBOutlet weak var github: UILabel!
    var selectedMember: Members? // selected member passed from previous view controller
        
        override func viewDidLoad() {
            super.viewDidLoad()
            if let member = selectedMember {
                nameLabel.text = member.name
                positionLabel.text = member.hipo.position
                github.text = member.github
            }
        }
   
}
