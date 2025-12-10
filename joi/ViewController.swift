//
//  ViewController.swift
//  joi
//
//  Created by Isaac Huntsman on 12/8/25.
//
import Cocoa
import AgoraRtcKit

class ViewController: NSViewController {
    private var statusLabel: NSTextField!
    
    let appId = env["AGORA_APP_ID"]
    let channelName = "demo" // unknown rn?
    let token = env["AGORA_TOKEN"]

    var agoraKit: AgoraRtcEngineKit!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize the Agora engine
        initializeAgoraVoiceSDK()
        // Set up the user interface
        setupUI()
        // Join an Agora channel
        joinChannel()
    }
    
    func setupUI(){
        let mainView = NSView(frame: view.bounds)
        mainView.wantsLayer = true

        statusLabel = NSTextField(labelWithString: "Waiting for other user")
        statusLabel.alignment = .center
        statusLabel.font = .systemFont(ofSize: 20)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        mainView.addSubview(statusLabel)
        view.addSubview(mainView)

        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
        ])
    }
    
    // Initializes the Voice SDK instance
    func initializeAgoraVoiceSDK() {
        // Create an instance of AgoraRtcEngineKit and set the delegate
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
    }
    
    // Join the channel with specified options
    func joinChannel() {
        let options = AgoraRtcChannelMediaOptions()
        // In voice calling, set the channel use-case to communication
        options.channelProfile = .communication
        // Set the user role as broadcaster (default is audience)
        options.clientRoleType = .broadcaster
        // Publish audio captured by microphone
        options.publishMicrophoneTrack = true
        // Auto subscribe to all audio streams  \
        options.autoSubscribeAudio = true
        // If you set uid=0, the engine generates a uid internally; on success, it triggers didJoinChannel callback
        // Join the channel with a temporary token
        agoraKit.joinChannel(
            byToken: token,
            channelId: channelName,
            uid: 0,
            mediaOptions: options
        )
    }
}

// Extension for handling Agora SDK callbacks
extension ViewController: AgoraRtcEngineDelegate {
    
    // Triggered when the local user successfully joins a channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("Successfully joined channel: \(channel) with UID: \(uid)")
        statusLabel.stringValue = "You Successfully joined. Waiting for other users"
    }
    
    // Triggered when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("User \(uid) joined after \(elapsed) milliseconds")
        statusLabel.stringValue = "User \(uid) joined"
    }
    // Triggered when a remote user leaves the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("User \(uid) left:  Reason -> \(reason)")
        statusLabel.stringValue = "User \(uid) left"
    }
}
