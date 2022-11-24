//
//  LooperService.swift
//  
//
//  Created by Bill Gestrich on 5/11/22.
//

import Foundation
import NightscoutClient
import LoopKit

class LooperService: ObservableObject, PersistenceControllerDelegate {
    
    @Published var loopers: [Looper] = []
    @Published var selectedLooper: Looper? = nil
    
    private var accountService: AccountService
    
    init(accountService: AccountService){
        self.accountService = accountService
        refreshSync()
        AccountService.shared.delegate = self
    }
        
    func addLooper(_ looper: Looper) throws {
        try accountService.addLooper(looper)
    }
    
    func removeLooper(_ looper: Looper) throws {
        try accountService.removeLooper(looper)
    }
    
    func updateActiveLoopUser(_ looper: Looper) throws {
        let _ = try accountService.updateLooperLastSelectedDate(looper: looper, Date())
    }
    
    func removeAllLoopers() throws {
        for looper in loopers {
            try removeLooper(looper)
        }
    }
    
    func refresh(){
        //TODO: This dispatch async is to prevent SwiftUI triggering this causes recursive updates.
        DispatchQueue.main.async {
            self.refreshSync()
        }
    }
    
    func refreshSync(){
        do {
            self.loopers = try accountService.getLoopers()
                .sorted(by: {$0.name < $1.name})
            self.selectedLooper = self.loopers.sorted(by: {$0.lastSelectedDate < $1.lastSelectedDate}).last
        } catch {
            self.selectedLooper = nil
            self.loopers = []
            print("Error Fetching Keychain \(error)")
        }
    }
    
    
    //MARK: PersistenceControllerDelegate
    
    func persistentServiceDataUpdated(_ service: AccountService) {
        self.refresh()
    }
    
}

extension LooperService {
    func simulatorCredentials() -> NightscoutCredentials? {
        
        let fileURL = URL(filePath: "/Users/bill/Desktop/Loop/loopcaregiver-prod.json")
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        let data = try! Data(contentsOf: fileURL)
        let credentials = try! JSONDecoder().decode(NightscoutCredentials.self, from: data)
        return NightscoutCredentials(url: credentials.url.absoluteURL, secretKey: credentials.secretKey, otpURL: credentials.otpURL)
    }
}
