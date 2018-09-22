//
//  BuletinListTableViewController.swift
//  BuletinBoardCK
//
//  Created by Kamil Wrobel on 9/22/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class BuletinListTableViewController: UITableViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var messageTextField: UITextField!
    
    
    //MARK: - LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this listens for any notifications, and it will call a helper method to reload the table view
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: MessageController.shared.messagesWereUpdatedNotification, object: nil)
        
        //indycates the netwok activity - turn it of before you update the tebleView - since you have the data back
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //fetch records form iCloud
        MessageController.shared.fetchMessagesRecordsFromiCloud()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.shared.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        let message = MessageController.shared.messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.timestamp.dateAsString()
        return cell
    }
    
    
    //MARK: - Actions
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let messageText = messageTextField.text else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MessageController.shared.saveMessageRecordToiCloudWith(text: messageText)
        self.messageTextField.text = ""
        self.messageTextField.resignFirstResponder()
    }
    
    
    //MARK: - Helper Methods
    @objc func reloadViews() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
}
