//
//  LoginViewController.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var myKeyboard = Keyboard()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myKeyboard.configureTextField(textField: emailTextField!)
        myKeyboard.configureTextField(textField: passwordTextField!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myKeyboard.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myKeyboard.unsubscribeFromKeyboardNotifications()
    }
    
 
        @IBAction func loginButton(_ sender: Any) {
            Post.postSession(username: emailTextField.text!, password: passwordTextField.text!) { (errString) in
                guard errString == nil else {
                    self.showAlert(viewController: self, title: "ERROR", message: errString!, actionTitle: "Dismiss")
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Login", sender: nil)
                }
            }
        }
        
        
        @IBAction func signUpButton(_ sender: Any) {
            if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        
        func showAlert(viewController: UIViewController, title: String, message: String?, actionTitle: String) -> Void {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
            
            viewController.present(alert, animated: true, completion: nil)
        }
        
}



