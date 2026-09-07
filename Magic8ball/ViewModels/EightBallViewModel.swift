//
//  EightBallViewModel.swift
//  Magic8ball
//
//  Created by Rafael Cabrera on 9/3/26.
//


import Foundation
import Combine

final class EightBallViewModel: ObservableObject {

    // MARK: - UI-ready state

    @Published var isRunning: Bool = false
    @Published var accelerationMagnitude: Double = 0.0
    @Published var statusText: String = "Stopped"
    @Published var errorMessage: String? = nil
    @Published var currentAnswer: String = "Shake to get an answer"
    @Published var history: [String] = []

    // MARK: - Dependencies

    private let motionManager = MotionManager()

    // MARK: - Shake detection tuning

    private let shakeThreshold: Double = 2.0
    private let cooldownDuration: TimeInterval = 1.0
    private var lastShakeDate: Date?

    init() {
        motionManager.onUpdate = { [weak self] magnitude in
            self?.handleUpdate(magnitude: magnitude)
        }
        motionManager.onError = { [weak self] message in
            self?.errorMessage = message
            self?.statusText = "Error"
            self?.isRunning = false
        }
    }

    // MARK: - Actions

    func start() {
        errorMessage = nil
        motionManager.startUpdates()
        isRunning = true
        statusText = "Running - Shake your phone"
    }

    func stop() {
        motionManager.stopUpdates()
        isRunning = false
        statusText = "Stopped"
    }

    func reset() {
        currentAnswer = "Shake to get an answer"
        history = []
        errorMessage = nil
    }

    // Demo Mode: manually triggers a shake result without needing real motion.
    func triggerDemoShake() {
        recordAnswer()
    }

    // MARK: - Motion handling

    private func handleUpdate(magnitude: Double) {
        accelerationMagnitude = magnitude

        // Only trigger when crossing the threshold, not on every sample above it.
        guard magnitude > shakeThreshold else { return }

        if let lastShakeDate = lastShakeDate,
           Date().timeIntervalSince(lastShakeDate) < cooldownDuration {
            return
        }

        lastShakeDate = Date()
        recordAnswer()
    }

    private func recordAnswer() {
        let answer = EightBallAnswers.all.randomElement() ?? "Ask again later"
        currentAnswer = answer
        history.insert(answer, at: 0)
        if history.count > 3 {
            history = Array(history.prefix(3))
        }
    }
}
