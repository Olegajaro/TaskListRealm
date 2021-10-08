//
//  TaskListViewController.swift
//  TaskListRealm
//
//  Created by Олег Федоров on 08.10.2021.
//

import UIKit

class TaskListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createTempData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)

        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        
    }
    
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }
}

extension TaskListViewController {
    
    private func showAlert() {
        let alert = UIAlertController.createAlertController(withTittle: "New List", andMessage: "Please insert new value")
        
        alert.action { newValue in
            
        }
        
        present(alert, animated: true)
    }
}
