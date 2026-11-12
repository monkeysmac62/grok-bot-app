import Foundation

/// Shared state between the host app and the widget.
/// Both targets include this file. The App Group must be enabled
/// in Xcode signing for BOTH targets with the exact identifier below.
enum SharedState {
    static let appGroupID = "group.com.grokbot.widget"

    static let defaults = UserDefaults(suiteName: appGroupID) ?? .standard

    private enum Key {
        static let faceHappy = "faceHappy"
        static func task(_ index: Int) -> String { "task\(index)" }
    }

    /// false = eyes open, true = happy closed eyes / wink.
    static var faceHappy: Bool {
        get { defaults.bool(forKey: Key.faceHappy) }
        set { defaults.set(newValue, forKey: Key.faceHappy) }
    }

    /// Task state: 0 = todo, 1 = doing, 2 = done.
    static func taskState(_ index: Int) -> Int {
        let v = defaults.integer(forKey: Key.task(index))
        return (0...2).contains(v) ? v : 0
    }

    static func setTaskState(_ index: Int, _ value: Int) {
        defaults.set(value, forKey: Key.task(index))
    }

    static func cycleTask(_ index: Int) {
        setTaskState(index, (taskState(index) + 1) % 3)
    }

    static var doneCount: Int {
        (0..<3).filter { taskState($0) == 2 }.count
    }

    static let taskTitles = ["Copy final out...", "Start working...", "Prep workspace"]
}
