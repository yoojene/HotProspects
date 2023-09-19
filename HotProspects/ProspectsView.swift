//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Eugene on 19/09/2023.
//

import CodeScanner
import SwiftUI
import UserNotifications




struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    // This gets updated each time the prospects array is appended to in ContentView
    // which in turn reinvokes the body property and calculates filteredProspects (along with everything else)
    // Everyone and Uncontacted tabs will show data, Contacted will not atm
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    let filter: FilterType
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                         
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        if (filter == .none) {
                            Spacer()
                            Image(systemName: prospect.isContacted ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.xmark")
                                .foregroundColor(prospect.isContacted ? .green : .blue)
                        }
                    }
         
                    .swipeActions  {
                        if prospect.isContacted {
                            Button {
                                // prospect.isContacted.toggle() // this will not work now as fileprivate (set)
                                prospects.toggle(prospect) // call the new function on the array to also publish the change (objectWillChange)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                                    
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
                .navigationTitle(title)
                .toolbar {
                    Button{
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Eugene Cross\neugene@genox.io", completion: handleScan)
                }
        }
     
        
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
        
    }
    
    
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
        
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) // every day at 9am
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // for testing only
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Doh!!")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
