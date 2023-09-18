//
//  ContentView.swift
//  HotProspects
//
//  Created by Eugene on 18/09/2023.
//

import SwiftUI


@MainActor class User: ObservableObject {
    @Published var name = "Steph Curry"
}



struct EditView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        TextField("Name", text: $user.name)
    }
}

struct DisplayView: View {
    @EnvironmentObject var user: User // Environment objects use the type as the key and the instance of the type as the value (like a Dict has can hold different types
    
    var body: some View {
        Text(user.name)
    }
}



struct ContentView: View {
    
    @StateObject var user = User()
    
    
    var body: some View {
        VStack {
            EditView()
            DisplayView()
        }
        .environmentObject(user)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
