//
//  UserDefaults+extensions.swift
//  SmartIntercom
//
//  Created by Кирилл Худяков on 02/04/2019.
//  Copyright © 2019 MTS IoT. All rights reserved.
//
import UIKit


extension UserDefaults {
    var isVerified: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var userID: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var sessionID: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var username: String {
        get { return string(forKey: #function) ?? "" }
        set { set(newValue, forKey: #function) }
    }
    
    var fcmToken: String {
        get { return string(forKey: #function) ?? "" }
        set { set(newValue, forKey: #function) }
    }
    
    var phone: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var language: String {
        get { return string(forKey: #function) ?? "" }
        set { set(newValue, forKey: #function) }
    }
    
    var sip: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var password: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var domain: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var eventsPagesCount: Int {
        get { return integer(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var isNotFirstLaunch: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var isFirstAuth: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var delayForSendSignal: Double {
        get { return double(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var voipToken: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var didCheckAgreement: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var isUserChild: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}


// MARK: Feature toggles
extension UserDefaults {
    
    var isFeatureFixSipDomainEnabled: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var isFeatureDevPushesEnabled: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var isStable: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var isFeatureChildsEnabled: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    
}
