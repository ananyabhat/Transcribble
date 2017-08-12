//
//  ActionViewController.swift
//  TranscribbleActionExtension
//
//  Created by Ananya Bhat on 7/11/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//
import UIKit
import MobileCoreServices
import AVFoundation
import AVKit
import FirebaseStorage
import FirebaseDatabase
import Firebase
import FirebaseAuth
import FirebaseAuthUI

class ActionViewController: UIViewController {
    
    @IBOutlet weak var recordingTitleTextField: UITextField!
    
    typealias FIRUser = FirebaseAuth.User
    
    var passedInputItems = [Any]()
    var lvcontroller : LoginViewController? = nil
    
    var name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
   }
    
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func done() {
        name = self.recordingTitleTextField.text!
        var audioFound :Bool = false
        for inputItem: Any in passedInputItems {
            let extensionItem = inputItem as! NSExtensionItem
            for attachment: Any in extensionItem.attachments! {
                let itemProvider = attachment as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeMPEG4Audio as String)
                {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeMPEG4Audio as String,
                                          options: nil, completionHandler: { (audioURL, error) in
                                            OperationQueue.main.addOperation {
                                                
                                                if let audioURL = audioURL as? URL {
                                                    
                                                    
                                                    
                                                    let dateFormatter = ISO8601DateFormatter()
                                                    let timeStamp = dateFormatter.string(from: Date())
                                                    
                                                    let storageRef = Storage.storage().reference().child("vn/\(User.current.uid)/\(timeStamp).m4a")
                                                    let databaseRef = Database.database().reference().child("posts").child("\(User.current.uid)").child("\(self.name)")
                                                    
                                                    guard let audioData = NSData(contentsOf: audioURL) as? Data else {
                                                        return
                                                    }
                                                    
                                                    storageRef.putData(audioData, metadata: nil, completion: { (metadata, error) in
                                                        if let error = error {
                                                            print(error.localizedDescription)
                                                        }
                                                        let downloadURL = metadata?.downloadURL()
                                                        databaseRef.updateChildValues(["title" : self.recordingTitleTextField.text, "link":"\(timeStamp)", "transcription" : ""])
                                                        if (self.lvcontroller != nil) {
                                                            self.lvcontroller!.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
                                                        }
                                                    })
                                                    
                                                    
                                                    
                                                }
                                            }
                    })
                    
                    audioFound = true
                    break
                }
            }
            
            if (audioFound) {
                break
            }
        }

        self.dismiss(animated: true, completion: nil)
    }
    
 
    
    
}


