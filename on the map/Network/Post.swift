//
//  Post.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import Foundation
class Post {
    
    public static var userInfo = UserInfo()
    public static var sessionId: String?
    
    static func postSession(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: APIConstants.SESSION) else {
            completion("url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errorString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let dataJson = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dictionary = dataJson as? [String:Any],
                        let sessionDictionary = dictionary["session"] as? [String: Any],
                        let accountDicttionary = dictionary["account"] as? [String: Any]  {
                        
                        self.sessionId = sessionDictionary["id"] as? String
                        self.userInfo.key = accountDicttionary["key"] as? String
                        
                        print("seesion id is \(self.sessionId!))")
                        print("user key  is \(self.userInfo.key!))")
                        let vc = TabBarViewController(nibName:"TabBarViewController",bundle:nil)
                        vc.location?.uniqueKey = self.userInfo.key
                        self.getUserInfo(completion: { err in
                            
                        })
                        
                    } else {
                        errorString = "Couldn't parse response"
                    }
                } else {
                    errorString = "error in your login information"
                }
            } else {
                errorString = "error in your internet connection"
            }
            DispatchQueue.main.async {
                completion(errorString)
                
            }
            
        }
        task.resume()
    }
    
    static func getUserInfo(completion: @escaping (Error?)->Void) {
        print("seesion id info is \(self.sessionId!))")
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(self.userInfo.key!)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    static func postLocation(_ location: StudentLocation, completion: @escaping (String?)->Void) {
        guard let url = URL(string: APIConstants.STUDENT_LOCATION) else {
            completion("url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue(APIConstants.PARSE_APP_ID_V, forHTTPHeaderField: APIConstants.PARSE_APP_ID_K)
        request.addValue(APIConstants.PARSE_API_KEY_V, forHTTPHeaderField: APIConstants.PARSE_API_KEY_K)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.httpBody = "{\"uniqueKey\": \"\(userInfo.key!)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errorString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    
                    print("success!")
                } else {
                    
                    errorString = "error in your login information"
                }
            } else {
                errorString = "error in your internet connection"
            }
            DispatchQueue.main.async {
                completion(errorString)
            }
            
        }
        task.resume()
    }
    
    
}
