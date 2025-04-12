You did not provide any Swift code from `WaterTracker/MainView.swift`.  To improve the code, I need to see the existing code.  Please provide the code so I can offer specific improvements.

However, I can give you some general advice on improving a macOS bloodwork tracking app's `MainView.swift` file, assuming it uses SwiftUI:

**General Improvements:**

* **Data Model:**  Ensure your data model is well-structured and uses appropriate data types.  Consider using structs for individual bloodwork entries and potentially a class or struct to manage the collection of entries.  Use `Codable` conformance to easily save and load data.

* **Error Handling:** Implement robust error handling.  Handle potential issues like file I/O errors, network errors (if fetching data externally), and data validation errors gracefully.  Use `do-catch` blocks and present informative error messages to the user.

* **Data Persistence:** Choose a suitable persistence method.  `UserDefaults` is fine for small amounts of data, but for a more substantial bloodwork tracking app, consider using Core Data, FileManager (with JSON or plist encoding), or a cloud-based solution (iCloud, Firebase, etc.).

* **UI Design:**  Follow Apple's Human Interface Guidelines for macOS.  Use appropriate controls, spacing, and visual hierarchy to create a clear and intuitive user interface. Consider using a table or list to display bloodwork entries.

* **Data Display:**  Clearly display relevant bloodwork information, such as date, test type, and results.  Use formatting to make the data easily readable (e.g., units for measurements).  Consider adding visual cues (e.g., color-coding) to highlight abnormal results.

* **Data Input:** Use appropriate input controls (e.g., text fields, date pickers, number formatters) for entering bloodwork data.  Validate user input to prevent invalid data from being entered.

* **Sorting and Filtering:** Allow the user to sort and filter the bloodwork entries by date, test type, or result value.

* **Charting:** Consider incorporating charts to visualize trends in the bloodwork data over time.  Libraries like Charts (Swift Charts) can be helpful.

* **Testability:** Write unit tests to verify the correctness of your data model and view logic.  Make your code modular and testable.


**Example Improvements (Illustrative):**

Let's say you have a simple struct for a bloodwork entry:

```swift
struct BloodworkEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let testType: String
    let result: Double
    let unit: String
}
```

This could be improved by adding error handling during initialization and more robust data validation:

```swift
struct BloodworkEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let testType: String
    let result: Double
    let unit: String

    init?(date: Date, testType: String, result: Double, unit: String) {
        guard result >= 0 else { return nil } // Example validation
        self.date = date
        self.testType = testType
        self.result = result
        self.unit = unit
    }
}
```

Once you provide your code, I can give you much more specific and helpful feedback.
