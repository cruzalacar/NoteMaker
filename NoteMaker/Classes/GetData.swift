//
//  GetData.swift
//  PlannerApp
//
//  Created by Murtaza on 2019-12-02.
//

import UIKit

///This Data Class is used to connect the notes controller. Created By Murtaza Saleem
class GetData: NSObject {

    // Step 4 - create variables below for JSON parsing
    var dbData : [NSDictionary]?
    let myUrl = "http://salemuha.dev.fast.sheridanc.on.ca/project/sqlToJson.php" as String
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    // Step 5 - Create method below to do JSON parsing
    func jsonParser() {
       
        // step 5a - create URL object
        guard let endpoint = URL(string: myUrl) else {
            print("Error creating endpoint")
            return
        }
        // step 5b - create URL request object
        let request = URLRequest(url: endpoint)
        
        // step 5c - create asynchronous request using dataTask
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                // step 5d - retrieve JSON objects, convert to string and print to verify data received.
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                // step 5e - check for empty data
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                // step 5f - convert json into a dictionary
                // catch errors, then move on to Table View Controller
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                self.dbData = json
               
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }

  
  }
