//
//  savedListViewController.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/10/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import UIKit


let sharedContainerDefaults = UserDefaults.init(suiteName:
    "group.com.mycompany.myapp.sharedcontainer")  // must match the name chosen above
let audioURL :NSURL? = sharedContainerDefaults?.url(forKey: "SharedAudioURLKey") as NSURL?

var extensionContext: NSExtensionContext?



class SavedListTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(audioURL)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // 2
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedListTableViewCell", for: indexPath) as! SavedListTableViewCell
        
        // 2
        cell.transcriptionTitle.text = "Transcription's title"
        cell.timeCreatedLabel.text = "Time created"
        
        return cell
    }
    
   
}
