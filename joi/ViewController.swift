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
let agoraKey = Bundle.main.object(forInfoDictionaryKey: "AGORA_KEY") as? String
let agoraSecret = Bundle.main.object(forInfoDictionaryKey: "AGORA_SECRET") as? String
let tempToken = Bundle.main.object(forInfoDictionaryKey: "AGORA_TEMP_TOKEN") as? String // do this in code eventually. It lasts for 1 day only. Got this from the Agora GUI console.
// 1578
//

class ViewController: NSViewController, AgoraServiceDelegate {
    private var statusLabel: NSTextField!
    
    // call initializer, pass vars to it (this is calling init in AgoraService.swift). It's a constructor but swift calls it initializer
    private let agoraService = AgoraService(appId: agoraAppId!,
                                            token: agoraToken,
                                            channelName: "demo")
    
    private let agoraAPIClient = AgoraAPIClient(appId: agoraAppId!, customerKey: agoraKey!, customerSecret: agoraSecret!)
    
    deinit {
        agoraService.stop()
    }
    
    // overriding NSViewController viewDidLoad to start the agora service
    // this only gets called if/when AppKit framework calls it after the view loads. This is called a "lifecycle method"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        agoraService.delegate = self
        agoraService.start()
        agoraAPIClient.joinAgent(channel: "1578", token: tempToken!) { result in
            switch result {
            case .success(let joinResponse):
                // Handle success, e.g. store joinResponse or update UI
                print("Joined: \(joinResponse)")
            case .failure(let error):
                // Handle error (show alert, retry, etc.)
                print("Join failed: \(error.localizedDescription)")
            }
        }
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
