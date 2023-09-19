//
//  ContentView.swift
//  HotProspects
//
//  Created by Eugene on 18/09/2023.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        Image("example")
            .interpolation(.none) // turn off iOS pixel blending.  Stop auto blurring
            .resizable()
            .scaledToFit()
            .frame(maxHeight: .infinity)
            .background(.black)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
