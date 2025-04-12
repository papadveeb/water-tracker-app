This code creates a macOS app with a simple UI for tracking daily water intake.  It uses a `UserDefaults` to persist the data between app launches.  Remember to create a new macOS app project in Xcode before pasting this code.

**WaterTracker/MainView.swift**

```swift
import SwiftUI

struct MainView: View {
    @State private var totalWaterIntake: Double = 0
    @State private var showingAlert = false

    var body: some View {
        VStack {
            Text("Total Water Intake: \(totalWaterIntake, specifier: "%.1f") ml")
                .font(.largeTitle)
                .padding()

            Button("Log 250ml") {
                addWater(amount: 250)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            Button("Reset") {
                resetWaterIntake()
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .foregroundColor(.red)
        }
        .padding()
        .onAppear {
            loadWaterIntake()
        }
        .alert("Water Intake Reset", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your daily water intake has been reset.")
        }
    }

    func addWater(amount: Double) {
        totalWaterIntake += amount
        saveWaterIntake()
    }

    func saveWaterIntake() {
        UserDefaults.standard.set(totalWaterIntake, forKey: "totalWaterIntake")
    }

    func loadWaterIntake() {
        if let intake = UserDefaults.standard.object(forKey: "totalWaterIntake") as? Double {
            totalWaterIntake = intake
        }
    }
    
    func resetWaterIntake() {
        totalWaterIntake = 0
        saveWaterIntake()
        showingAlert = true
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
```

**Explanation:**

* **`@State` variables:**  `totalWaterIntake` stores the current water intake, and `showingAlert` controls the alert display.
* **`VStack`:** Arranges the UI elements vertically.
* **`Text`:** Displays the total water intake.  The `specifier: "%.1f"` formats the number to one decimal place.
* **`Button`:**  Adds 250ml to the total intake when tapped.  Uses the `buttonStyle` modifier for a nice macOS look.
* **`onAppear` modifier:** Loads the saved water intake when the view appears.
* **`saveWaterIntake()`:** Saves the `totalWaterIntake` to `UserDefaults`.
* **`loadWaterIntake()`:** Loads the `totalWaterIntake` from `UserDefaults`.
* **`resetWaterIntake()`:** Resets the total intake to 0 and displays an alert.
* **`alert` modifier:** Shows an alert to confirm the reset action.


**To run this code:**

1. Create a new macOS App project in Xcode.
2. Replace the contents of `ContentView.swift` with the code above.
3. Run the app.

You should now have a simple macOS app that lets you track your daily water intake. Remember that this uses `UserDefaults` for persistence, which is suitable for simple apps but might not be ideal for more complex data management.  For larger applications, consider using Core Data or another persistent storage solution.
