//
//  AddLocationViewController.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    var Keyboard1 = Keyboard()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Keyboard1.configureTextField(textField: locationTextField!)
        Keyboard1.configureTextField(textField: mediaLinkTextField!)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel(_:)))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Keyboard1.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Keyboard1.unsubscribeFromKeyboardNotifications()
    }
    
    @objc private func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocationButton(_ sender: Any) {
        guard let location = locationTextField.text,
            let link = mediaLinkTextField.text,
            location != "", link != "" else {
                self.showAlert(viewController:self,title: "Missing information", message: "Please fill both fields and try again",actionTitle: "ERROR")
                return
        }
        
        let studentLocation = StudentLocation(mapString: location, mediaURL: link)
        geocodeCoordinates(studentLocation)
        
    }
    func showAlert(viewController: UIViewController, title: String, message: String?, actionTitle: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func geocodeCoordinates(_ studentLocation: StudentLocation) {
        
        activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
            self.performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
            }
            guard let firstLocation = placeMarks?.first?.location else {
                
                self.showAlert(viewController:self,title: "Error", message: "There is no first location",actionTitle: "ERROR")
                return
                
                
            }
            
            var location = studentLocation
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude
            
            self.performSegue(withIdentifier: "mapSegue", sender: location)
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue", let vc = segue.destination as? ConfirmLocationViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
