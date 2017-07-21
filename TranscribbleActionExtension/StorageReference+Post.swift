//
//  StorageReference+Post.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/20/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostAudioReference() -> StorageReference {
        //check if the uid works
        let uid = User.current.uid
        print("THIS IS THE UID: \(uid)")
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("vn/posts/\(uid)/\(timestamp).m4a")
    }
}
