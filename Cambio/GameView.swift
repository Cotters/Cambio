import SwiftUI

struct GameView: View {
  @Namespace private var cardNamespace
  @StateObject var gameEngine: GameEngine
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Background
        LinearGradient(
          gradient: Gradient(colors: [
            Color(.systemBackground),
            Color.green.opacity(0.1),
            Color.blue.opacity(0.15)
          ]),
          startPoint: .top,
          endPoint: .bottom
        )
        .ignoresSafeArea()
        
        VStack(spacing: 0) {
          // North Player Section
          VStack(spacing: 8) {
            PlayerSectionHeader(isCurrentPlayer: gameEngine.currentPlayer == .north)
            
            // North viewing card - positioned above hand
            ZStack {
              EnhancedPlayerHand(
                namespace: cardNamespace,
                cards: gameEngine.hands[.north] ?? [],
                onCardSelected: gameEngine.onCardSelected,
                isOpponent: true
              )
              .animation(.easeInOut, value: gameEngine.hands[.north])
              
              if gameEngine.currentPlayer == .north, let card = gameEngine.viewingCard {
                VStack {
                  ViewingCardDisplay(card: card, namespace: cardNamespace)
                  Spacer()
                }
              }
            }
            .frame(height: HAND_CARD_HEIGHT + 40) // Fixed height to prevent movement
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.secondarySystemBackground).opacity(0.8))
              .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
          )
          .padding(.horizontal, 16)
          
          Spacer()
          
          // Center Game Area
          if gameEngine.isPlaying {
            GameCenterArea(
              namespace: cardNamespace,
              gameEngine: gameEngine,
              onDeckTapped: onDeckTapped,
              onPileTapped: onPileTapped
            )
            .padding(.horizontal, 16)
          } else {
            GameOverView(
              northScore: gameEngine.hands[.north]?.getScore() ?? 0,
              southScore: gameEngine.hands[.south]?.getScore() ?? 0,
              onRestartTapped: onRestartTapped
            )
            .transition(.scale.combined(with: .opacity))
            .animation(.easeInOut, value: gameEngine.gameState)
          }
          
          Spacer()
          
          // South Player Section (Player)
          VStack(spacing: 8) {
            // South viewing card and hand in fixed container
            ZStack {
              EnhancedPlayerHand(
                namespace: cardNamespace,
                cards: gameEngine.hands[.south] ?? [],
                onCardSelected: onPlayerCardTapped,
                isOpponent: false
              )
              .animation(.easeInOut(duration: 0.4), value: gameEngine.hands[.south])
              
              if gameEngine.currentPlayer == .south, let card = gameEngine.viewingCard {
                VStack {
                  Spacer()
                  ViewingCardDisplay(card: card, namespace: cardNamespace)
                }
              }
            }
            .frame(height: HAND_CARD_HEIGHT + 40) // Fixed height to prevent movement
            
            PlayerSectionHeader(isCurrentPlayer: gameEngine.currentPlayer == .south)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.secondarySystemBackground).opacity(0.8))
              .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
          )
          .padding(.horizontal, 16)
          .padding(.bottom, 16) // Add bottom padding for visibility
        }
      }
    }
    .onAppear { beginGame() }
  }
  
  private func beginGame() {
    Task {
      dealInitialCardsAnimated()
      try? await Task.sleep(for: .milliseconds((150 * 8) * 2))
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(1500))
      flipAllCards()
      try? await Task.sleep(for: .milliseconds(800))
      gameEngine.flipCardOntoPile()
    }
  }
  
  private func onRestartTapped() {
    gameEngine.restartGame()
    beginGame()
  }
  
  private func onPlayerCardTapped(_ card: Card) {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onCardSelected(card)
    }
  }
  
  private func onDeckTapped() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onDeckTapped()
    }
  }
  
  private func onPileTapped() {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
      gameEngine.onPileTapped()
    }
  }
  
  private func dealInitialCardsAnimated() {
    Task {
      for player in Player.allCases {
        for _ in 0..<gameEngine.handSize {
          try? await Task.sleep(for: .milliseconds(150))
          withAnimation(.spring()) {
            gameEngine.draw(for: player)
          }
        }
      }
    }
  }
  
  private func flipAllCards() {
    for player in Player.allCases {
      withAnimation(.spring()) {
        gameEngine.flipAllCards(for: player)
      }
    }
  }
}

struct PlayerSectionHeader: View {
  let isCurrentPlayer: Bool
  
  var body: some View {
    HStack {
      if isCurrentPlayer {
        Image(systemName: "play.fill")
          .font(.system(size: 14, weight: .bold))
          .scaleEffect(isCurrentPlayer ? 1.2 : 1.0)
          .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isCurrentPlayer)
      }
      Spacer()
    }
    .frame(height: 8)
    .padding(.vertical, 2)
  }
}

struct EnhancedPlayerHand: View {
  let namespace: Namespace.ID
  let cards: [Card]
  let onCardSelected: (Card) -> Void
  let isOpponent: Bool
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(cards.prefix(cards.count), id: \.id) { card in
        FlippableCard(card: card)
          .matchedGeometryEffect(id: card.id, in: namespace)
          .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            onCardSelected(card)
          }
          .frame(height: HAND_CARD_HEIGHT)
          .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
      }
    }
    .frame(height: HAND_CARD_HEIGHT)
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(isOpponent ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(isOpponent ? Color.red.opacity(0.2) : Color.blue.opacity(0.2), lineWidth: 1)
        )
    )
  }
}

struct GameCenterArea: View {
  let namespace: Namespace.ID
  let gameEngine: GameEngine
  let onDeckTapped: () -> Void
  let onPileTapped: () -> Void
  
  var body: some View {
    VStack(spacing: 24) {
      // Deck and Pile
      HStack(spacing: 40) {
        // Draw Deck
        VStack(spacing: 12) {
          AnimatedRealisticDeckView(namespace: namespace, deck: gameEngine.deck)
            .frame(height: HAND_CARD_HEIGHT)
            .onTapGesture(perform: onDeckTapped)
          
          Text("Draw")
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundColor(.blue)
        }
        
        // Discard Pile
        VStack(spacing: 12) {
          AnimatedRealisticDeckView(namespace: namespace, deck: gameEngine.pile)
            .frame(height: HAND_CARD_HEIGHT)
            .animation(.easeInOut(duration: 0.4), value: gameEngine.pile)
            .onTapGesture(perform: onPileTapped)
          
          Text("Discard")
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundColor(.orange)
        }
      }
      .zIndex(200)
      
      // Game Info
      VStack(spacing: 16) {
        HStack(spacing: 20) {
          // Cards remaining
          HStack(spacing: 8) {
            Image(systemName: "rectangle.stack.fill")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(.blue)
            Text("\(gameEngine.deck.count) cards")
              .font(.system(size: 16, weight: .medium, design: .rounded))
              .foregroundColor(.primary)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(
            Capsule()
              .fill(Color(.tertiarySystemBackground))
          )
          
          // Current turn indicator
          HStack(spacing: 8) {
            Image(systemName: "person.fill")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(.green)
            Text("\(gameEngine.currentPlayer == .north ? "North's" : "South's") Turn")
              .font(.system(size: 16, weight: .medium, design: .rounded))
              .foregroundColor(.primary)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(
            Capsule()
              .fill(Color.green.opacity(0.1))
              .overlay(
                Capsule()
                  .stroke(Color.green.opacity(0.3), lineWidth: 1)
              )
          )
        }
        
        // Cambio Button
        Button(action: gameEngine.onCambioTapped) {
          HStack(spacing: 12) {
            Image(systemName: "star.fill")
              .font(.system(size: 18, weight: .bold))
            Text("Call Cambio!")
              .font(.system(size: 18, weight: .bold, design: .rounded))
          }
          .foregroundColor(.white)
          .padding(.horizontal, 32)
          .padding(.vertical, 14)
          .background(
            LinearGradient(
              gradient: Gradient(colors: [.orange, .red]),
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .clipShape(Capsule())
          .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 3)
        }
        .scaleEffect(gameEngine.currentPlayer == .south ? 1.0 : 0.8)
        .opacity(gameEngine.currentPlayer == .south ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.3), value: gameEngine.currentPlayer)
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color(.secondarySystemBackground).opacity(0.8))
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
    )
  }
}

struct ViewingCardDisplay: View {
  let card: Card
  let namespace: Namespace.ID
  
  var body: some View {
    FlippableCard(card: card, canFlip: false)
      .matchedGeometryEffect(id: card.id, in: namespace)
      .frame(height: HAND_CARD_HEIGHT * 0.9)
      .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
      .animation(.easeInOut(duration: 0.4), value: card)
  }
}

#Preview {
  @Previewable @Namespace var namespace
  ViewingCardDisplay(card: Card(rank: .ace, suit: .hearts, isFaceUp: true), namespace: namespace)
}

#Preview {
  let engine = GameEngine(handSize: 4)
  GameView(gameEngine: engine)
}
