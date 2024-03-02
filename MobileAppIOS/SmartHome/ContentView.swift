//
//  ContentView.swift
//  SmartHome
//
//  Created by Vlad V on 19.04.2023.
//

import SwiftUI

struct ContentView: View {
    var controlManager = ControlManager()
    
    @State private var color = Color.black
    @State private var buttonStates : [[Int]] = Array(repeating: Array(repeating: 0, count: 8), count: 8)
    @State private var temperature: Int?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30){
                Text("Smart Home ")
                    .font(.title).bold()
                +
                Text("by VSV")
                    .font(.system(.caption, design: .monospaced, weight: .regular))
                
                Button {
                    controlManager.performLEDRequest(with: 1)
                } label: {
                    Label("LED On", systemImage: "lightbulb.led.fill")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Capsule().stroke()
                }
                
                Button {
                    controlManager.performLEDRequest(with: 0)
                } label: {
                    Label("LED Off", systemImage: "lightbulb.led")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Capsule().stroke()
                }
                
                ColorPicker("RGB Led Color", selection: $color)
                    .onChange(of: color) { newValue in
                        let newValue = UIColor(newValue)
                        controlManager.performLEDRequest(red: newValue.rgb()!.red, green: newValue.rgb()!.green, blue: newValue.rgb()!.blue)
                    }
                
                ButtonMatrix(buttonStates: $buttonStates)
                
                Button {
                    controlManager.performMatrixRequest(ledSates: buttonStates)
                } label: {
                    Label("Update Matrix", systemImage: "arrow.counterclockwise")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Capsule().stroke()
                }
                
                Button {
                    controlManager.getTemperature { temp, error in
                        if let error = error {
                            print(error)
                        } else if let temp = temp {
                            temperature = temp
                        }
                    }
                } label: {
                    Label("Temperature: \(temperature ?? 0) Cº", systemImage: "thermometer.low")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Capsule().stroke()
                }
            }
            .padding()
        }
    }
}

struct ButtonMatrix: View {
    @Binding var buttonStates: [[Int]]
    
    var body: some View {
        VStack {
            ForEach(0..<8) { row in
                HStack {
                    ForEach(0..<8) { column in
                        Button {
                            buttonStates[row][column] = buttonStates[row][column] == 1 ? 0 : 1
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(buttonStates[row][column] == 1 ? .black : .white)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 3)
                                    
                                }
                        }
                        .animation(.easeInOut(duration: 0.2), value: buttonStates)
                        
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
