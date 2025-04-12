import SwiftUI

// Model for a single bloodwork entry
struct BloodworkEntry: Identifiable, Codable {
    var id = UUID()  // Changed to var to support Codable
    var date: Date
    var testName: String
    var value: Double
    var unit: String
    var notes: String?

    enum CodingKeys: String, CodingKey {
        case id, date, testName, value, unit, notes
    }
}

// Data manager using UserDefaults
class BloodworkData: ObservableObject {
    @Published var entries: [BloodworkEntry] {
        didSet {
            saveEntries()
        }
    }
    private let entriesKey = "BloodworkEntries"

    init() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([BloodworkEntry].self, from: data) {
            self.entries = decodedEntries
        } else {
            self.entries = []
        }
    }

    func addEntry(_ entry: BloodworkEntry) {
        entries.append(entry)
    }

    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: entriesKey)
        }
    }

    func averageValue(for testName: String) -> Double? {
        let matchingEntries = entries.filter { $0.testName == testName }
        guard !matchingEntries.isEmpty else { return nil }
        let total = matchingEntries.reduce(0.0) { $0 + $1.value }
        return total / Double(matchingEntries.count)
    }
}

// Main view for the app
struct ContentView: View {
    @StateObject private var bloodworkData = BloodworkData()
    @State private var newDate = Date()
    @State private var newTestName = ""
    @State private var newValue = ""
    @State private var newUnit = ""
    @State private var newNotes = ""
    @State private var selectedTestName = ""
    @State private var showingTrends = false

    var body: some View {
        NavigationView {
            VStack {
                // Form to add new bloodwork entry
                Form {
                    Section(header: Text("Add New Bloodwork Entry")) {
                        DatePicker("Date", selection: $newDate, displayedComponents: .date)
                        TextField("Test Name (e.g., Cholesterol)", text: $newTestName)
                        TextField("Value (e.g., 150)", text: $newValue)
                            .keyboardType(.decimalPad)
                        TextField("Unit (e.g., mg/dL)", text: $newUnit)
                        TextField("Notes (optional)", text: $newNotes)
                        Button("Add Entry") {
                            if let value = Double(newValue), !newTestName.isEmpty, !newUnit.isEmpty {
                                let entry = BloodworkEntry(
                                    date: newDate,
                                    testName: newTestName,
                                    value: value,
                                    unit: newUnit,
                                    notes: newNotes.isEmpty ? nil : newNotes
                                )
                                bloodworkData.addEntry(entry)
                                // Reset form
                                newDate = Date()
                                newTestName = ""
                                newValue = ""
                                newUnit = ""
                                newNotes = ""
                            }
                        }
                        .disabled(newTestName.isEmpty || newValue.isEmpty || newUnit.isEmpty)
                    }
                }
                .frame(height: 300)

                // List of entries
                List {
                    ForEach(bloodworkData.entries) { entry in
                        VStack(alignment: .leading) {
                            Text("\(entry.testName): \(entry.value, specifier: "%.1f") \(entry.unit)")
                            Text("Date: \(entry.date, formatter: itemFormatter)")
                            if let notes = entry.notes {
                                Text("Notes: \(notes)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }

                // Buttons for summaries and trends
                HStack {
                    Picker("Select Test", selection: $selectedTestName) {
                        Text("None").tag("")
                        ForEach(Array(Set(bloodworkData.entries.map { $0.testName })), id: \.self) { testName in
                            Text(testName).tag(testName)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Button("Show Summary") {
                        if let average = bloodworkData.averageValue(for: selectedTestName) {
                            print("Average \(selectedTestName): \(average) \(bloodworkData.entries.first { $0.testName == selectedTestName }?.unit ?? "")")
                        }
                    }
                    .disabled(selectedTestName.isEmpty)

                    Button("Show Trends") {
                        showingTrends = true
                    }
                    .disabled(selectedTestName.isEmpty)
                    .sheet(isPresented: $showingTrends) {
                        TrendsView(entries: bloodworkData.entries.filter { $0.testName == selectedTestName }, testName: selectedTestName)
                    }
                }
                .padding()
            }
            .navigationTitle("Bloodwork Tracker")
        }
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

// Simple trends view (without Charts for now)
struct TrendsView: View {
    let entries: [BloodworkEntry]
    let testName: String

    var body: some View {
        NavigationView {
            List {
                ForEach(entries) { entry in
                    Text("\(entry.date, formatter: dateFormatter): \(entry.value, specifier: "%.1f") \(entry.unit)")
                }
            }
            .navigationTitle("\(testName) Trends")
            .toolbar {
                Button("Done") {
                    // Dismiss the sheet
                }
            }
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
