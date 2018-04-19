//
//  Singleton.swift
//  NYTimes
//
//  Created by mac admin on 19/04/18.
//  Copyright © 2018 mac admin. All rights reserved.
//

import Foundation
import Alamofire
import  SystemConfiguration

let NYTimesDayURL = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json?api-key=0b4ffc44ea6c497e8b56ad09a2166949"
let NYTimesWeekURL = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=0b4ffc44ea6c497e8b56ad09a2166949"
let NYTimesMonthURL = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/30.json?api-key=0b4ffc44ea6c497e8b56ad09a2166949"

typealias NYDictionary = [String:Any]
typealias NYArray = [NYDictionary]
typealias NYAny = [Any]
typealias  ServiceResult = (_ respose: NYDictionary?,  _ errorMsg :String, _ responseCode: Int) -> Void
let PostMethod = "POST"
let GetMethod = "GET"
let jsonConten_Type = "application/json"
let  NYLoginJsonType = "application/x-www-form-urlencoded"

class Singleton {
    let defaultSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    var dateTask: URLSessionTask? = nil
    func postServiceResults(urlrequest: URLRequest , results: @escaping ServiceResult) {
        Alamofire.request(urlrequest).responseJSON { (response) in
            if let json = response.result.value {
                results(json as? NYDictionary, "", (response.response?.statusCode)!)
            }
            else {
                results([:], "" , 500)
            }
        }
    }
    public class func createRquest(Url:String,PostType:String, postObject:Any?,contentType:String,userPath: String) -> URLRequest {
        var urlrequest = URLRequest(url: URL(string: Url)!)
        urlrequest.timeoutInterval = 500
        urlrequest.httpMethod = PostType
        urlrequest.httpShouldHandleCookies = false
        urlrequest.addValue(contentType,forHTTPHeaderField: "Content-Type")
        return  urlrequest
    }
    
   public class func nullToNil(value : Any?) -> Any? {
        if value is NSNull || value == nil {
            return "" as Any?
        } else {
            if let a = value as? NSNumber {
                return a.stringValue
            } else {
                return (value as! String).uppercased() == "NULL"  ? "" : value
                //return value
            }
        }
    }
    
}
