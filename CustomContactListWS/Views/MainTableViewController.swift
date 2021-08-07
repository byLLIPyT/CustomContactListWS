//
//  MainTableViewController.swift
//  CustomContactListWS
//
//  Created by Александр Уткин on 07.08.2021.
//

import UIKit
import Contacts
import ContactsUI

class MainTableViewController: UITableViewController, UISearchBarDelegate {
    
    private var refControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    private var allContacts: [CNContact] = []
    private let contactManager = Contact()
    private var filteredData: [CNContact]  = []
    
    var searchBarisEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarisEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPrivacy()
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: CellIdentifier.cellIdentifier)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        configureRefreshControl()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredData.count
        }
        return allContacts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if isFiltering {
            if let number = filteredData[indexPath.row].phoneNumbers.first?.value.stringValue {
                contactManager.callNumber(number: number, vc: self)
            }
        } else {
            if let number = allContacts[indexPath.row].phoneNumbers.first?.value.stringValue {
                contactManager.callNumber(number: number, vc: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.cellIdentifier, for: indexPath) as! ContactCell
        if isFiltering {
            cell.configure(with: filteredData[indexPath.row], cell: cell)
            return cell
        } else {
            cell.configure(with: allContacts[indexPath.row], cell: cell)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
        
    private func configureRefreshControl() {
        refControl.attributedTitle = NSAttributedString(string: "Refresh")
        refControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refControl)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            //self.filteredData = self.contactManager.getAllContacts()
            self.tableView.reloadData()
        }
        refControl.endRefreshing()
    }
    
    private func checkPrivacy() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .authorized || status == .notDetermined {
            receiveContactList()
        }
    }
    
    private func receiveContactList() {
        allContacts = contactManager.getAllContacts()
        filteredData = allContacts
    }
}

extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            filterContentForSearchText(text)
        }
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredData = allContacts.filter {
            $0.givenName.contains(searchText)
        }
        tableView.reloadData()
    }
}
