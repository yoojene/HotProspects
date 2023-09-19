//
//  ContentView.swift
//  HotProspects
//
//  Created by Eugene on 18/09/2023.
//

import SwiftUI


struct ContentView: View {
        
    var body: some View {
        List {
            Text("Steph Curry")
                .swipeActions {
                    Button {
                        print("Hi")
                    } label: {
                        Label("Send message", systemImage: "message")
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
