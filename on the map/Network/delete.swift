//
//  delete.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import Foundation

class deleteController{
    
    static func deleteSession(completion: @escaping (String?)->Void) {
        guard let url = URL(string: APIConstants.SESSION) else {
            completion("url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errorString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    let range = Range(5..<data!.count)
                    let newData = data?.subdata(in: range) /* subset response data! */
                    print(String(data: newData!, encoding: .utf8)!)
                    print("success!")
                } else {
                    print("status code: \(statusCode)")
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
