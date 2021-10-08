//
//  TasksViewController.swift
//  TaskListRealm
//
//  Created by Олег Федоров on 08.10.2021.
//

import RealmSwift

class TasksViewController: UITableViewController {
    
    var taskList: TaskList!
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = taskList.name
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTasks = taskList.tasks.filter("isComplete = true")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = task.name
        content.secondaryText = task.note
        
        cell.contentConfiguration = content
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
