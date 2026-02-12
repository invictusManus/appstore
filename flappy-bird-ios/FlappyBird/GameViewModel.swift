import CoreGraphics
import Foundation

struct Pipe: Identifiable {
    let id = UUID()
    var x: CGFloat
    let gapY: CGFloat
    let gapHeight: CGFloat
    let width: CGFloat
    var passed = false
}

final class GameViewModel: ObservableObject {
    @Published var birdY: CGFloat = 0
    @Published var birdVelocity: CGFloat = 0
    @Published var pipes: [Pipe] = []
    @Published var score = 0
    @Published var isGameOver = false
    @Published var isRunning = false

    let gravity: CGFloat = 0.55
    let jumpImpulse: CGFloat = -8.6
    let pipeSpeed: CGFloat = 2.6
    let pipeSpawnInterval = 1.5

    let birdX: CGFloat = 120
    let birdSize: CGFloat = 34

    private var worldHeight: CGFloat = 0
    private var worldWidth: CGFloat = 0
    private var elapsed: CGFloat = 0

    func startGame(width: CGFloat, height: CGFloat) {
        worldWidth = width
        worldHeight = height
        resetState()
        isRunning = true
    }

    func tap() {
        if isGameOver {
            startGame(width: worldWidth, height: worldHeight)
            return
        }

        guard isRunning else { return }
        birdVelocity = jumpImpulse
    }

    func tick(deltaTime: CGFloat) {
        guard isRunning, !isGameOver else { return }

        birdVelocity += gravity
        birdY += birdVelocity

        elapsed += deltaTime
        if elapsed >= pipeSpawnInterval {
            elapsed = 0
            spawnPipe()
        }

        for index in pipes.indices {
            pipes[index].x -= pipeSpeed

            if !pipes[index].passed && pipes[index].x + pipes[index].width < birdX {
                pipes[index].passed = true
                score += 1
            }
        }

        pipes.removeAll { $0.x + $0.width < -50 }

        if birdY < -worldHeight / 2 + birdSize / 2 || birdY > worldHeight / 2 - birdSize / 2 {
            gameOver()
            return
        }

        checkPipeCollision()
    }

    private func spawnPipe() {
        let margin: CGFloat = 120
        let gapHeight: CGFloat = 170
        let minGapY = -worldHeight / 2 + margin
        let maxGapY = worldHeight / 2 - margin
        let gapY = CGFloat.random(in: minGapY...maxGapY)

        pipes.append(Pipe(x: worldWidth + 80, gapY: gapY, gapHeight: gapHeight, width: 70))
    }

    private func checkPipeCollision() {
        let birdRect = CGRect(
            x: birdX - birdSize / 2,
            y: birdY - birdSize / 2,
            width: birdSize,
            height: birdSize
        )

        for pipe in pipes {
            let topPipeRect = CGRect(
                x: pipe.x,
                y: -worldHeight / 2,
                width: pipe.width,
                height: pipe.gapY - pipe.gapHeight / 2 + worldHeight / 2
            )

            let bottomPipeRect = CGRect(
                x: pipe.x,
                y: pipe.gapY + pipe.gapHeight / 2,
                width: pipe.width,
                height: worldHeight / 2 - pipe.gapY - pipe.gapHeight / 2
            )

            if birdRect.intersects(topPipeRect) || birdRect.intersects(bottomPipeRect) {
                gameOver()
                return
            }
        }
    }

    private func gameOver() {
        isGameOver = true
        isRunning = false
    }

    private func resetState() {
        birdY = 0
        birdVelocity = 0
        pipes = []
        score = 0
        elapsed = 0
        isGameOver = false
    }
}
