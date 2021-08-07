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
    
    let nameContactLabel: UILabel = {
        let nameContactLabel = UILabel()
        nameContactLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameContactLabel.translatesAutoresizingMaskIntoConstraints = false
        nameContactLabel.textAlignment = .left
        return nameContactLabel
    }()
    
    let phoneContactLabel: UILabel = {
        let phoneContactLabel = UILabel()
        phoneContactLabel.textAlignment = .left
        phoneContactLabel.translatesAutoresizingMaskIntoConstraints = false
        return phoneContactLabel
    }()
    
    let companyContactLabel: UILabel = {
        let companyContactLabel = UILabel()
        companyContactLabel.textAlignment = .left
        companyContactLabel.translatesAutoresizingMaskIntoConstraints = false
        return companyContactLabel
    }()
    
    let imageContact: UIImageView = {
        let imageContact = UIImageView()
        imageContact.clipsToBounds = true
        return imageContact
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameContactLabel)
        addSubview(phoneContactLabel)
        addSubview(companyContactLabel)
        addSubview(imageContact)
        
        let imageStack = UIStackView(arrangedSubviews: [imageContact])
        imageStack.distribution = .equalSpacing
        imageStack.axis = .vertical
        imageStack.spacing = 2
        imageStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageStack)
        
        NSLayoutConstraint.activate([
            imageStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            imageStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageStack.widthAnchor.constraint(equalToConstant: 70),
            imageStack.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [nameContactLabel, phoneContactLabel, companyContactLabel])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: imageStack.rightAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with contact: CNContact, cell: ContactCell) {
        cell.nameContactLabel.text = String(contact.givenName + " " + contact.familyName + " " + contact.middleName)
        if let currentPhone = contact.phoneNumbers.first {
            cell.phoneContactLabel.text = currentPhone.value.stringValue
        } else {
            cell.phoneContactLabel.text = ""
        }
        cell.companyContactLabel.text = contact.organizationName
        
        if let currentImageContact = contact.imageData {
            cell.imageContact.image = UIImage(data: currentImageContact)
        } else {
            cell.imageContact.image = UIImage(named: "Photo")
        }
        
        
    }
}
