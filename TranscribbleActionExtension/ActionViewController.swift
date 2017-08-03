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
        print("action")
        print(passedInputItems)
        
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        
        print("self.extensionContext!.inputItems = \(passedInputItems)")
        
   }
    
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        name = self.recordingTitleTextField.text!
        var audioFound :Bool = false
        for inputItem: Any in passedInputItems {
            let extensionItem = inputItem as! NSExtensionItem
            for attachment: Any in extensionItem.attachments! {
                print("attachment = \(attachment)")
                let itemProvider = attachment as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeMPEG4Audio as String)
                    //|| itemProvider.hasItemConformingToTypeIdentifier(kUTTypeMP3 as String)
                    // the audio format(s) we expect to receive and that we can handle
                {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeMPEG4Audio as String,
                                          options: nil, completionHandler: { (audioURL, error) in
                                            OperationQueue.main.addOperation {
                                                
                                                if let audioURL = audioURL as? URL {
                                                    
                                                    print("LOOK! AN AUDIO URL: \(audioURL)")
                                                    
                                                    
                                                    print("UID : \(User.current.uid)")
                                                    let dateFormatter = ISO8601DateFormatter()
                                                    let timeStamp = dateFormatter.string(from: Date())
                                                    
                                                    let storageRef = Storage.storage().reference().child("vn/\(User.current.uid)/\(timeStamp).m4a")
                                                    //CHANGE EVERYTHING FROM SONG
                                                    let databaseRef = Database.database().reference().child("posts").child("\(User.current.uid)").child("\(self.name)")
                                                    
                                                    guard let audioData = NSData(contentsOf: audioURL) as? Data else {
                                                        return
                                                    }
                                                    storageRef.putData(audioData, metadata: nil, completion: { (metadata, error) in
                                                        if let error = error {
                                                            print(error.localizedDescription)
                                                        }
                                                        print("title=\(self.name)")
                                                        let downloadURL = metadata?.downloadURL()
                                                        databaseRef.updateChildValues(["title" : self.recordingTitleTextField.text, "link":"\(timeStamp)", "transcription" : ""])
                                                    })
                                                    
                                                    
                                                    
                                                }
                                            }
                    })
                    
                    audioFound = true
                    break
                }
            }
            
            if (audioFound) {
                break  // we only handle one audio recording at a time, so stop looking for more
            }
        }
        if (lvcontroller != nil) {
            lvcontroller!.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
}


//
//                                                    let sharedContainerDefaults = UserDefaults.init(suiteName:
//                                                        "group.com.ananyabhat.transcribble.sharedcontainer")  // must match the name chosen above
//                                                    sharedContainerDefaults?.set(audioURL as URL, forKey: "SharedAudioURLKey")
//                                                    sharedContainerDefaults?.synchronize()

//
