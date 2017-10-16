//
//  InfoViewController.swift
//  Note to Self
//
//  Created by Jordan George on 10/16/17.
//  Copyright © 2017 Jordan George. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        getUsername()
    }
    
    // MARK: - Functions
    
    func setupViews() {
        view.addSubview(usernameLabel)
        view.addSubview(infoLabel)
        view.addSubview(cancelButton)
        setupUsernameLabel()
        setupInfoLabel()
        setupCancelButton()
    }
    
    func getUsername() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                let username = values["username"] as? String
                self.usernameLabel.text?.append(username!)
            }
        })
    }
    
    
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Views
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Logged in as "
        return label
    }()
    
    func setupUsernameLabel() {
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        usernameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        let height = view.bounds.height / 5
        print(height)
        infoLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 6
        label.text = "Welcome to Note to Self. This is a basic note taking app. Use it as a todo list or to jot things down. Enjoy!\n\n–- Jordan George"
        return label
    }()
    
    func setupInfoLabel() {
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 40).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        let height = view.bounds.height / 5
        infoLabel.heightAnchor.constraint(equalToConstant: height*3).isActive = true
    }
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        button.addGestureRecognizer(tap)
        
        return button
    }()
    
    func setupCancelButton() {
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
