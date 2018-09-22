//
//  MessageController.swift
//  BuletinBoardCK
//
//  Created by Kamil Wrobel on 9/22/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation
import CloudKit



class MessageController {
    
    //MARK: - Singelton
    static let shared = MessageController()
    
    //MARK: - Notification
    let messagesWereUpdatedNotification = Notification.Name("messagesWereUpdated")
    
    //MARK: - Source Of Truth with did set for notifications
    var messages: [Message] = [] {
        didSet{
            //if anythhing changes in messages (something get added or removed) this will get called
            NotificationCenter.default.post(name: messagesWereUpdatedNotification, object: nil)
        }
    }
    
    
    //MARK: - Save method to iCloud
    
    //save message records to icloud
    func saveMessageRecordToiCloudWith(text: String) {
        
        let message = Message(text: text)
        
        // we need an instace of cloud kit manager - therefore were gone make a shared instance in cloud kit manager
        //this way we can acces the save function from clodKit manager thru shared instance
        //also here were specifing the data base we want to use
        
        CloudKitManager.shared.saveRecordToCloudKit(record: message.cloudKitRecord, database: CKContainer.default().publicCloudDatabase) { (error) in
            if let error = error {
                print("There was an error saving message to iCloud on function: \(#function): \(error) \(error.localizedDescription)")
                // for beter user expirience you may want to present an alert to the user and infrom him of what he could to to prevent it based on that the error is
            } else {
                self.messages.append(message)
            }
            
        }
    }
    
    
    
    
    
    
    
    
}
