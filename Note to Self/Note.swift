//
//  Note.swift
//  Note to Self
//
//  Created by Jordan George on 10/15/17.
//  Copyright © 2017 Jordan George. All rights reserved.
//


import UIKit
import FirebaseDatabase

class Note: NSObject {
    
    var text: String?
    var timestramp: NSNumber?
    var key: String!
    
    init(snapshot: FIRDataSnapshot) {
        if let dictionary = snapshot.value as? [String : AnyObject] {
            self.text = dictionary["text"] as? String
            self.timestramp = dictionary["timestamp"] as? NSNumber
        }
        
        self.key = snapshot.key
    }
    
}





