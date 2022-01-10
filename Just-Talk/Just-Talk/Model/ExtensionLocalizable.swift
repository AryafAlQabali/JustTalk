//
//  ExtensionLocalizable.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 07/06/1443 AH.
//



import Foundation


extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
