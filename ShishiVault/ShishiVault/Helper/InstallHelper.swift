//
//  InstallHelper.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 09.12.24.
//

import Foundation
import SwiftUI

class InstallationHelper: ObservableObject {
    @AppStorage("isFirstLaunch") private var isFirstLaunchStorage: Bool = false
    
    private static let installationKey = "isFirstLaunch"
    
    func isFirstLaunch() -> Bool {
        if !isFirstLaunchStorage {
            isFirstLaunchStorage = true
            print("This is the first launch. Keychaindata will be reset.")
            return true
        }
        return false
    }
}



//class InstallationHelper {
//    private static let installationKey = "isFirstLaunch"
//    
//    static var isFirstLaunch: Bool {
//        if UserDefaults.standard.bool(forKey: installationKey) == false {
//            UserDefaults.standard.set(true, forKey: installationKey)
//            UserDefaults.standard.synchronize()
//            print("This is the first launch. Keychaindata will be reset.")
//            return true
//        }
//        return false
//    }
//}
