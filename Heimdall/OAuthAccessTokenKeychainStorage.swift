//
//  OAuthAccessTokenKeychainStorage.swift
//  Heimdall
//
//  Created by Tim Brückmann on 10.02.15.
//  Copyright (c) 2015 B264 GmbH. All rights reserved.
//

import KeychainAccess

/// A persistent Keychain-based access token store.
@objc
public class OAuthAccessTokenKeychainStorage: OAuthAccessTokenStorage {
    private let keychain: Keychain

    /// Initializes a new Keychain-based access token store.
    ///
    /// :param: service The Keychain service.
    ///     Default: `de.rheinfabrik.heimdall.oauth`.
    ///
    /// :returns: A new Keychain-based access token store initialized with the
    ///     the given service.
    public init(service: String = "de.rheinfabrik.heimdall.oauth") {
        keychain = Keychain(service: service)
    }
    
    public func storeAccessToken(accessToken: OAuthAccessToken?) {
        keychain["access_token"] = accessToken?.accessToken
        keychain["token_type"] = accessToken?.tokenType
        keychain["expires_at"] = accessToken?.expiresAt?.timeIntervalSince1970.description
        keychain["refresh_token"] = accessToken?.refreshToken
    }
    
    public func retrieveAccessToken() -> OAuthAccessToken? {
        let accessToken = keychain["access_token"]
        let tokenType = keychain["token_type"]
        let refreshToken = keychain["refresh_token"]
        
        var expiresAt: NSDate?
        if let expiresAtInSeconds = keychain["expires_at"] as NSString? {
            expiresAt = NSDate(timeIntervalSince1970: expiresAtInSeconds.doubleValue)
        }
        
        if let accessToken = accessToken {
            if let tokenType = tokenType {
                return OAuthAccessToken(
                    accessToken: accessToken,
                    tokenType: tokenType,
                    expiresAt: expiresAt,
                    refreshToken: refreshToken)
            }
        }
        
        return nil
    }
}
