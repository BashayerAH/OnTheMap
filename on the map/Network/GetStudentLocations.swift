//
//  GetStudentLocations.swift
//  on the map
//
//  Created by Bashayer  on 30/12/2018.
//  Copyright © 2018 Bashayer. All rights reserved.
//

import Foundation

class GetStudentLocations {
    
    static func getStudentLocations(limit: Int = 50, skip: Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (LocationsData?)->Void) {
        guard let url = URL(string: "\(APIConstants.STUDENT_LOCATION)?\(APIConstants.LIMIT)=\(limit)&\(APIConstants.SKIP)=\(skip)&\(APIConstants.ORDER)=-\(orderBy.rawValue)") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(APIConstants.PARSE_APP_ID_V, forHTTPHeaderField: APIConstants.PARSE_APP_ID_K)
        request.addValue(APIConstants.PARSE_API_KEY_V, forHTTPHeaderField: APIConstants.PARSE_API_KEY_K)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var studentLocations: [StudentLocation] = []
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    
                    if let dataJson = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let dictionary = dataJson as? [String:Any],
                        let results = dictionary["results"] as? [Any] {
                        
                        for location in results {
                            let data = try! JSONSerialization.data(withJSONObject: location)
                            let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                            studentLocations.append(studentLocation)
                        }
                        
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(LocationsData(studentLocations: studentLocations))
            }
            
        }
        task.resume()
    }
    
}


