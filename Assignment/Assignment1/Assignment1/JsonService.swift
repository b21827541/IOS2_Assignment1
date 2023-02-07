//
//  JsonService.swift
//  WeatherApp
//
//  Created by Rania Arbash on 2023-01-27.
//

import Foundation



class JsonService {
    static var shared = JsonService()
    
    func parseJson (data : Data) -> [Photo]{
        var photos: [Photo] = []
        do{
            let xData = (String(data: data, encoding: .utf8)?.data(using: .utf8))!
            let decoder = JSONDecoder()
            photos = try decoder.decode([String: [Photo]].self, from: xData)["photos"]!
        } catch {
            print(error)
        }// ??
        //print(photos!)
        //var result =   photos?.reduce(into: [String]())//{
                            //let separatesNames = $1.split(separator: ",") // ["Toronto", "ON" , "Canada"]
                          //if (separatesNames.count == 3 ){
                          //  $0.append(separatesNames[0] + "" + separatesNames[2])
                          //}
                       // }
        
        return photos
    }
    
}
