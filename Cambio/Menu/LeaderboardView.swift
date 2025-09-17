import SwiftUI
import GameKit

struct LeaderboardView: View {
  @EnvironmentObject private var gameCenter: GameCenterManager
  @State private var leaderboardEntries: [GKLeaderboard.Entry] = []
  @State private var isLoading = false
  @State private var error: Error?
  @State private var showingError = false
  
  var body: some View {
    ZStack {
      if isLoading {
        ProgressView("Loading leaderboard...")
      } else if leaderboardEntries.isEmpty {
        ContentUnavailableView(
          label: {
            VStack {
              Image(systemName: "trophy")
                .font(.system(size: 30, weight: .bold))
              Text("No scores yet")
            }
          },
          description: {
            Text("Be the first to submit a score!")
          },
          actions: {
            Button(action: {
              Task {
                await loadLeaderboard()
              }
            }) {
              Text("Retry")
              Image(systemName: "arrow.clockwise")
            }
          }
        )
      } else {
        List {
          ForEach(Array(leaderboardEntries.enumerated()), id: \.element.player.displayName) { index, entry in
            LeaderboardRow(entry: entry, rank: index + 1)
          }
        }
        .refreshable {
          await loadLeaderboard()
        }
      }
    }
    .task {
      await loadLeaderboard()
    }
  }
  
  private func loadLeaderboard() async {
    isLoading = true
    defer { isLoading = false }
    do {
      let player = GKLocalPlayer.local
      try await player.authenticate()
      
      guard let leaderboard = try await GKLeaderboard.loadLeaderboards(IDs: [MAIN_LEADERBOARD_ID]).first else {
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Leaderboard not found"])
      }
      
      let entries = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...100))
      
      await MainActor.run {
        self.leaderboardEntries = entries.1
        self.error = nil
      }
    } catch {
      await MainActor.run {
        self.error = error
        self.showingError = true
        print("Error loading leaderboard: \(error)")
      }
    }
  }
}

struct LeaderboardRow: View {
  let entry: GKLeaderboard.Entry
  let rank: Int
  
  var body: some View {
    HStack {
      // Rank
      Text("\(rank)")
        .font(.headline)
        .frame(width: 30)
        .foregroundColor(rank <= 3 ? .yellow : .primary)
      
      // Player avatar (simplified - real implementation would use GKPlayer's photo)
      Image(systemName: "person.circle.fill")
        .font(.title2)
        .foregroundColor(.blue)
      
      Text(entry.player.displayName)
        .font(.body)
      
      Spacer()
      
      Text("\(entry.score)")
        .font(.headline)
        .monospacedDigit()
      
      if entry.context != 0 {
        Text("(\(entry.context))")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  LeaderboardView()
}
