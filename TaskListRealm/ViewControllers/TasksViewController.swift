//
//  TasksViewController.swift
//  TaskListRealm
//
//  Created by Олег Федоров on 08.10.2021.
//

import UIKit

class TasksViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)

        return cell
    }
    
    private func addButtonPressed() {
        showAlert()
    }
}

extension TasksViewController {
    
    private func showAlert() {
        
        let alert  = UIAlertController.createAlertController(withTittle: "New Task", andMessage: "What do you want to do?")
        
        alert.action { newValue, note in
            
        }
    
        present(alert, animated: true)
        
    }
    
}
