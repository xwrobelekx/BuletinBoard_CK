//
//  Message.swift
//  BuletinBoardCK
//
//  Created by Kamil Wrobel on 9/22/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation
import CloudKit


class Message {
    
    //
    static let TypeKey = "Message"
    private let TextKey = "text"
    private let TimestampKey = "timestamp"
    
    let text: String
    let timestamp: Date
    
    init(text: String, timestamp:Date){
        self.text = text
        self.timestamp = timestamp
    }
    
    // two thing are needed to set this up into a cloud kit. - converting between model, and CKRecord when fetching and uploading
    
    //#1 turn model object into something that cloud kit can work with - CKRecord
    //#2 and when we get CKRecord back, we need to convert it back to our object - using faliable inits
    
    //CKRecord is very similar to dictionary
    
    // so this turns our model into a CKRecord for cloud kit
    var cloudKitRecord: CKRecord {
        //what kind of th record its gone be
        let record = CKRecord(recordType: Message.TypeKey)
        
        //set the value - 2 different ways posible
        record.setValue(text, forKey: TextKey)
        record[TimestampKey] = timestamp as CKRecordValue
        
        //return the record
        return record
    }
    
    // failable init for fetching the records from cloud kit
    init?(cloudKitRecord: CKRecord) {
        
        guard let text = cloudKitRecord[TextKey] as? String,
            let timestamp = cloudKitRecord[TimestampKey] as? Date else {return nil}
        
        self.text = text
        self.timestamp = timestamp
    }
}
























