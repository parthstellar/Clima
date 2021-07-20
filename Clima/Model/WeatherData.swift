//
//  WeatherData.swift
//  Clima
//
//  Created by Apple on 20/05/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    
    let name:String
    let main:Main
//    let weather:[DescripyionArray]
    let weather:[DescripyionArray]
}

struct Main : Decodable {
    let temp:Double
}
struct DescripyionArray : Decodable {
    let description : String
    let id : Int
}
