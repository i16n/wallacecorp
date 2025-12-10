//
//  stuff.swift
//  joi
//
//  Created by Isaac Huntsman on 12/8/25.
//

import AVFoundation

// "An AVCaptureSession is the basis for all media capture in iOS and macOS"

// need AVCaptureInput?

// need to put this in the func that connect to a mic?
switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized: // The user has previously granted access to the camera.
        self.setupCaptureSession()
    
    case .notDetermined: // The user has not yet been asked for camera access.
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.setupCaptureSession()
            }
        }
    
    case .denied: // The user has previously denied access.
        return


    case .restricted: // The user can't grant access due to restrictions.
        return
}
