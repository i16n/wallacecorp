//
//  AgoraService.swift
//  joi
//
//  Created by Isaac Huntsman on 12/10/25.
//

import Foundation
import AgoraRtcKit

protocol AgoraServiceDelegate: AnyObject {
    func agoraService(_ service: AgoraService, didUpdateStatus text: String)
}

final class AgoraService: NSObject {
    private let appId: String
    private let token: String?
    private let channelName: String
    private(set) var agoraKit: AgoraRtcEngineKit!

    weak var delegate: AgoraServiceDelegate?

    init(appId: String, token: String?, channelName: String) {
        self.appId = appId
        self.token = token
        self.channelName = channelName
        super.init()
    }

    func start() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId,
                                                  delegate: self)
        joinChannel()
        
        // then have the agent join the channel?
        
        
    }
    
    func stop() {
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
        agoraKit = nil
    }

    private func joinChannel() {
        let options = AgoraRtcChannelMediaOptions()
        options.channelProfile = .communication
        options.clientRoleType = .broadcaster
        options.publishMicrophoneTrack = true
        options.autoSubscribeAudio = true

        agoraKit.joinChannel(byToken: token,
                             channelId: channelName,
                             uid: 1578,
                             mediaOptions: options)
    }
}

extension AgoraService: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit,
                   didJoinChannel channel: String,
                   withUid uid: UInt,
                   elapsed: Int) {
        delegate?.agoraService(self,
                               didUpdateStatus: "You joined. Waiting for others")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit,
                   didJoinedOfUid uid: UInt,
                   elapsed: Int) {
        delegate?.agoraService(self,
                               didUpdateStatus: "User \(uid) joined")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit,
                   didOfflineOfUid uid: UInt,
                   reason: AgoraUserOfflineReason) {
        delegate?.agoraService(self,
                               didUpdateStatus: "User \(uid) left")
    }
}
