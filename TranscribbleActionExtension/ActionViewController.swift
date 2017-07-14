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
//                                                    let fileName = NSUUID().uuidString + ".m4a"
//                                                    let fireStorage = Storage.storage()
//                                                    let uid = FIRUser.
//                                                    fireStorage.reference().child("voicemessages/posts/\(uid)/").child(fileName).putFile(from: audioURL, metadata: nil) { (metadata, error) in
//                                                        if error != nil {
//                                                            print(error ?? "error")
//                                                        }
//                                                        
//                                                        if let downloadUrl = metadata?.downloadURL()?.absoluteString {
//                                                            print(downloadUrl)
//                                                            let values: [String : Any] = ["audioUrl": downloadUrl]
//                                                        }
//                                                    }
                                                    
                                                    
                                                    //
                                                    //                                                    let sharedContainerDefaults = UserDefaults.init(suiteName:
                                                    //                                                        "group.com.ananyabhat.transcribble.sharedcontainer")  // must match the name chosen above
                                                    //                                                    sharedContainerDefaults?.set(audioURL as URL, forKey: "SharedAudioURLKey")
                                                    //                                                    sharedContainerDefaults?.synchronize()
                                                    
                                                    //                                                    let theAVPlayer :AVPlayer = AVPlayer(url: audioURL)
                                                    //                                                    let theAVPlayerViewController :AVPlayerViewController = AVPlayerViewController()
                                                    //                                                    theAVPlayerViewController.player = theAVPlayer
                                                    //                                                    self.present(theAVPlayerViewController, animated: true) {
                                                    //                                                        theAVPlayerViewController.player!.play()
                                                    //                                                    }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: passedInputItems, completionHandler: nil)
    }

}
