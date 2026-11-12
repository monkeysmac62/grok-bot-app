import SwiftUI
import WidgetKit

// MARK: - Face

struct GrokFaceView: View {
    let happy: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Large round gradient face: white (top) -> light blue (bottom)
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(red: 0.75, green: 0.88, blue: 1.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            // Eyes: open = two black vertical ovals; happy = two closed curves
            HStack(spacing: 22) {
                if happy {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black)
                        .frame(width: 22, height: 7)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black)
                        .frame(width: 22, height: 7)
                } else {
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 15, height: 30)
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 15, height: 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            // Small blue circle with three black dots, top-left of the face
            ZStack {
                Circle().fill(Color(red: 0.18, green: 0.66, blue: 1.0))
                HStack(spacing: 3) {
                    Capsule().fill(Color.black).frame(width: 3, height: 9)
                    Capsule().fill(Color.black).frame(width: 3, height: 9)
                    Capsule().fill(Color.black).frame(width: 3, height: 9)
                }
            }
            .frame(width: 30, height: 30)
            .offset(x: -6, y: -4)
        }
    }
}

// MARK: - Widget content (small size)

struct GrokBotWidgetView: View {
    let entry: GrokBotEntry

    var body: some View {
        ZStack {
            Color(red: 0.02, green: 0.03, blue: 0.04)
            VStack(spacing: 6) {
                Text("Account Manager")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(white: 0.55))

                // Tapping the face works ON the home screen (AppIntent, no app opens)
                Button(intent: ToggleFaceIntent()) {
                    GrokFaceView(happy: entry.faceHappy)
                        .frame(width: 88, height: 88)
                }
                .buttonStyle(.plain)

                // Speech bubble text changes with the face
                Text(entry.faceHappy ? "Got it! On it." : "Tap me!")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.white.opacity(0.14))
                    .clipShape(Capsule())

                // Task rows: each row is its own in-place button
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(0..<3, id: \.self) { index in
                        Button(intent: ToggleTaskIntent(taskIndex: index)) {
                            taskRow(index: index)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("\(entry.doneCount)/3 done")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(Color(white: 0.55))
            }
            .padding(10)
        }
    }

    @ViewBuilder
    private func taskRow(index: Int) -> some View {
        let state = entry.taskStates[index]
        HStack(spacing: 6) {
            // Status icon: empty square / half / checkmark
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(state == 2 ? Color.green : Color(white: 0.55), lineWidth: 1.2)
                    .frame(width: 13, height: 13)
                if state == 1 {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.yellow)
                        .frame(width: 7, height: 7)
                } else if state == 2 {
                    Text("✓")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.green)
                }
            }
            if index == 2 {
                // "Prep workspace" with "Prep" in blue, like the reference image
                (Text("Prep ").foregroundColor(Color(red: 0.18, green: 0.66, blue: 1.0))
                    + Text("workspace").foregroundColor(.white))
                    .font(.system(size: 12, weight: state == 2 ? .regular : .semibold))
                    .strikethrough(state == 2)
            } else {
                Text(SharedState.taskTitles[index])
                    .font(.system(size: 12, weight: state == 2 ? .regular : .semibold))
                    .foregroundColor(state == 2 ? Color(white: 0.55) : .white)
                    .strikethrough(state == 2)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
    }
}
