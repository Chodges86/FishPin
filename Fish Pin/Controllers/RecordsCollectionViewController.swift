//
//  RecordsCollectionViewController.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/4/22.
//

import UIKit


class RecordsCollectionViewController: UICollectionViewController {
    
    var recordsArray = [Record]()
    let dataModel = DataModel()
    var selectedRecord: Record?
    
    override func viewWillAppear(_ animated: Bool) {
        // Setup the navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        dataModel.loadRecord()
        recordsArray = dataModel.records
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
    }
//MARK - Collection View Delegate Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recordsArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        if let recordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as? RecordCollectionViewCell {
            
            if let image = UIImage(data: recordsArray[indexPath.row].image!) {
                recordCell.recordImage.image = image
            } else {
                recordCell.recordImage.image = UIImage(named: "FishPinLogo")
            }
            recordCell.recordDate.text = recordsArray[indexPath.row].dateTime
            
          
            return recordCell
        }
       return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRecord = recordsArray[indexPath.row]
        performSegue(withIdentifier: "RecordSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecordSegue" {
            let destVC = segue.destination as! EntryViewController
            destVC.recordToEdit = selectedRecord
        }
    }
}
