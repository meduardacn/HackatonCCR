//
//  GeocodeQuery.swift
//  HackatonCCR
//
//  Created by Rafael Ferreira on 13/06/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

import Foundation

class GeocodeQueryService {

let defaultSession = URLSession(configuration: .default)
var resultGeocode: Geocode? = nil

    func getGeocodeByAddress(address: String, completion: @escaping (Geocode?, Error?) -> Void){
        let requestUrl: String = GeocodeEndpoints.getGeocodeByAddress.rawValue + address + "&key=AIzaSyBW83BvH2RsLsrxlA7bXLsO4Q_YkynHnGk"
        if let urlComponents = URLComponents(string: requestUrl) {
            
            guard let url = urlComponents.url else { return }
//            print(url)
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("ERRO")
                    completion(nil, error)
                }
                
                if let data = data {
                    do {
                        // JSONSerialization to test the API response during debug
                        let APIResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                        
                        do {
                            let queryReturn = try JSONDecoder().decode(GeocodeQueryResult.self, from: data)
                            let formatedAddress = queryReturn.results?[0].formattedAddress
                            let latitude = queryReturn.results?[0].geometry?.location?.lat
                            let longitude = queryReturn.results?[0].geometry?.location?.lng
                            var UF = ""
                            
                            let addressComponents = queryReturn.results?[0].addressComponents
                            
                            for item in addressComponents! {
                                if(item.types?[0] == "administrative_area_level_1") {
                                    UF = item.shortName!
                                }
                            }
                            
                            
                            completion(Geocode(formattedAddress: formatedAddress, latitude: latitude, longitude: longitude, UF: UF), nil)
                        }  catch { return }
                        
                        
                        
                        
                    }
                }
            }.resume()
        }
    }
    
    func getGeocodeByCoordinates(latitude: Double, longitude: Double, completion: @escaping (Geocode?, Error?) -> Void){
            let requestUrl: String = GeocodeEndpoints.getGeocodeByCoordinates.rawValue + "\(latitude),\(longitude)" + "&key=AIzaSyBW83BvH2RsLsrxlA7bXLsO4Q_YkynHnGk"
            if let urlComponents = URLComponents(string: requestUrl) {
                
                guard let url = urlComponents.url else { return }
    //            print(url)
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if error != nil {
                        print("ERRO")
                        completion(nil, error)
                    }
                    
                    if let data = data {
                        do {
                            // JSONSerialization to test the API response during debug
                            let APIResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            
                            do {
                                let queryReturn = try JSONDecoder().decode(GeocodeQueryResult.self, from: data)
                                let formatedAddress = queryReturn.results?[0].formattedAddress
                                let latitude = queryReturn.results?[0].geometry?.location?.lat
                                let longitude = queryReturn.results?[0].geometry?.location?.lng
                                var UF = ""
                                
                                let addressComponents = queryReturn.results?[0].addressComponents
                                
                                for item in addressComponents! {
                                    if(item.types?[0] == "administrative_area_level_1") {
                                        UF = item.shortName!
                                    }
                                }
                                
                                
                                completion(Geocode(formattedAddress: formatedAddress, latitude: latitude, longitude: longitude, UF: UF), nil)
                            }  catch { return }
                            
                            
                            
                            
                        }
                    }
                }.resume()
            }
        }
}
