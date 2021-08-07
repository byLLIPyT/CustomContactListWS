//
//  MainTableViewController.swift
//  CustomContactListWS
//
//  Created by Александр Уткин on 07.08.2021.
//

import UIKit
import Contacts
import ContactsUI

class MainTableViewController: UITableViewController {

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
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: CellIdentifier.cellIdentifier)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "find"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        configureRefreshControl()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let number = filteredData[indexPath.row].phoneNumbers.first?.value.stringValue {
            contactManager.callNumber(number: number, vc: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Messages.cellIdentifier.rawValue, for: indexPath) as! ContactCell
        cell.configure(with: filteredData[indexPath.row], cell: cell)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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

}

extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            filterContentForSearchText(text)
        }
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
//        filteredCitiesArray = citiesArray.filter {
//            $0.name.contains(searchText)
//        }
        tableView.reloadData()
    }
}
