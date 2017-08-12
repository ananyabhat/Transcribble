//
//  Profile.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/11/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var infoView: UIView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var transcriptionNumberLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    var transcriptionsNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let username = snapshot.childSnapshot(forPath: (Auth.auth().currentUser?.uid)!).childSnapshot(forPath: "username").value
            self.usernameLabel.text = "\(username!)"
           
        })
        
        
        
        transcriptionNumberLabel.text = "\(transcriptionsNumber)"
        
        
        
        imageView.setRounded()

    }
    
    

    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do{
                try? Auth.auth().signOut()
                
                if Auth.auth().currentUser == nil {
                    let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    
                    self.present(loginVC, animated: true, completion: nil)
                }
            }
        }

    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        animateInAgain()
    }
    
    func animateInAgain() {
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.isHidden = false
        infoView.alpha = 0
        
        
        
        UIView.animate(withDuration: 0.4) {
            self.infoView.layer.borderWidth = 2
            self.infoView.layer.borderColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0).cgColor
            self.infoView.alpha = 1
            self.infoView.transform = CGAffineTransform.identity
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            var touch: UITouch? = touches.first as! UITouch
            if touch?.view != infoView {
                infoView.isHidden = true
            }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}


