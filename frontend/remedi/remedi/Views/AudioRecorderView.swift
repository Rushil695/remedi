//
//  AudioRecorderView.swift
//  remedi
//
//  Created by Rushil Madhu on 4/7/24.
//

import SwiftUI
import AVFoundation

struct AudioRecorderView: View {
    @State private var audioRecorder: AVAudioRecorder?
    @State private var isRecording = false
    @State private var audioLevels: [CGFloat] = Array(repeating: 0.1, count: 30) // For visualization

    var body: some View {
        VStack {
            AudioVisualizationView(levels: audioLevels)
                .frame(height: 100)
                .padding()

            Button(action: {
                self.isRecording ? self.stopRecording() : self.startRecording()
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .foregroundColor(.white)
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .clipShape(Capsule())
            }
        }
    }

    func startRecording() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(UUID().uuidString).m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()

            // Start updating audio levels
            isRecording = true
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                guard let recorder = self.audioRecorder else { return }
                recorder.updateMeters()
                let normalizedLevel = max(0.2, CGFloat(recorder.averagePower(forChannel: 0)) + 50) / 2 // Normalizing the sound level
                self.audioLevels.removeFirst()
                self.audioLevels.append(normalizedLevel)
            }
        } catch {
            print("Could not start recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
    }
}

struct AudioVisualizationView: View {
    var levels: [CGFloat]

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(levels, id: \.self) { level in
                    Rectangle()
                        .frame(width: 3, height: CGFloat(level) * geometry.size.height)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    AudioRecorderView()
}
