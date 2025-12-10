//
//  LiveProcessAudio.swift
//  joi
//
//  Created by Isaac Huntsman on 12/9/25.
//

import Foundation
import AVFAudio

final class AudioProcessor {
    private let engine = AVAudioEngine()

    func start() throws {
        let input = engine.inputNode
        let format = input.inputFormat(forBus: 0)

        // we install a tap on the microphone default bus for real time processing.
        input.installTap(onBus: 0,
                         bufferSize: 2048,
                         format: format) { buffer, time in
            // here we can real-time process
            // buffer.floatChannelData / buffer.int16ChannelData, frameLength, etc.
        }

        engine.prepare()
        try engine.start()
    }

    func stop() {
        engine.inputNode.removeTap(onBus: 0) // perhaps trigger when user presses mute or goes back to home screen?
        engine.stop()
    }
}
