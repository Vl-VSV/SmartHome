//
//  ControlManager.swift
//  SmartHome
//
//  Created by Vlad V on 19.04.2023.
//

import Foundation
import SwiftUI

extension UIColor {
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            return nil
        }
    }
}

struct Data: Codable {
    let temperature: Int
}

struct ControlManager {
    
    func getTemperature(closure: @escaping (Int?, Error?) -> ()) {
        guard let url = URL(string: "https://smarthome-dm1x.onrender.com/getData") else {
            fatalError("Missing URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeData = data {
                let decodedData = try? JSONDecoder().decode(Data.self, from: safeData)
                if let decodedData = decodedData {
                    closure(decodedData.temperature, nil)
                }
            } else if let error = error {
                closure(nil, error)
            }
        }
        task.resume()
    }
    
    func performLEDRequest(with state: Int) {
        guard let url = URL(string: "https://smarthome-dm1x.onrender.com/setLed?state=\(state)") else {
            fatalError("Missing URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeData = data {
                print(safeData)
            }
        }
        task.resume()
    }
    
    func performLEDRequest(red: Int, green: Int, blue: Int){
        guard let url = URL(string: "https://smarthome-dm1x.onrender.com/setRGB?r=\(red)&g=\(green)&b=\(blue)") else {
            fatalError("Missing URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeData = data {
                print(safeData)
            }
        }
        task.resume()
    }
    
    func performMatrixRequest(ledSates matrix: [[Int]]) {
        guard let url = URL(string: "https://smarthome-dm1x.onrender.com/setMatrix") else {
            fatalError("Missing URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var stringMtrx = [String]()
        for row in matrix {
          var str = "0b"
          for num in row {
              str += "\(num)"
          }
            stringMtrx.append(str)
        }
        
        guard let jsonData = try? JSONEncoder().encode(stringMtrx) else {
            fatalError("Incorrect data to encode")
        }
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let safeData = data {
                print(safeData)
            }
        }
        task.resume()
    }
}


