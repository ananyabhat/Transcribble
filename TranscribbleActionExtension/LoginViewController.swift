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

    var window: UIWindow?

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
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        self.view.isHidden = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: Constants.UserDefaults.currentUser) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
            User.setCurrent(user)
            self.performSegue(withIdentifier: "loginToAction", sender: self)
        } else {
            self.view.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateUsername"{
            let destination = segue.destination as! CreateUsernameViewController
            destination.passedInputItems = (self.extensionContext?.inputItems)!
            destination.lvcontroller = self
        }
        if segue.identifier == "loginToAction"{
            let destination = segue.destination as! ActionViewController
            destination.passedInputItems = (self.extensionContext?.inputItems)!
            destination.lvcontroller = self
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
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                User.setCurrent(user, writeToUserDefaults: true)
                self.performSegue(withIdentifier: "loginToAction", sender: self)
                
                
            }else{
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        }
    }
}
