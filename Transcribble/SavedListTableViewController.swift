//
//  savedListViewController.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/10/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import UIKit
import FirebaseDatabase


class SavedListTableViewController: UITableViewController {
    
    var posts = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("posts").child(User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            self.tableView.reloadData()
        })
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
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
