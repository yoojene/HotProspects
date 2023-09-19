//
//  ContentView.swift
//  HotProspects
//
//  Created by Eugene on 18/09/2023.
//

import SwiftUI


struct ContentView: View {
    @State private var output = ""
    
    var body: some View {
        Text(output)
            .task {
                await fetchReadings()
            }
    }
    
    // a named Task
    //
    // can it pass around
    // return from somewhere else
    // cancel it  - fetchTask.cancel
    // let fetchTask: Task<String, Error>
    func fetchReadings() async {
        
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings"
        }
        
        // result is of type Result<String, Error>
        // can be passed about no longer async
        // either value or the error
        let result = await fetchTask.result
        
        // .get() returns the value, but you need to handle the error case
        do {
            output = try result.get()
        } catch {
            print("Error here")
        }
        
        // alternatively switch
        
        switch result {
        case .success(let str):
            output = str
        case .failure(let error):
            output = "Download error: \(error.localizedDescription)"
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
