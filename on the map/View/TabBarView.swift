//
//  TabBarView.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {
    
    var locationsData: LocationsData?
    var location: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocation(_:)))
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout(_:)))
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshLocations(_:)))
        navigationItem.rightBarButtonItems = [addLocationButton, refreshButton]
        navigationItem.leftBarButtonItem = logoutButton
        // Do any additional setup after loading the view.
        
    }
    
    @objc private func logout(_ sender: Any) {
        //need implementation
        deleteController.deleteSession {  err  in
            guard err == nil else {
                self.showAlert(viewController:self,title: "error !!", message: err!,actionTitle: "ERROR")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @objc private func refreshLocations(_ sender: Any) {
        print("refresh pressed")
        loadLocations()
    }
    
    @objc private func addLocation(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! UINavigationController
        
        present(vc, animated: true, completion: nil)
    }
    
    
    
    public func loadLocations() {
       GetStudentLocations.getStudentLocations { (data) in
            guard let data = data else {
                self.showAlert(viewController:self,title: "Error", message: "No internet connection found",actionTitle: "ERROR")
                return
            }
            guard data.studentLocations.count > 0 else {
                self.showAlert(viewController:self,title: "Error", message: "No pins found",actionTitle: "ERROR")
                return
            }
            self.locationsData = data
        }
    }
    func showAlert(viewController: UIViewController, title: String, message: String?, actionTitle: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
