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
        MessageController.shared.saveMessageRecordToiCloudWith(text: messageText)
    }
    
    
    //MARK: - Helper Methods
    @objc func reloadViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
