//
//  StorageService.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/20/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import UIKit
import FirebaseStorage

struct StorageService {
    static func uploadAudio(_ audio: URL, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        
        reference.putFile(from: audio, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            completion(metadata?.downloadURL())
        })
    }
}
