import SwiftUI

// MARK: - Conditional Modifiers
// These extensions allow you to conditionally apply modifiers to views

extension View {
    /// Conditionally applies a modifier to a view
    /// - Parameters:
    ///   - condition: Boolean condition to check
    ///   - transform: Closure that receives the view and returns a modified view
    /// - Returns: Modified view if condition is true, otherwise original view
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .if(isRed) { view in
    ///         view.foregroundColor(.red)
    ///     }
    /// ```
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Conditionally applies one of two modifiers
    /// - Parameters:
    ///   - condition: Boolean condition to check
    ///   - ifTrue: Closure applied when condition is true
    ///   - ifFalse: Closure applied when condition is false
    /// - Returns: Modified view based on condition
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .if(isRed,
    ///          ifTrue: { $0.foregroundColor(.red) },
    ///          ifFalse: { $0.foregroundColor(.blue) })
    /// ```
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        ifTrue: (Self) -> TrueContent,
        ifFalse: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }
}

// MARK: - Learning Notes
/*
 HOW TO DISCOVER PATTERNS LIKE THIS:
 
 1. IDENTIFY THE PROBLEM:
    - You need to conditionally apply modifiers
    - SwiftUI doesn't have built-in conditional modifiers
    - You can't use if/else directly in modifier chains
 
 2. UNDERSTAND SWIFT CONCEPTS NEEDED:
    - Extensions: Adding methods to existing types
    - Generics: Making functions work with any type
    - @ViewBuilder: Allows returning different view types
    - Closures: Passing functions as parameters
    - some View: Type erasure for views
 
 3. SEARCH FOR SOLUTIONS:
    - "SwiftUI conditional modifier"
    - "SwiftUI apply modifier if condition"
    - Check SwiftUI documentation for @ViewBuilder
    - Look at community patterns (SwiftUI Lab, Hacking with Swift)
 
 4. BUILD IT YOURSELF:
    - Start with extension View
    - Add a generic function
    - Use @ViewBuilder for conditional returns
    - Test with simple examples
 
 5. REFINE:
    - Add documentation
    - Consider edge cases
    - Make it reusable
    - Share with others (you learn by teaching!)
 
 KEY RESOURCES:
 - Apple's SwiftUI Documentation
 - WWDC Videos (especially "ViewBuilder" sessions)
 - SwiftUI Lab (swiftui-lab.com)
 - Hacking with Swift (hackingwithswift.com)
 - Stack Overflow (for specific problems)
 
 PATTERN RECOGNITION:
 When you see repetitive code like:
   if condition {
       view.modifier1()
   } else {
       view
   }
 
 That's a sign you should create a helper extension!
 */



