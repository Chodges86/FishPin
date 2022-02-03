//
//  AddEntryViewController.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/3/22.
//

import UIKit

class AddEntryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let entryFieldTitles = ["Fish Type", "Weight", "Length", "Lure", "Weather", "Time", "Date:", "Notes:"]
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        self.registerEntryTableViewCell()
        
    }
    
    func registerEntryTableViewCell() {
        
        let entryCell = UINib(nibName: "EntryTableViewCell", bundle: nil)
        self.tableView.register(entryCell, forCellReuseIdentifier: "EntryTableViewCell")
        
    }
}

// MARK: - TableView Datasource Methods

extension AddEntryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryFieldTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryField", for: indexPath) as! EntryTableViewCell
        
        cell.entryField.placeholder = entryFieldTitles[indexPath.row]
        
        return cell
        
    }
}
