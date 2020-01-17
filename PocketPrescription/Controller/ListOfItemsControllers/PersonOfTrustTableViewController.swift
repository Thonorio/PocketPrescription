//
//  PersonOfTrustTableViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 17/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import UIKit
import CoreData

class PersonOfTrustTableViewController: ListOfItemsTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet var searchBar: UISearchBar!
    
    let ENTITIE: String = "PersonOfTrust"
    var allPersonsOfTrust: [NSManagedObject] = []
    
    @IBOutlet var personOfTrustTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell registation
        let nibName = UINib(nibName: "PersonOfTrustTableViewCell", bundle: nil)
        personOfTrustTableView.dataSource = self
        personOfTrustTableView.delegate = self
        personOfTrustTableView.register(nibName, forCellReuseIdentifier: "personOfTrustTableViewCell")
        personOfTrustTableView.rowHeight = 74.0
        
        // Search Bar
        searchBar.delegate=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Refresh
        allPersonsOfTrust = self.loadData(ENTITIE, "name")
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPersonsOfTrust.count
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        allPersonsOfTrust = self.searchInformation(textDidChange: searchText, ENTITIE)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "personOfTrustTableViewCell", for: indexPath) as? PersonOfTrustTableViewCell else {
            fatalError("The dequeued cell is not an instance of PersonOfTrustTableViewCell.")
        }
        
        // Atributes medication based on the inde
        let personOfTrust = self.allPersonsOfTrust[indexPath.row]
        cell.personOfTrustViewInit(personOfTrust)
        cell.coreDataContext = self.context
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //Remove Core Data
            context.delete(allPersonsOfTrust[indexPath.row])
            
            //Remove from list
            allPersonsOfTrust.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)

            saveToCoreData()
        }
    }
    
    // MARK: - Interactions
    @IBAction func unwindToThisViewController(sender: UIStoryboardSegue) {}
}
