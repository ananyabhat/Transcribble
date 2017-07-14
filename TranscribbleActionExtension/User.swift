//
//  User.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/14/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot


class User {
    
    private static var _current: User?
    
    static var current: User{
        guard let currentUser = _current else{
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    static func setCurrent(_ user: User){
        _current = user
    }
    
    let uid: String
    let username: String
    
    init(uid: String, username: String){
        self.uid = uid
        self.username = username
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else{return nil}
        self.uid = snapshot.key
        self.username = username
    }
}
