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
        let storageRef = Storage.storage().reference()
        let imageKey = NSUUID().uuidString
        let imageRef = storageRef.child(imageKey)
        guard let imageData = #imageLiteral(resourceName: "image.jpg").pngData() else { return }
    
        let uploadTask = imageRef.putData(imageData) { storageMetadata, error in
            print("\n storageMetadata: \n \(String(describing: storageMetadata)) \n")
            print("\n error: \n \(String(describing: error)) \n")
    
        let downloadTask = imageRef.getData(maxSize: 9999999999) { data, error in
            print("\n data: \n \(String(describing: data)) \n")
            print("\n error: \n \(String(describing: error)) \n")
            guard let image = UIImage(data: data!) else { return }
            
            }
        }
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isComplete = !task.completed
        
        task.ref.updateChildValues(["completed" : isComplete]) // записываем данные в ячейку
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let task = tasks[indexPath.row]
        task.ref.removeValue()
    }
    
}
