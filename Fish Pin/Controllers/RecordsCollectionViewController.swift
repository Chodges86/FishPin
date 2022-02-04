//
//  RecordsCollectionViewController.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/4/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class RecordsCollectionViewController: UICollectionViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20  
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let recordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as? RecordCollectionViewCell {
            cell = recordCell
        }
       return cell
    }
}
