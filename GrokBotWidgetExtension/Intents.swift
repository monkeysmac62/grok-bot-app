import AppIntents
import WidgetKit

/// Tap the face on the home screen: toggles the expression in place,
/// no app opens.
struct ToggleFaceIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Grok Bot Face"
    static var description = IntentDescription("Switch the Grok Bot face between eyes open and happy.")

    func perform() async throws -> some IntentResult {
        SharedState.faceHappy.toggle()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

/// Tap a task row on the home screen: cycles todo -> doing -> done.
struct ToggleTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task"
    static var description = IntentDescription("Cycle a task between todo, doing and done.")

    @Parameter(title: "Task")
    var taskIndex: Int

    init() { taskIndex = 0 }

    init(taskIndex: Int) {
        self.taskIndex = taskIndex
    }

    func perform() async throws -> some IntentResult {
        SharedState.cycleTask(taskIndex)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
