//
//  ContactCell.swift
//  CustomContactListWS
//
//  Created by Александр Уткин on 07.08.2021.
//

import UIKit
import Contacts
import ContactsUI

class ContactCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

    func configure(with contact: CNContact, cell: ContactCell) {
    }
}
