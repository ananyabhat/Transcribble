//
//  CreateUsernameViewController.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/10/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else {return}
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
            if let initialViewController = storyboard.instantiateInitialViewController(){
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
            
            self.dismissKeyboard()
            
        }    }
    
 
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
