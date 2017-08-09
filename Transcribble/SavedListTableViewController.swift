//
//  savedListViewController.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/10/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import AVFoundation
import AVKit
import Speech


class Audio {
    var title = String()
    var link = String()
    var transcription = String()
    
    init(snapshot: DataSnapshot){
        if let snap = snapshot.value as? [String: String] {
            title = snap["title"]!
            link = snap["link"]!
            transcription = snap["transcription"]!
        }
    }
}

class SavedListTableViewController: UITableViewController, AVAudioPlayerDelegate {
    
        
    var posts : [Audio] = []
    
    func appendAudio() -> [Audio] {
        var audioFiles : [Audio] = []
        let audioRef = Database.database().reference().child("posts").child("\(User.current.uid)")
        audioRef.observe(.value, with: {(snapshot)-> Void in
            audioFiles = []
            for child in snapshot.children {
                audioFiles.append(Audio(snapshot: child as! DataSnapshot))
            }
            self.posts = audioFiles
            self.tableView.reloadData()
        })
        return audioFiles
    }
    
    func reload(){
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendAudio()

        
        
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
        cell.transcriptionTitle.text = self.posts[indexPath.row].title
        print("link: \(self.posts[indexPath.row].link)")

        
        return cell
    }
    
    
    
    var valueToPass:String!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get Cell Label
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = self.posts[indexPath.row].link
        print(valueToPass)
        performSegue(withIdentifier: "displayTranscription", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "displayTranscription") {
            print("Table view cell tapped")
            
            let indexPath = tableView.indexPathForSelectedRow!
            
            let data = indexPath.row
            print(data)
            let titleData = posts[indexPath.row].title
            
            let displayTranscriptionViewController = segue.destination as! DisplayTranscriptionViewController
            
            displayTranscriptionViewController.dataRecieved = data
            displayTranscriptionViewController.files = posts
            //displayTranscriptionViewController.titleData = titleData
        }
    }
}
