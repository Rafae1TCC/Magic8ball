//
//  EightBallView.swift
//  Magic8ball
//
//  Created by Rafael Cabrera on 9/3/26.
//


import SwiftUI

struct EightBallView: View {

    @StateObject private var viewModel = EightBallViewModel()

    var body: some View {
        VStack(spacing: 24) {

            Text("Magic 8-Ball")
                .font(.largeTitle)
                .bold()

            Text("Shake to get an answer")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(viewModel.currentAnswer)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.15))
                .cornerRadius(16)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
            }

            Text(viewModel.statusText)
                .font(.footnote)
                .foregroundColor(viewModel.isRunning ? .green : .gray)

            HStack(spacing: 16) {
                Button(viewModel.isRunning ? "Stop" : "Start") {
                    viewModel.isRunning ? viewModel.stop() : viewModel.start()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Demo Mode")
                    .font(.headline)
                Button("Trigger Shake") {
                    viewModel.triggerDemoShake()
                }
                .buttonStyle(.bordered)
            }

            if !viewModel.history.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("History")
                        .font(.headline)
                    ForEach(viewModel.history, id: \.self) { answer in
                        Text("• \(answer)")
                            .font(.footnote)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    EightBallView()
}