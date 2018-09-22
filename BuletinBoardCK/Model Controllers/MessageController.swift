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
    
    
    
    func fetchMessagesRecordsFromiCloud() {
        
        CloudKitManager.shared.fetchRecordsOf(type: Message.TypeKey, database: CKContainer.default().publicCloudDatabase) { (records, error) in
            if let error = error {
                print("There was an error fetching message records from iCloud \(error.localizedDescription)")
            }
            
            guard let records = records else {
            print("No Records")
                return
            }
            
            // flat map goes thru all the messages returned from iCloud, and only keeps good ones, removing any nil values
            let messages = records.compactMap({Message(cloudKitRecord: $0)})
            
            self.messages = messages
            // since we have notification center set up, we dont have to do anything to reload the table view,
            //as soon as messages get asigned with new values that notification center will notify the viewDidLoad, and its gone call the updateViews function that reload the table views with new data
        }
    }
    
    
    

    
    
    
    
    
    
    
}



//MARK: - Steps for save and fetch functions:

//SAVE

//#1 Initialize new message object
//#2 Use a CloudKitManager function to save the message's CKRecords
//#3 Check for errors
//#4 If there are no errors, then append the message to the message array

//FETCH

//#1 Use a CloudKitManager function to fetch Message records from the right database
//#2 Check for errors in the completion
//#3 Take the records returned and initialize Message objects from them.
//#4 Set the newly created messages in the MessageController's array of Messages
