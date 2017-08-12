//
//  CreateUsernameController.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/14/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var lvcontroller : LoginViewController? = nil
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = textField.text,
            !username.isEmpty else {return}
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            self.performSegue(withIdentifier: "createToAction", sender: self)
            
        }
    }
    
    var passedInputItems = [Any]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createToAction"{
            let destination = segue.destination as! ActionViewController
            destination.passedInputItems = self.passedInputItems
            destination.lvcontroller = self.lvcontroller
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
