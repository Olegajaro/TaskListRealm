//
//  TaskListViewController.swift
//  TaskListRealm
//
//  Created by Олег Федоров on 08.10.2021.
//

import RealmSwift
import Combine

class TaskListViewController: UITableViewController {
    
    private var taskLists: Results<TaskList>!

    override func viewDidLoad() {
        super.viewDidLoad()

        createTempData()
        taskLists = StorageManager.shared.realm.objects(TaskList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        taskLists.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TaskListCell",
            for: indexPath
        )
        let taskList = taskLists[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = taskList.name
        if taskList.tasks.filter("isComplete = false").count == 0 &&
            taskList.tasks.filter("isComplete = true").count > 0 {
            content.secondaryText = "✅"
        } else {
            content.secondaryText = "\(taskList.tasks.filter("isComplete = false").count)"
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let taskList = taskLists[indexPath.row]
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { _, _, _ in
            StorageManager.shared.delete(taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Edit"
        ) { _, _, isDone in
            self.showAlert(with: taskList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(
            style: .normal,
            title: "Done"
        ) { _, _, isDone in
            StorageManager.shared.done(taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.9144874811, green: 0.4221930504, blue: 0, alpha: 1)
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(
            actions: [doneAction, editAction, deleteAction]
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let tasksVC = segue.destination as? TasksViewController else { return }
        let taskList = taskLists[indexPath.row]
        tasksVC.taskList = taskList
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            taskLists = taskLists.sorted(byKeyPath: "date", ascending: true)
        case 1:
            taskLists = taskLists.sorted(byKeyPath: "name", ascending: true)
        default:
            break
        }
        tableView.reloadData()
    }
    
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }
}

// MARK: - AlertController
extension TaskListViewController {
    
    private func showAlert(
        with taskList: TaskList? = nil,
        completion: (() -> Void)? = nil
    ) {
        let alert = AlertController.createAlertController(
            withTittle: "New List",
            andMessage: "Please insert new value"
        )
        
        alert.action(with: taskList) { newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.edit(taskList, newValue: newValue)
                completion()
            } else {
                self.save(newValue)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func save(_ taskList: String) {
        let taskList = TaskList(value: [taskList])
        StorageManager.shared.save(taskList)
        let rowIndex = IndexPath(
            row: taskLists.index(of: taskList) ?? 0,
            section: 0
        )
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
