//
//  IBANChecks.swift
//  IBAN Check
//
//  Created by Torsten Wunderlich on 31.01.17.
//  Copyright © 2017 Torsten Wunderlich. All rights reserved.
//

import Foundation
import BigInt

class IBANChecks {
    
    /// checkIban: Checks if the given string is a valid IBAN
    /// - Parameter iban: String representing the IBAN
    /// - Returns: true, when IBAN is valid, false otherwise
    class func check(iban: String) -> Bool {
        let (countryCode,checkSum,Bban) = IBANChecks.splitIban(iban: iban)
        var strUnderCheck = ""
        guard let countryCodeAsNum = IBANChecks.string2NumString(letters: countryCode) else { return false }
        guard Int(checkSum) != nil else { return false } //check sum has to be numerical
        guard let BbanAsNum = IBANChecks.string2NumString(letters: Bban) else {  return false }
        
        strUnderCheck = BbanAsNum
        strUnderCheck += countryCodeAsNum
        strUnderCheck += checkSum
        
        //following fails... why?
        //THE FUCKING NUMBER IS SIMPLY TO BIG FOR 64BITS. THATS WHY!!!
        //Found BInt, (https://github.com/mkrd/Swift-Big-Integer) all good.
        //return UInt64(strUnderCheck)! % 97 == 1
        
        return BigInt(strUnderCheck)! % 97 == 1
    }
    
    /// splitIban: Splits an IBAN into its Parts
    /// - Parameter iban: String representing the IBAN
    /// - Returns: (countryCode, checkSum, bban: String)
    class func splitIban(iban: String) -> (countryCode: String, checkSum: String, bban: String) {
        let trimmedIban = iban.components(separatedBy: .whitespaces).joined()
        if trimmedIban.count < 5 {
            //if the string is to short, we can't extract anything meaningfull.
            //as a result the ibanCheck will fail.
            return ("","","")
        }
        
        let countryCodeEnd = trimmedIban.index(trimmedIban.startIndex, offsetBy:2)
        let checkSumEnd = trimmedIban.index(countryCodeEnd, offsetBy: 2)
        
        let countryCode = String(trimmedIban[..<countryCodeEnd])
        let checkSum    = String(trimmedIban[countryCodeEnd..<checkSumEnd])
        let bban        = String(trimmedIban[checkSumEnd...])
        return (countryCode, checkSum, bban)
    }
    
    /// letter2Num: Converts a letter to a number representation of said letter
    /// - Parameter letter: String
    /// - Returns: Position of letter in alphabet as String
    class func letter2Num(_ letter: String) -> String? {
        let letters = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        if let position = letters.firstIndex(of: letter) {
            return String(position)
        } else {
            return nil //letter not in alphabet? Bad :-)
        }
    }
    
    /// string2NumString: Converts all letters of the Sring into their numerical representation
    /// - Parameter letters: a String
    /// - Returns: A String of numbers
    class func string2NumString(letters: String) -> String? {
        var result: String = String()
        for c in letters {
            if let num4letter = letter2Num(String(c)) {
                result.append(num4letter)
            } else {
                return nil //can't resolve the letter? Bail out!
            }
        }
        return result //we are here so everything is ok
    }
}
