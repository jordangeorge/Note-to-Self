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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    // MARK: - Functions
    
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
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Views

    func setupViews() {
        view.addSubview(usernameLabel)
        view.addSubview(infoLabel)
        view.addSubview(cancelButton)
        
        setupUsernameLabel()
        setupInfoLabel()
        setupCancelButton()
    }
    
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
        usernameLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/6.5).isActive = true //90
        usernameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(view.bounds.width/13)).isActive = true //-24
        infoLabel.heightAnchor.constraint(equalToConstant: view.bounds.height/5).isActive = true //90
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
        infoLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: view.bounds.height/14).isActive = true //40
        infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(view.bounds.width/13)).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: view.bounds.height/1.6).isActive = true //345
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
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.height/47.5).isActive = true //12
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/28.4).isActive = true //20
        cancelButton.widthAnchor.constraint(equalToConstant: view.bounds.height/19).isActive = true //30
        cancelButton.heightAnchor.constraint(equalToConstant: view.bounds.height/19).isActive = true //30
    }
}
