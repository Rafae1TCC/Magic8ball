//
//  MotionManager.swift
//  Magic8ball
//
//  Created by Rafael Cabrera on 9/3/26.
//


import Foundation
import CoreMotion

final class MotionManager {

    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    var onUpdate: ((Double) -> Void)?
    var onError: ((String) -> Void)?

    var isAvailable: Bool {
        motionManager.isDeviceMotionAvailable
    }

    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            DispatchQueue.main.async {
                self.onError?("Motion data is not available on this device.")
            }
            return
        }

        motionManager.deviceMotionUpdateInterval = 1.0 / 50.0
        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
                return
            }

            guard let data = data else { return }

            let acceleration = data.userAcceleration
            let magnitude = sqrt(
                acceleration.x * acceleration.x +
                acceleration.y * acceleration.y +
                acceleration.z * acceleration.z
            )

            DispatchQueue.main.async {
                self.onUpdate?(magnitude)
            }
        }
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
