import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    private let timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background

                ForEach(viewModel.pipes) { pipe in
                    PipeView(pipe: pipe, worldHeight: geometry.size.height)
                }

                BirdView()
                    .position(x: viewModel.birdX, y: geometry.size.height / 2 + viewModel.birdY)

                scoreOverlay

                if viewModel.isGameOver {
                    gameOverOverlay
                }

                if !viewModel.isRunning && !viewModel.isGameOver {
                    startOverlay
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.tap()
            }
            .onAppear {
                viewModel.startGame(width: geometry.size.width, height: geometry.size.height)
            }
            .onReceive(timer) { _ in
                viewModel.tick(deltaTime: 1.0 / 60.0)
            }
        }
        .ignoresSafeArea()
    }

    private var background: some View {
        LinearGradient(
            colors: [Color.cyan.opacity(0.65), Color.blue.opacity(0.85)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var scoreOverlay: some View {
        VStack {
            Text("\(viewModel.score)")
                .font(.system(size: 56, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .shadow(radius: 4)
                .padding(.top, 42)

            Spacer()
        }
    }

    private var startOverlay: some View {
        VStack(spacing: 12) {
            Text("Flappy Bird")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Text("Tippe zum Springen")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.95))
        }
        .padding(24)
        .background(.black.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
    }

    private var gameOverOverlay: some View {
        VStack(spacing: 14) {
            Text("Game Over")
                .font(.largeTitle.bold())
            Text("Score: \(viewModel.score)")
                .font(.title3)
            Text("Tippe zum Neustart")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 10)
    }
}

private struct BirdView: View {
    var body: some View {
        Circle()
            .fill(.yellow)
            .frame(width: 34, height: 34)
            .overlay(
                Circle()
                    .stroke(.orange, lineWidth: 3)
            )
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(.white)
                    .frame(width: 8, height: 8)
                    .padding(8)
            }
            .shadow(radius: 3)
    }
}

private struct PipeView: View {
    let pipe: Pipe
    let worldHeight: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: pipe.width, height: topHeight)
                .position(x: pipe.x + pipe.width / 2, y: topHeight / 2)

            Rectangle()
                .fill(Color.green)
                .frame(width: pipe.width, height: bottomHeight)
                .position(x: pipe.x + pipe.width / 2, y: worldHeight - bottomHeight / 2)
        }
        .overlay {
            VStack {
                Rectangle()
                    .stroke(Color.green.opacity(0.4), lineWidth: 2)
                    .frame(width: pipe.width, height: topHeight)
                    .position(x: pipe.x + pipe.width / 2, y: topHeight / 2)

                Spacer()

                Rectangle()
                    .stroke(Color.green.opacity(0.4), lineWidth: 2)
                    .frame(width: pipe.width, height: bottomHeight)
                    .position(x: pipe.x + pipe.width / 2, y: worldHeight - bottomHeight / 2)
            }
        }
    }

    private var topHeight: CGFloat {
        max(0, worldHeight / 2 + pipe.gapY - pipe.gapHeight / 2)
    }

    private var bottomHeight: CGFloat {
        max(0, worldHeight / 2 - pipe.gapY - pipe.gapHeight / 2)
    }
}

#Preview {
    GameView()
}
