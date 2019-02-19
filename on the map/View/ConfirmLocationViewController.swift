//
//  ConfirmLocationViewController.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController,MKMapViewDelegate {
    
    var location: StudentLocation?
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = location else { return }
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        mapView.addAnnotation(annotation)
        
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func finishButton(_ sender: Any) {
        
        
        Post.postLocation(self.location!) { err  in
            guard err == nil else {
                self.showAlert(viewController:self,title: "Not enough information", message: err!,actionTitle: "ERROR")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    func showAlert(viewController: UIViewController, title: String, message: String?, actionTitle: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
