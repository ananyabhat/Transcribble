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
    
    @IBOutlet weak var imageView: UIImageView!
    
    typealias FIRUser = FirebaseAuth.User
    
    var passedInputItems = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("action")
        print(passedInputItems)
        
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        
        print("self.extensionContext!.inputItems = \(passedInputItems)")
        
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
                                                    
                                                    
                                                    //self.putInStorage(audioUrl: audioURL)
                                                    print("UID : \(User.current.uid)")
                                                    let dateFormatter = ISO8601DateFormatter()
                                                    let timeStamp = dateFormatter.string(from: Date())
                                                    
                                                    let storageRef = Storage.storage().reference().child("vn/\(User.current.uid)/\(timeStamp).mp3")
                                                    //CHANGE EVERYTHING FROM SONG
                                                    let databaseRef = Database.database().reference().child("posts").child("\(User.current.uid)").childByAutoId()
                                                
                                                    guard let audioData = NSData(contentsOf: audioURL) as? Data else {
                                                        return
                                                    }
                                                    storageRef.putData(audioData, metadata: nil, completion: { (metadata, error) in
                                                        if let error = error {
                                                            print(error.localizedDescription)
                                                        }
                                                        let downloadURL = metadata?.downloadURL()
                                                        databaseRef.updateChildValues(["title" : "Song", "link":"\(timeStamp)"])
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
    }
    
    func putInStorage(audioUrl: URL) {
        let audioRef = StorageReference.newPostAudioReference()
        StorageService.uploadAudio(audioUrl, at: audioRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            let urlString = downloadURL.absoluteString
            self.create(forURLString: urlString)
        }
    }
    
   func create(forURLString urlString: String) {
        //create new post in database
        let currentUser = User.current
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: passedInputItems, completionHandler: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}


//
//                                                    let sharedContainerDefaults = UserDefaults.init(suiteName:
//                                                        "group.com.ananyabhat.transcribble.sharedcontainer")  // must match the name chosen above
//                                                    sharedContainerDefaults?.set(audioURL as URL, forKey: "SharedAudioURLKey")
//                                                    sharedContainerDefaults?.synchronize()

//
