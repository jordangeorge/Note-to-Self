//
//  Header.swift
//  Note to Self
//
//  Created by Jordan George on 10/15/17.
//  Copyright © 2017 Jordan George. All rights reserved.
//

import UIKit

class Header: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    var tableVC: TableViewController!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        noteTextField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let noteTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter note here"
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var addlistItembutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add note", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        
        return button
    }()
    
    func setupViews() {
        addSubview(noteTextField)
        addSubview(addlistItembutton)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": noteTextField, "v1": addlistItembutton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": noteTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": addlistItembutton]))
    }
    
    func addNote() {
        let note = noteTextField.text
        
        if (note?.isEmpty)! {
            print("need to enter item")
        } else if (note?.characters.count)! > 40 {
            tableVC.alert(title: "Error", message: "Too many characters for note.")
        } else {
            tableVC.addNote(note: note!)
            noteTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addNote()
        //        textField.resignFirstResponder()
        return true
    }
    
}

