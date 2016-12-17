//
//  NSBundle+Current.swift
//  Relical
//
//  Created by Marcel Dierkes on 23.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import Foundation

internal extension Bundle {
    /// The current framework bundle
    @nonobjc internal static let current = Bundle(for: DiskCache.self)
    
    /// The current bundle identifier
    internal var identifier: String {
        return self.bundleIdentifier!
    }
}
