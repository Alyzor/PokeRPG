//
//  Locations.swift
//  PokeRPG
//
//  Created by Alyzor on 10/07/2023.
//

import Foundation

struct KantoLocs: Codable {
    var locations:[namedResourceURL] = [namedResourceURL]()
}

struct KantoAreas: Codable{
    var areas:[namedResourceURL] = [namedResourceURL]()
}

struct KantoRoutes: Codable{
    var encounter_method_rates: [encMethods] = [encMethods]()
    var pokemon_encounters:[encList] = [encList]()
}

struct encList: Codable{
    var pokemon:[namedResourceURL] = [namedResourceURL]()
}

struct encMethods:Codable{
    var encounter_method:namedResource = namedResource()
}

struct LocationList: Codable{
    var Location:[locDetails] = [locDetails]()
}

struct locDetails: Codable{
    var Name:String = ""
    var encMethod:String = ""
    var encChance:[namedResourceURL] = [namedResourceURL]()
}

class fetchLocations{
    func fetchAllLocs(completion:@escaping([namedResourceURL]) -> ()){
    guard let url = URL(string: "https://pokeapi.co/api/v2/region/1") else {
        return
    }
    URLSession.shared.dataTask(with:url) { (data, response,error) in
        guard let data = data else {return}
        
        let locList = try! JSONDecoder().decode(KantoLocs.self, from: data)
        
        DispatchQueue.main.async{
            completion(locList.locations)
        }
    }.resume()
    }
    
    func fetchAreas(locs:KantoLocs, completion:@escaping([namedResourceURL])-> ()){
        var finalAreas:[namedResourceURL] = []
        for i in locs.locations.indices{
            guard let url = URL(string: locs.locations[i].url) else {
                return
            }
            URLSession.shared.dataTask(with:url) { (data, response,error) in
                guard let data = data else {return}
                
                let areaList = try! JSONDecoder().decode(KantoAreas.self, from: data)
                
                DispatchQueue.main.async{
                    finalAreas.append(areaList.areas)
                    if i == locs.locations.indices.count{
                        completion(finalAreas)
                    }
                }
            }.resume()
        }
        
    }
}
