//
//  ViewController.swift
//  joi
//
//  Created by Isaac Huntsman on 12/8/25.
//

import Cocoa
import AgoraRtcKit

let agoraAppId = Bundle.main.object(forInfoDictionaryKey: "AGORA_APP_ID") as? String
let agoraToken = Bundle.main.object(forInfoDictionaryKey: "AGORA_TOKEN") as? String

class ViewController: NSViewController, AgoraServiceDelegate {
    private var statusLabel: NSTextField!
    
    private let agoraService = AgoraService(appId: agoraAppId!,
                                            token: agoraToken,
                                            channelName: "demo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        agoraService.delegate = self
        agoraService.start()
    }
    
    func agoraService(_ service: AgoraService, didUpdateStatus text: String) {
        statusLabel.stringValue = text
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
}
