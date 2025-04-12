Okay, since you didn't provide the `ContentView.swift` code, I'll provide a more complete example implementing the suggestions I gave earlier.  This example uses UserDefaults for simplicity, but you should consider Core Data for a production-ready app with larger datasets.

```swift
import SwiftUI
import Charts // Make sure you've added Charts to your project

// Data Model
struct BloodworkEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let testName: String
    let value: Double
    let unit: String
    var notes: String?
}

// Data Management (using UserDefaults - replace with Core Data for a real app)
class BloodworkData: ObservableObject {
    @Published var entries: [BloodworkEntry] = []
    private let defaults = UserDefaults.standard
    private let entriesKey = "bloodworkEntries"

    init() {
        if let data = defaults.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([BloodworkEntry].self, from: data) {
            entries = decodedEntries
        }
    }

    func addEntry(entry: BloodworkEntry) {
        entries.append(entry)
        saveEntries()
    }

    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            defaults.set(encoded, forKey: entriesKey)
        }
    }
}

// Main View
struct ContentView: View {
    @ObservedObject var bloodworkData = BloodworkData()
    @State private var isAddingEntry = false

    var body: some View {
        NavigationView {
            VStack {
                // Chart (requires Charts library)
                Chart {
                    ForEach(bloodworkData.entries) { entry in
                        BarMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Value", entry.value)
                        )
                        .annotation(alignment: .top) {
                            Text("\(entry.value) \(entry.unit)")
                        }
                    }
                }
                .chartXAxis(.date())
                .frame(height: 200)
                .padding()

                List {
                    ForEach(bloodworkData.entries) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(entry.testName): \(entry.value) \(entry.unit)")
                                Text(entry.date, style: .date)
                            }
                            Spacer()
                            if let notes = entry.notes {
                                Text("Notes: \(notes)")
                            }
                        }
                    }
                }
                .navigationTitle("Bloodwork Tracker")
                .toolbar {
                    Button(action: {
                        isAddingEntry = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $isAddingEntry) {
                    AddBloodworkEntryView(isPresented: $isAddingEntry, bloodworkData: bloodworkData)
                }
            }
        }
    }
}

// Add Entry View
struct AddBloodworkEntryView: View {
    @Binding var isPresented: Bool
    @ObservedObject var bloodworkData: BloodworkData
    @State private var date = Date()
    @State private var testName = ""
    @State private var value = ""
    @State private var unit = ""
    @State private var notes = ""

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Test Name", text: $testName)
                TextField("Value", text: $value)
                    .keyboardType(.decimalPad)
                TextField("Unit", text: $unit)
                TextField("Notes (Optional)", text: $notes)
                Button("Save") {
                    if let valueDouble = Double(value) {
                        let newEntry = BloodworkEntry(date: date, testName: testName, value: valueDouble, unit: unit, notes: notes)
                        bloodworkData.addEntry(entry: newEntry)
                        isPresented = false
                    } else {
                        // Handle invalid input (e.g., show an alert)
                        print("Invalid input: Value must be a number.")
                    }
                }
            }
            .navigationTitle("Add Entry")
            .navigationBarItems(trailing: Button("Cancel") { isPresented = false })
        }
    }
}

```

Remember to install the `Charts` library using Swift Package Manager.  This improved example includes:

* A more robust data model.
* Data persistence using UserDefaults (easily replaceable with Core Data).
* A chart to visualize data using the `Charts` library.
* Error handling for invalid input in the `AddBloodworkEntryView`.
* A cleaner UI with separate views for adding entries.

This is a much more complete and functional example.  Remember to replace UserDefaults with Core Data for a production-ready application.  Also, adapt the chart to display the specific data you are tracking.  Consider adding validation to ensure the user enters appropriate data.
