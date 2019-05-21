//
//  IBAN_CheckTests.swift
//  IBAN CheckTests
//
//  Created by Torsten Wunderlich on 31.01.17.
//  Copyright © 2017 Torsten Wunderlich. All rights reserved.
//

import XCTest
@testable import IBAN_Check


class IBANChecksTests: XCTestCase {
    
    func testLetter2NumNormalOperation() {
        let parameter = "D"
        let expected = "13" //A=10, B=11, C=12, D=13
        XCTAssertEqual(IBANChecks.letter2Num(parameter),expected)
    }
    
    func testLetter2NumReturnsNilIfLetterNotFound() {
        let parameter = "Ä"
        XCTAssertNil(IBANChecks.letter2Num(parameter))
    }

    func testLetter2NumReturnsNilIfStringNotFound() {
        let parameter = "hello"
        XCTAssertNil(IBANChecks.letter2Num(parameter))
    }

    func testString2NumStringNormalOperation() {
        let parameter = "DE"
        let expected = "1314" //A=10, B=11, C=12, D=13
        XCTAssertEqual(IBANChecks.string2NumString(letters: parameter),expected)
    }

    func testString2NumStringGB() {
        let parameter = "GB"
        let expected = "1611" //A=10, B=11, C=12, D=13
        XCTAssertEqual(IBANChecks.string2NumString(letters: parameter),expected)
    }
    
    func testString2NumStringWithNumbers() {
        let parameter = "DE0129"
        let expected  = "13140129"
        XCTAssertEqual(IBANChecks.string2NumString(letters: parameter), expected)
    }
    
    func testString2NumStringReturnsNilIfLetterNotFound() {
        let parameter = "DÄ"
        XCTAssertNil(IBANChecks.string2NumString(letters: parameter))
    }

    func testSplitIban(){
        let iban = "DE123456789"
        let expectedCountryCode = "DE"
        let expectedCheckSum = "12"
        let expectedBban = "3456789"
        let (countryCode,checkSum,Bban) = IBANChecks.splitIban(iban: iban)
        XCTAssertEqual(countryCode, expectedCountryCode)
        XCTAssertEqual(checkSum, expectedCheckSum)
        XCTAssertEqual(Bban, expectedBban)
    }
    
    func testSplitIbanWhitespaces(){
        let iban = " DE123 4567 89 "
        let expectedCountryCode = "DE"
        let expectedCheckSum = "12"
        let expectedBban = "3456789"
        let (countryCode,checkSum,Bban) = IBANChecks.splitIban(iban: iban)
        XCTAssertEqual(countryCode, expectedCountryCode)
        XCTAssertEqual(checkSum, expectedCheckSum)
        XCTAssertEqual(Bban, expectedBban)
    }
    
    func testSplitIbanShortString() {
        let parameter = "12"
        let expectedCountryCode = ""
        let expectedCheckSum = ""
        let expectedBban = ""
        let (countryCode,checkSum,Bban) = IBANChecks.splitIban(iban: parameter)
        XCTAssertEqual(countryCode, expectedCountryCode)
        XCTAssertEqual(checkSum, expectedCheckSum)
        XCTAssertEqual(Bban, expectedBban)
        
    }
    func testCheckIbanGermany(){
        let iban = "DE89370400440532013000"
        XCTAssertTrue(IBANChecks.check(iban: iban))
    }

    func testCheckIbanWithSpacesGermany(){
        let iban = "DE89 3704 0044 0532 0130 00"
        XCTAssertTrue(IBANChecks.check(iban: iban))
    }

    func testCheckIbanWithSpacesUK(){
        let iban = "GB29 NWBK 6016 1331 9268 19"
        XCTAssertTrue(IBANChecks.check(iban: iban))
    }


    func testCheckIbanWithABunchOfIbans() {
        //taken from http://www.rbs.co.uk/corporate/international/g0/guide-to-international-business/regulatory-information/iban/iban-example.ashx
        let ibans = [
            "Just long enough": "AB451",
            "Albania": "AL47 2121 1009 0000 0002 3569 8741",
            "Austria": "AT61 1904 3002 3457 3201",
            "France" : "FR14 2004 1010 0505 0001 3M02 606",
            "Germany": "DE89 3704 0044 0532 0130 00",
            //"United Kingdom": "GB29 RBOS 6016 1331 9268 19" This is actually a false number
            "United Kingdom": "GB29 NWBK 6016 1331 9268 19",
            "Italy" : "IT40 S054 2811 1010 0000 0123 456",
            "Liechtenstein" : "LI21 0881 0000 2324 013A A",
            "Spain" : "ES80 2310 0001 1800 0001 2345",
            "Switzerland" : "CH93 0076 2011 6238 5295 7"
        ]
        for (country, iban) in ibans {
            XCTAssertTrue(IBANChecks.check(iban: iban), "Did't work for " + country)
        }
    }
    
    func testCheckIbanWithABunchOfFaultyIbans() {
        //taken from http://www.rbs.co.uk/corporate/international/g0/guide-to-international-business/regulatory-information/iban/iban-example.ashx
        let ibans = [
            "Too Short": "AB12",
            "Long Enough but apha checksum": "ABA51",
            "Albania": "AL47 2121 1009 0000 0002 3560 8741",
            "Austria": "AT61 1904 3002 3757 3201",
            "France" : "FR14 2004 1010 A505 0001 3M02 606",
            "Germany": "DE89 3704 0Ä44 0532 0130 00",
            "United Kingdom": "GB29 RBOS 6016 1331 9268 19", //This is actually a false number
            "United Kingdom2": "GB29 NWKK 6016 1331 9268 19",
            "Italy" : "IT40 S054 281A 1010 0000 0123 456",
            "Liechtenstein" : "LI21 0881 0000 2324 0131 A",
            "Spain" : "ES81 2310 0001 1800 0001 2345",
            "Switzerland" : "CH93 0076 2011 6238 529B 7"
        ]
        for (country, iban) in ibans {
            XCTAssertFalse(IBANChecks.check(iban: iban), "Did't work for " + country)
        }
    }

}
