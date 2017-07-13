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

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        
        print("self.extensionContext!.inputItems = (self.extensionContext!.inputItems)")
        
        var audioFound :Bool = false
        for inputItem: Any in self.extensionContext!.inputItems {
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
                                                                
                                                                if let audioURL = audioURL as? NSURL {
                                                                    
                                                                    let sharedContainerDefaults = UserDefaults.init(suiteName:
                                                                        "group.com.ananyabhat.transcribble.sharedcontainer")  // must match the name chosen above
                                                                    sharedContainerDefaults?.set(audioURL as URL, forKey: "SharedAudioURLKey")
                                                                    sharedContainerDefaults?.synchronize()
                                                                     
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
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
