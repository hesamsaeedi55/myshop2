//
//  MetronomeView.swift
//  Metronome Component
//
//  Extracted and built from odd-meter.com metronome
//

import SwiftUI
import AVFoundation
import AudioToolbox

struct MetronomeView: View {
    @State private var bpm: Int = 120
    @State private var isPlaying: Bool = false
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var beatAnimation: Bool = false
    
    private let minBPM: Int = 30
    private let maxBPM: Int = 300
    
    var body: some View {
        VStack(spacing: 30) {
            // BPM Display and Controls
            VStack(spacing: 20) {
                // BPM Display
                Text("\(bpm)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.2), value: bpm)
                
                // BPM Adjust Controls
                HStack(spacing: 40) {
                    // Decrease Button
                    Button(action: {
                        decreaseBPM()
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.primary)
                    }
                    .disabled(bpm <= minBPM)
                    .opacity(bpm <= minBPM ? 0.3 : 1.0)
                    
                    // Increase Button
                    Button(action: {
                        increaseBPM()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.primary)
                    }
                    .disabled(bpm >= maxBPM)
                    .opacity(bpm >= maxBPM ? 0.3 : 1.0)
                }
            }
            .padding(.vertical, 20)
            
            // Play/Pause Control
            Button(action: {
                toggleMetronome()
            }) {
                ZStack {
                    Circle()
                        .fill(isPlaying ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .scaleEffect(beatAnimation ? 1.1 : 1.0)
                        .animation(
                            isPlaying ? Animation.easeInOut(duration: 60.0 / Double(bpm)).repeatForever(autoreverses: true) : .default,
                            value: beatAnimation
                        )
                    
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 32))
                        .foregroundColor(isPlaying ? .red : .green)
                }
            }
            .padding(.top, 20)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onDisappear {
            stopMetronome()
        }
    }
    
    private func increaseBPM() {
        if bpm < maxBPM {
            withAnimation {
                bpm = min(bpm + 1, maxBPM)
            }
            if isPlaying {
                restartMetronome()
            }
        }
    }
    
    private func decreaseBPM() {
        if bpm > minBPM {
            withAnimation {
                bpm = max(bpm - 1, minBPM)
            }
            if isPlaying {
                restartMetronome()
            }
        }
    }
    
    private func toggleMetronome() {
        if isPlaying {
            stopMetronome()
        } else {
            startMetronome()
        }
    }
    
    private func startMetronome() {
        isPlaying = true
        beatAnimation = true
        
        // Create a timer that fires at the BPM rate
        let interval = 60.0 / Double(bpm)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            playTick()
        }
        
        // Play first tick immediately
        playTick()
    }
    
    private func stopMetronome() {
        isPlaying = false
        beatAnimation = false
        timer?.invalidate()
        timer = nil
        audioPlayer?.stop()
    }
    
    private func restartMetronome() {
        let wasPlaying = isPlaying
        stopMetronome()
        if wasPlaying {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startMetronome()
            }
        }
    }
    
    private func playTick() {
        // Generate a simple tick sound using system sound
        // For a more sophisticated sound, you could use AVAudioPlayer with a sound file
        AudioServicesPlaySystemSound(1104) // System sound ID for a tick
        
        // Visual feedback
        withAnimation(.easeInOut(duration: 0.1)) {
            beatAnimation.toggle()
        }
    }
}

// MARK: - Preview
#Preview {
    MetronomeView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MetronomeView()
        .preferredColorScheme(.dark)
}

