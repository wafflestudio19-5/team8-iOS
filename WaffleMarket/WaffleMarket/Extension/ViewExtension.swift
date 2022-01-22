//
//  ViewExtension.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/22.
//

import Foundation
import SwiftUI
extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}
