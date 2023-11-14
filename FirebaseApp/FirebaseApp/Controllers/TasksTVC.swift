//
//  TasksTVC.swift
//  FirebaseApp
//
//  Created by Roman Litvinovich on 14/11/2023.
//

import UIKit
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class TasksTVC: UITableViewController {

    private var user: User!
    private var tasks = [Task]()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] snapshot in
            var tasks = [Task]()
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let task = Task(snapshot: snapshot) else { return }
                tasks.append(task)
            }
            self?.tasks = tasks
            self?.tableView.reloadData()
        }
    }
    

    @IBAction func addNewTaskAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New task", message: "Add new task title", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self,
                  let textField = alertController.textFields?.first,
                  let text = textField.text else { return }
            let uid = user.uid
            let task = Task(title: text, userId: uid)
            let taskRef = ref.child(task.title.lowercased())
            taskRef.setValue(task.convertToDictionary())
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancel)
        alertController.addAction(save)
        present(alertController, animated: true)
    }
    
  
    @IBAction func signOutAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addImageAction(_ sender: UIBarButtonItem) {
    }
    
    
        private func toggleColetion(cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentTask = tasks[indexPath.row]
        cell.textLabel?.text = currentTask.title
        toggleColetion(cell: cell, isCompleted: currentTask.completed)
        return cell
    }
    //криво 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            let taskRef = ref.child(task.title.lowercased())
            
                taskRef.removeValue { error, _ in
                if let error = error {
                    print("Error removing task: \(error.localizedDescription)")
                    return
                }
                self.tasks.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
