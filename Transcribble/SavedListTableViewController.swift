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
    
    @IBOutlet var uploadView: UIView!
        
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
        
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedListTableViewCell", for: indexPath) as! SavedListTableViewCell
        
        cell.transcriptionTitle.text = self.posts[indexPath.row].title

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var post = posts[indexPath.row]
            let storageRef = Storage.storage().reference().child("vn/\(User.current.uid)/\(post.link).m4a")
            storageRef.delete(completion: { error in
                if error != nil {
                    print("error \(error)")
                }
            })
            let ref = Database.database().reference()
            ref.child("posts").child("\(User.current.uid)").child("\(post.title)").removeValue { error in
                if error != nil {
                    print("error \(error)")
                }
            }

        }
    }
    
    
    var valueToPass:String!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = self.posts[indexPath.row].link
        performSegue(withIdentifier: "displayTranscription", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "displayTranscription") {
            
            let indexPath = tableView.indexPathForSelectedRow!
            
            let data = indexPath.row
            let titleData = posts[indexPath.row].title
            
            let displayTranscriptionViewController = segue.destination as! DisplayTranscriptionViewController
            
            displayTranscriptionViewController.dataRecieved = data
            displayTranscriptionViewController.files = posts
        } else if (segue.identifier == "showProfile"){
        let profileViewController = segue.destination as! ProfileViewController
        profileViewController.transcriptionsNumber = posts.count
        }
    }
    
    func animateInAgain() {
        self.view.addSubview(uploadView)
        uploadView.center = self.view.center
        uploadView.isHidden = false
        uploadView.alpha = 0
        
        
        
        UIView.animate(withDuration: 0.4) {
            self.uploadView.layer.borderWidth = 1
            self.uploadView.layer.borderColor =  UIColor(red:0.97, green:0.54, blue:0.57, alpha:1.0).cgColor
            self.uploadView.alpha = 1
            self.uploadView.transform = CGAffineTransform.identity
            
        }
        
    }

    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        uploadView.isHidden = true
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first as! UITouch
                if touch?.view != uploadView {
            uploadView.isHidden = true
        }
        
    }
    
    
    @IBAction func settingsTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showProfile", sender: self)
    }
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        animateInAgain()
    }
    
}
