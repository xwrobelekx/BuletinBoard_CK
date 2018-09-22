//
//  CloudKitManager.swift
//  BuletinBoardCK
//
//  Created by Kamil Wrobel on 9/22/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation
import CloudKit


// purpose of this  is...?

class CloudKitManager {
    
    
    //this func saves the record to cloud, and it lets us enter if we want to use private or public data base - and then completion
    func saveRecordToCloudKit(record: CKRecord, database: CKDatabase, completion: @escaping (Error?) -> Void = {_ in}) {
        //whats the purpose of this?
        //
        database.save(record) { (_, error) in
            completion(error)
        }
    }
    
    
    func fetchRecordsOf(type: String, database: CKDatabase, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        //#1 what record we want back: - "fetch records that are from me or have word hello"
        let predicate = NSPredicate(value: true) // this will allow us to create some sord of criteria for fetching - value true- fetches everything
        
        // this tell to fetch the message.TypeKey with the predycate ("cryteria") which right now is set fo fetch them all
        let query = CKQuery(recordType: Message.TypeKey, predicate: predicate)
        
        //now we need to give the cloud kit those cryteria so it can get that data for us, or an error if something goes wrong
        database.perform(query, inZoneWith: nil, completionHandler: completion)
        
        
    }
    
    
    //next wideo will add subscriptions and discoveribility
    
    
    
    
    
    
}




































