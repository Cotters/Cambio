import SwiftUI

struct TutorialView: View {
  
  @StateObject var gameEngine = TutorialGameEngine(handSize: 4)
  let onTutorialFinished: () -> Void
  
  @State private var currentStep = 0
  
  private var tutorialSteps: [TutorialStepDetails] {
    return [
      TutorialStepDetails(
        title: "Setup",
        description: "Cards will be dealt face down and briefly shown. \nYou must memorise your hand before the cards are flipped face down.",
        interactionHint: "Tap Next to deal your hand.",
        action: {
          gameEngine.beginPlaying(gameMode: .untimed)
        },
      ),
      TutorialStepDetails(
        title: "Memorise Your Hand",
        description: "Take time to memorise your hand. \nUsually your hand is only shown for a few seconds before being flipped face down.",
        interactionHint: "Tap next to hide your hand.",
        action: {
          gameEngine.hideCards()
        },
      ),
      TutorialStepDetails(
        title: "Taking a Card",
        description: "You can tap on either the deck or the discard pile to draw a card.",
        interactionHint: "Tap the deck to draw a card, then tap next.",
        action: {
          gameEngine.startGameplay()
        },
      ),
      TutorialStepDetails(
        title: "Playing a Card",
        description: """
  Now you have two options: 
    1. You can swap this card for a card in your hand by tapping on that card. 
    2. Discard this card by tapping on the discard pile.
  """,
        interactionHint: "Tap on a card in your hand, then tap next.",
        action: {},
      ),
      TutorialStepDetails(
        title: "Matching a Card",
        description: "If the top card in the discard pile matches a card in your hand, you can tap on that card in your hand to match it. Matched cards move from your hand to the discard pile; you can match multiple cards.",
        interactionHint: "Match a 2 in your hand. Tap next when done.",
        action: {
          gameEngine.enableCambio()
        },
      ),
      TutorialStepDetails(
        title: "Calling Cambio",
        description: "When you believe you have the fewest points, tap Cambio! to finish the game.",
        interactionHint: "Tap Cambio to end the game.",
        action: {},
      )
    ]
  }
  
  var body: some View {
    VStack(spacing: 8) {
      Text(tutorialSteps[currentStep].title)
        .font(.title2)
        .fontWeight(.bold)
    
      // Description Box
        VStack(alignment: .leading, spacing: 8) {
          Text(tutorialSteps[currentStep].description)
            .font(.body)
          
          HStack {
            Text("Action")
              .font(.headline)
              .foregroundColor(.blue)
            
            Text(tutorialSteps[currentStep].interactionHint)
              .font(.body)
              .italic()
          }
          
          HStack(spacing: 8) {
            Spacer()
            ForEach(0..<tutorialSteps.count, id: \.self) { index in
              Circle()
                .fill(index == currentStep ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 8, height: 8)
            }
            Spacer()
          }
          .padding(.top, 8)
        }
        .padding(.horizontal, 6)
        .fontDesign(.rounded)
      
      Spacer()
      
      TutorialGameView(
        gameEngine: gameEngine,
        onMenuTapped: onTutorialFinished,
        onRestartTapped: restartPressed
      )
      .frame(maxHeight: 400)
      .padding(.vertical, 10)
      
      Spacer()
      
      // Navigation Buttons
      HStack {
        Button(action: restartPressed) {
          HStack {
            Image(systemName: "arrow.uturn.backward")
            Text("Restart")
          }
          .frame(maxWidth: .infinity)
        }
        .disabled(currentStep == 0)
        .buttonStyle(.bordered)
        
        Button(action: nextStep) {
          HStack {
            Text(currentStep == tutorialSteps.count - 1 ? "Get Started" : "Next")
            Image(systemName: "chevron.right")
          }
          .frame(maxWidth: .infinity)
        }
        .disabled(!gameEngine.canProceed)
        .buttonStyle(.borderedProminent)
      }
      .padding()
    }
//    .background(Color(.systemGroupedBackground))
  }
  
  private func nextStep() {
    withAnimation(.easeInOut(duration: 0.3)) {
      if currentStep < tutorialSteps.count - 1 {
        tutorialSteps[currentStep].action()
        currentStep += 1
      } else {
        onTutorialFinished()
      }
    }
  }
  
  private func restartPressed() {
    withAnimation(.easeInOut(duration: 0.3)) {
      if currentStep > 0 {
        currentStep = 0
      }
      gameEngine.restartTutorial()
    }
  }
}

// MARK: - Preview
#Preview {
  TutorialView(
    onTutorialFinished: {},
  )
}
