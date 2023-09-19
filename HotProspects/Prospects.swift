//
//  Prospects.swift
//  HotProspects
//
//  Created by Eugene on 19/09/2023.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable {
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name == rhs.name
    }
    
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var dateAdded = Date.now
    
    static func < (lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name < rhs.name || 
        lhs.dateAdded < rhs.dateAdded
    }
    
    static func latestDate(prospect1: Prospect, prospect2: Prospect) -> Bool {
        if prospect1.dateAdded < prospect2.dateAdded {
            return true
        } else {
            return false
        }
    }
    

}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("prospects.json")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            
        } catch {
            people = []
        }
        
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            do {
                try encoded.write(to: savePath) // encoded is type Data
            } catch {
                print("Error is \(error.localizedDescription)")
            }
        }
            
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send() // call it before the change!!
        prospect.isContacted.toggle()
        save()
    }
}
