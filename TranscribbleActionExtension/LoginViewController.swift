//
//  LoginViewController.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/14/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuthUI
import Firebase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        print("self.extensionContext!.inputItems = \(self.extensionContext!.inputItems)")

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateUsername"{
            let destination = segue.destination as! CreateUsernameViewController
            destination.passedInputItems = (self.extensionContext?.inputItems)!
        }else if segue.identifier == "loginToAction"{
            let destination = segue.destination as! ActionViewController
            destination.passedInputItems = (self.extensionContext?.inputItems)!
        }
    }
    
    
}
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?){
        if let error = error{
            assertionFailure("Error signing in: \(error.localizedDescription)")
        }
        
        guard let user = user
            else {return}
        let userRef = Database.database().reference().child("users").child(user.uid)
        userRef.observeSingleEvent(of: .value, with: {[unowned self] (snapshot) in
            if let user = User(snapshot: snapshot) {
                User.setCurrent(user)
                
                self.performSegue(withIdentifier: "loginToAction", sender: self)
                
                }else{
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        })
    }
}
