//
//  MockVideoAdNetworkAdapter.swift
//  iOS Video Interstitial Advert MediatorTests
//
//  Created by Peter Morris on 06/11/2018.
//  Copyright © 2018 Pete Morris. All rights reserved.
//

import XCTest
@testable import iOS_Video_Interstitial_Advert_Mediator

class MockVideoAdNetworkAdapter: NSObject, VideoAdNetworkAdapter {
    static var staticPriority = 0
    static var delegateSet = false
    static var adRequested = false
    static var shouldFail = false
    static var shouldDelegate = false
    required init?(type: VideoAdNetworkSettings.NetworkType) {
        switch type {
        case .test: self.priority = 0
        default: return nil
        }
    }
    weak var delegate: VideoAdNetworkAdapterDelegate? {
        didSet {
            MockVideoAdNetworkAdapter.delegateSet = true
        }
    }
    var priority: Int {
        didSet {
            MockVideoAdNetworkAdapter.staticPriority = priority
        }
    }
    func requestAd() {
        MockVideoAdNetworkAdapter.adRequested = true
        if MockVideoAdNetworkAdapter.shouldDelegate {
            if MockVideoAdNetworkAdapter.shouldFail {
                delegate?.adNetwork(self, didFailToLoad: NSError(domain: "", code: 999, userInfo: nil))
            } else {
                delegate?.adNetwork(self, didLoad: MockAd())
            }
        }
    }
    func isEqual(to anotherAdNetwork: VideoAdNetworkAdapter) -> Bool {
        return anotherAdNetwork is MockVideoAdNetworkAdapter
    }
}

class AnotherMockVideoAdNetworkAdapter: NSObject, VideoAdNetworkAdapter {
    static var instances: [AnotherMockVideoAdNetworkAdapter] = []
    required init?(type: VideoAdNetworkSettings.NetworkType) {
        switch type {
        case .test: self.priority = 0
        default: return nil
        }
        super.init()
    }
    weak var delegate: VideoAdNetworkAdapterDelegate?
    var priority: Int
    func requestAd() {
        AnotherMockVideoAdNetworkAdapter.instances.append(self)
    }
    func isEqual(to anotherAdNetwork: VideoAdNetworkAdapter) -> Bool {
        return false
    }
    static func completeRequests() {
        instances.forEach { instance in
            instance.delegate?.adNetwork(instance, didLoad: MockAd())
        }
    }
}