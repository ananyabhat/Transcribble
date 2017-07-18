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
        FirebaseApp.configure()
        configureInitialRootViewController(for: window)
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
    
    func configureInitialRootViewController(for window: UIWindow?){
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: Constants.UserDefaults.currentUser) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
            
            User.setCurrent(user)
            
            initialViewController = UIStoryboard.initialViewController(for: .main)
            
        }else{
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
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
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }else{
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        }
    }
}
