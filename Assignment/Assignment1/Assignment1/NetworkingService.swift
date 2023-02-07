//
//  NetworkingService.swift
//  WeatherApp
//
//  Created by Rania Arbash on 2023-01-27.
//

import Foundation

protocol NetworkingDelegate {
    func networkingDidFinishWithError()
    func networkingDidFinishWithResult(allCities: [String])
}


class NetworkingService {
    
    var delegate: NetworkingDelegate?
    static var shared = NetworkingService()
    
    var urlString = ""
    
    
    
    func getData2(urlString: String, completionHandler: @escaping (Result<Data,Error>)->Void){
        
        let urlObject = URL(string: urlString)
        
                // check if the urlObject is correct
                //print(urlString + "getdata")
                if let correctURL = urlObject {
                    URLSession.shared.dataTask(with: correctURL) { data, response, error in
                        
                        if let error = error {
                            completionHandler(.failure(error))
                        }
                        else {
                            completionHandler(.success(data!))
                        }
                    }.resume()
    }
    }
//    func getData(searchText : String) ->Void {//2
//
//        let urlObject = URL(string: urlString + searchText)
//
//        // check if the urlObject is correct
//
//        if let correctURL = urlObject {
//        URLSession.shared.dataTask(with: correctURL) { data, response, error in
//            if let error = error {
//                // Fail there is an error and no data retrevied
//                print(error)
//                self.delegate!.networkingDidFinishWithError()
//            }else {
//                   let xData = String(data: data!, encoding: .utf8)?.data(using: .utf8)
//                    let listOfCities = try? JSONDecoder().decode([String].self,from: xData!)
//                    // "Toronto , ON, Canada"
//
//
//              var result =   listOfCities?.reduce(into: [String]()){
//                    let separatesNames = $1.split(separator: ",") // ["Toronto", "ON" , "Canada"]
//                  if (separatesNames.count == 3 ){
//                    $0.append(separatesNames[0] + "" + separatesNames[2])
//                  }
//                }
//
//                // parse json to prepare the string list
//                self.delegate?.networkingDidFinishWithResult(allCities: result!)
//            }
//        }.resume()
//
//
//
//        }
//    }
}

