# Flappy Bird für iOS (SwiftUI)

Ein einfacher Flappy-Bird-Klon in **SwiftUI**, den du direkt in Xcode öffnen und starten kannst.

## Inhalt

- `FlappyBird/FlappyBirdApp.swift` – App-Einstiegspunkt
- `FlappyBird/GameView.swift` – UI und Rendering
- `FlappyBird/GameViewModel.swift` – Spielphysik, Pipes, Kollisionen und Score

## So startest du das Projekt

1. Öffne Xcode und erstelle ein neues **iOS App**-Projekt (SwiftUI).
2. Ersetze die automatisch erzeugten Swift-Dateien durch die Dateien aus `FlappyBird/`.
3. Starte die App im Simulator oder auf deinem iPhone.

## Steuerung

- **Tippen** = Vogel springt
- Beim Zusammenstoß mit Pipe oder Bildschirmrand ist das Spiel vorbei
- Nach **Game Over** erneut tippen für Neustart

## Anpassungen

Du kannst die Schwierigkeit im `GameViewModel` über diese Werte anpassen:

- `gravity`
- `jumpImpulse`
- `pipeSpeed`
- `pipeSpawnInterval`
