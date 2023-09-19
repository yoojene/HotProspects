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
                    Button(role: .destructive) {
                        print("Deleting")
                    } label: {
                        Label("Delete", systemImage: "minus.circle")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        print("Pinning")
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.orange)
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
