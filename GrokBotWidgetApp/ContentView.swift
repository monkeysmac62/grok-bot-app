import SwiftUI

/// Minimal host app: shows the same Grok Bot preview and explains
/// how to add the widget. Tapping here updates the same shared state
/// (App Group) as the widget, so you can see the state sync.
struct ContentView: View {
    @State private var faceHappy = SharedState.faceHappy
    @State private var tasks = (0..<3).map { SharedState.taskState($0) }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Grok Bot Widget")
                    .font(.largeTitle.bold())
                Text("This app only hosts the widget. Add it to your home screen and tap the face and tasks right there — no app opens.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                // Preview: same look as the widget (black square, face, tasks)
                ZStack {
                    Color(red: 0.02, green: 0.03, blue: 0.04)
                    VStack(spacing: 8) {
                        Text("Account Manager")
                            .font(.caption)
                            .foregroundColor(Color(white: 0.55))
                        Button { faceHappy.toggle(); SharedState.faceHappy = faceHappy } label: {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [.white, Color(red: 0.75, green: 0.88, blue: 1.0)], startPoint: .top, endPoint: .bottom))
                                HStack(spacing: 22) {
                                    Capsule().fill(Color.black).frame(width: 15, height: faceHappy ? 7 : 30)
                                    Capsule().fill(Color.black).frame(width: 15, height: faceHappy ? 7 : 30)
                                }
                            }
                            .frame(width: 88, height: 88)
                        }
                        .buttonStyle(.plain)
                        Text(faceHappy ? "Got it! On it." : "Tap me!")
                            .font(.caption2.bold()).foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(0..<3, id: \.self) { i in
                                Button {
                                    SharedState.cycleTask(i)
                                    tasks[i] = SharedState.taskState(i)
                                } label: {
                                    HStack {
                                        Text(tasks[i] == 2 ? "✓" : tasks[i] == 1 ? "◐" : "○")
                                        Text(SharedState.taskTitles[i])
                                    }
                                    .foregroundColor(.white)
                                    .font(.callout)
                                }
                            }
                        }
                        Text("\(tasks.filter { $0 == 2 }.count)/3 done")
                            .font(.caption).foregroundColor(Color(white: 0.55))
                    }
                    .padding()
                }
                .frame(width: 220, height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 28))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Add it to your home screen")
                        .font(.headline)
                    Text("1. Long-press an empty spot on the home screen.\n2. Tap + (top left).\n3. Search “Grok Bot”.\n4. Choose the small widget and tap Add Widget.\n5. Tap the face or a task right on the home screen.")
                        .font(.callout)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear {
            faceHappy = SharedState.faceHappy
            tasks = (0..<3).map { SharedState.taskState($0) }
        }
    }
}

#Preview {
    ContentView()
}
