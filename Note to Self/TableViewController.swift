//
//  ViewController.swift
//  Note to Self
//
//  Created by Jordan George on 10/15/17.
//  Copyright © 2017 Jordan George. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TableViewController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = ""
        
        let leftBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfo))
        let rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        if let font = UIFont(name: "Heiti TC", size: 17) {
            leftBarButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
            rightBarButtonItem.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        }
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        tableView.register(NoteCell.self, forCellReuseIdentifier: cellId)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.sectionHeaderHeight = 50
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                              NSAttributedStringKey.font: UIFont(name: "Heiti TC", size: 24)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Note to Self"
        
        notes.removeAll()
        tableView.reloadData()
        observeNotes()
    }
    
    // MARK: - UITableView functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteCell
        
        let note = notes[indexPath.row]
        cell.nameLabel.text = note.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! Header
        header.tableVC = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // for deletion
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("notes")
        
        ref.child(notes[indexPath.row].key).removeValue { (error, ref) in
            
            if error != nil {
                self.alert(title: "Error", message: "Failed to delete note")
                return
            }
            
            self.notes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    // MARK: - Other
    
    @objc func showInfo() {
        present(InfoViewController(), animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    func addNote(note: String) {
        let uid = FIRAuth.auth()?.currentUser!.uid
        let ref = FIRDatabase.database().reference().child("users").child(uid!).child("notes")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text": note, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values)
        
        // FIXME: notes being printed twice after infoVC is presented and then exited
    }
    
    func observeNotes() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("notes")
        
        ref.observe(.childAdded, with: { (snapshot) in
 
            let note = Note(snapshot: snapshot)
            self.notes.insert(note, at: 0)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
        }, withCancel: nil)
    }
    
    @objc func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
    }
    
    func alert(title: String = "", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension UIColor {
    convenience init(red: Int = 0, green: Int = 0, blue: Int = 0, opacity: Int = 255) {
        precondition(0...255 ~= red   &&
            0...255 ~= green &&
            0...255 ~= blue  &&
            0...255 ~= opacity, "input range is out of range 0...255")
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(opacity)/255)
    }
}
