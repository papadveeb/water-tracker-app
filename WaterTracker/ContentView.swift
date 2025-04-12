You did not provide the code for `WaterTracker/ContentView.swift`.  To improve it, I need to see the existing code.  However, I can offer some general advice on improving a macOS bloodwork tracking app's root view in Swift, assuming it uses SwiftUI:

**General Improvements for a Bloodwork Tracking App's Root View:**

* **Data Management:**
    * **Use a Model:** Create a struct or class to represent a single bloodwork entry (e.g., `BloodworkEntry`).  This struct should include properties like `date`, `testName`, `value`, `unit`, and potentially notes.
    * **Data Persistence:**  Store the `BloodworkEntry` data persistently. Options include:
        * **Core Data:**  Best for complex data models and relationships.
        * **UserDefaults:** Suitable for small amounts of data.
        * **File Storage (JSON, plist):**  Good for simpler apps.
    * **ObservableObject:**  Conform your data model (or a wrapper around it) to `ObservableObject` so SwiftUI automatically updates the UI when the data changes.  Use `@Published` properties to trigger updates.

* **UI Structure:**
    * **NavigationView:** Use a `NavigationView` to provide navigation between different views (e.g., a list of bloodwork entries, a detail view for a specific entry, a settings view).
    * **Lists and Forms:** Use `List` to display a list of bloodwork entries.  Use `Form` to create input forms for adding new entries.
    * **Charts and Graphs:**  Integrate a charting library (e.g., Charts) to visualize bloodwork trends over time. This is crucial for a bloodwork tracking app.
    * **Date Pickers:** Use `DatePicker` for easy date selection.
    * **Segmented Controls:**  Consider segmented controls for selecting different bloodwork parameters.

* **Error Handling:**
    * **Error Handling:** Implement proper error handling for data persistence and loading.  Display informative error messages to the user.

* **Code Organization:**
    * **Separate Concerns:** Divide your code into smaller, reusable components (views, view models, data models).  This improves readability and maintainability.
    * **Use Extensions:** Create extensions to add functionality to existing types without subclassing.


**Example Snippet (Illustrative):**

This shows a basic structure.  You'll need to adapt it to your specific data model and requirements.

```swift
import SwiftUI

struct BloodworkEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let testName: String
    let value: Double
    let unit: String
    var notes: String?
}

class BloodworkData: ObservableObject {
    @Published var entries: [BloodworkEntry] = []

    init() {
        // Load data from persistent storage here
        // ...
    }

    func addEntry(entry: BloodworkEntry) {
        entries.append(entry)
        // Save data to persistent storage here
        // ...
    }
}

struct ContentView: View {
    @ObservedObject var bloodworkData = BloodworkData()

    var body: some View {
        NavigationView {
            List {
                ForEach(bloodworkData.entries) { entry in
                    Text("\(entry.testName): \(entry.value) \(entry.unit) (\(entry.date, formatter: itemFormatter))")
                }
            }
            .navigationTitle("Bloodwork Tracker")
            .toolbar {
                Button(action: {
                    // Add new entry action (e.g., navigate to a new entry form)
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
```

**To get more specific help, please provide the code from `WaterTracker/ContentView.swift`.**  Then I can give you targeted feedback and suggestions.
