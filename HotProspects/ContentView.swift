//
//  ContentView.swift
//  HotProspects
//
//  Created by Eugene on 18/09/2023.
//

import SamplePackage
import SwiftUI

struct ContentView: View {
        
    let possibleNumbers = Array(1...60)
    
    var body: some View {
        Text(results)
    }
    
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        
        return strings.joined(separator: ", ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
