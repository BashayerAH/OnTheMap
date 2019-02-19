//
//  TableViewController.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: TabBarViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    var locationsDataTmp: LocationsData?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   GetStudentLocations.getStudentLocations() {(studentsLocations) in
            DispatchQueue.main.async {
                self.locationsDataTmp = studentsLocations
                self.tableView.reloadData()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let locationsDataTmpNotNil = locationsDataTmp {
            return locationsDataTmpNotNil.studentLocations.count
        } else {
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        //obtain a cell of type Table Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell") as! TableViewCell
        let student = locationsDataTmp?.studentLocations[indexPath.row]
        cell.nameLabel.text = (student?.firstName ?? "") + " " + (student?.lastName ?? "")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let urlMedia = locationsDataTmp?.studentLocations[indexPath.row].mediaURL
        
        let app = UIApplication.shared
        if let url = URL(string: urlMedia!), app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    
    
}
