import SwiftUICore

struct TutorialStepDetails: Identifiable {
  let id = UUID()
  let title: String
  let description: String
  let interactionHint: String
  let action: () -> Void
}
