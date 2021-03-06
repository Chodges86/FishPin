//
//  DataModel.swift
//  Fish Pin
//
//  Created by Caleb Hodges on 2/6/22.
//

import Foundation
import UIKit
import CoreData

class DataModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var records = [Record]()

    
    func saveRecord() {
        
        do {
            try context.save()
        } catch {
            //TODO: Handle error
            print("Error saving to CoreData \(error)")
        }
    }
    
    func loadRecord(with request: NSFetchRequest<Record> = Record.fetchRequest()) {
        
        do {
            records = try context.fetch(request)
        } catch {
            //TODO: Handle error
            print("Error loading records \(error)")
        }
        
    }
    
    func getDateTime() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MM/dd/yy  h:mm a"
        let currentDate = dateFormatter.string(from: date)
        
        let dateTime = "\(currentDate)"
        
        return dateTime
        
    }
}
