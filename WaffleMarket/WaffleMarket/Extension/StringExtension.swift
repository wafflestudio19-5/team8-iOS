//
//  StringExtension.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/24.
//

import Foundation
import UIKit
extension String {
    func getEstimatedFrame(with font: UIFont) -> CGRect {
            let size = CGSize(width: UIScreen.main.bounds.width * 2/3, height: 1000)
            let optionss = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: self).boundingRect(with: size, options: optionss, attributes: [.font: font], context: nil)
            return estimatedFrame
    }
    func decomposeHangul() -> String {
        
        var result = ""
        let CHO = [
            "ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
            "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
        ]
        
        let JUNG = [
            "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ","ㅕ", "ㅖ", "ㅗ", "ㅘ",
            "ㅙ", "ㅚ","ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ",
            "ㅣ"
        ]
        
        let JUNG_DOUBLE = [
            "ㅘ":"ㅗㅏ", "ㅙ":"ㅗㅐ", "ㅚ":"ㅗㅣ", "ㅝ":"ㅜㅓ", "ㅞ":"ㅜㅔ", "ㅟ":"ㅜㅣ", "ㅢ":"ㅡㅣ"
        ]
        let JONG = [
            "","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ",
            "ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ",
            "ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
        ]
        
        let JONG_DOUBLE = [
            "ㄳ":"ㄱㅅ","ㄵ":"ㄴㅈ","ㄶ":"ㄴㅎ","ㄺ":"ㄹㄱ","ㄻ":"ㄹㅁ",
            "ㄼ":"ㄹㅂ","ㄽ":"ㄹㅅ","ㄾ":"ㄹㅌ","ㄿ":"ㄹㅍ","ㅀ":"ㄹㅎ",
            "ㅄ":"ㅂㅅ"
        ]
        for char in self.unicodeScalars {
            let original = char.value;
            if original >= 0xAC00 && original <= 0xD7A3  {
                let index = original - 0xAC00
                let cho = CHO[Int(index/588)]
                var jung = JUNG[Int((index%588)/28)]
                var jong = JONG[Int(index%28)]
                if let jung2 = JUNG_DOUBLE[jung] {
                    jung = jung2
                }
                if let jong2 = JONG_DOUBLE[jong] {
                    jong = jong2
                }
                result += cho + jung + jong
            
            } else {
                var temp = String(UnicodeScalar(original)!)
                if let temp2 = JUNG_DOUBLE[temp] {
                    temp = temp2
                }
                result += temp
            }
        }
        return result;
    
        
        
    }
}
