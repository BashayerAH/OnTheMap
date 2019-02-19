//
//  MapViewController.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: TabBarViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetStudentLocations.getStudentLocations() {(studentsLocations) in
            DispatchQueue.main.async {
                _ = studentsLocations
                
                var annotations = [MKPointAnnotation]()
                for location in (studentsLocations?.studentLocations)!  {
                    
                    guard let latitude = location.latitude, let longitude = location.longitude else { continue }
                    let lat = CLLocationDegrees(latitude)
                    let long = CLLocationDegrees(longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = location.firstName
                    let last = location.lastName
                    let mediaURL = location.mediaURL
                    
                    
                    let annotation = MKPointAnnotation()
                    annotation.subtitle = mediaURL
                    annotation.coordinate = coordinate
                    annotation.title =  "\(first ?? "") \(last ?? "")"
                    
                    
                    annotations.append(annotation)
                }
                
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
            }
        }
        
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
