//
//  AppDelegate.swift
//  joi
//
//  Created by Isaac Huntsman on 12/7/25.
//

import Cocoa

// @main: this is called to launch the app
// so what does it do?
//" Use AppDelegate later for app‑wide concerns: global configuration (logging, analytics), handling app lifecycle events, registering for push notifications, responding to open‑file/open‑URL events, or managing multiple windows."
@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // For now, immediately initialize the Agora engine
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

