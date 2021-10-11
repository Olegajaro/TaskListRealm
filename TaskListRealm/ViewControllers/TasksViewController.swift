//
//  TasksViewController.swift
//  TaskListRealm
//
//  Created by Олег Федоров on 08.10.2021.
//

import RealmSwift
import Foundation

class TasksViewController: UITableViewController {
    
    var taskList: TaskList!
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = taskList.name
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTasks = taskList.tasks.filter("isComplete = true")
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TasksCell",
            for: indexPath
        )
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] :
        completedTasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = task.name
        content.secondaryText = task.note
        
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] :
        completedTasks[indexPath.row]
        
        let title = indexPath.section == 0 ? "Done" : "Undone"

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { _, _, _ in
            StorageManager.shared.delete(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Edit"
        ) { _, _, isDone in
            self.showAlert(with: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(
            style: .normal,
            title: title
        ) { _, _, isDone in
            StorageManager.shared.changeStatus(task)
            if indexPath.section == 0 {
                tableView.moveRow(
                    at: IndexPath(row: indexPath.row, section: 0),
                    to: IndexPath(row: 0, section: 1)
                )
            } else {
                tableView.moveRow(
                    at: IndexPath(row: indexPath.row, section: 1),
                    to: IndexPath(row: 0, section: 0))
            }
            isDone(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.9144874811, green: 0.4221930504, blue: 0, alpha: 1)
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

            return UISwipeActionsConfiguration(
                actions: [doneAction, editAction, deleteAction]
            )
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
}

// MARK: - AlertController
extension TasksViewController {
    
    private func showAlert(
        with task: Task? = nil,
        completion: (() -> Void)? = nil
    ) {
        var title = "New Task"
        
        if task != nil { title = "Update Task" }
        
        let alert  = AlertController.createAlertController(
            withTittle: title,
            andMessage: "What do you want to do?"
        )
        
        alert.action(with: task) { newValue, note in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(
                    task,
                    newTask: newValue,
                    newNote: note
                )
                completion()
            } else {
                self.saveTask(withName: newValue, andNote: note)
            }
        }
    
        present(alert, animated: true)
    }
    
    private func saveTask(withName name: String, andNote note: String) {
        let task = Task(value: [name, note])
        StorageManager.shared.save(task, to: taskList)
        let rowIndex = IndexPath(
            row: currentTasks.index(of: task) ?? 0,
            section: 0
        )
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
