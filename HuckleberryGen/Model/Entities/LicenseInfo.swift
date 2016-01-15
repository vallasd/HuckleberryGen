//
//  User.swift
//  HuckleberryGen
//
//  Created by David Vallas on 7/12/15.
//  Copyright © 2015 Phoenix Labs. All rights reserved.
//

import Foundation

struct LicenseInfo {
    let name: String
    let company: String
    let contact1: String
    let contact2: String
    let type: LicenseType
    
    func string(project: String, fileName: String) -> String {
        let companyInfo = company.isEmpty ? name : company
        let contact1Info = contact1.isEmpty ? contact1 : "(\(contact1))"
        let contact2Info = contact2.isEmpty ? contact2 : "(\(contact2))"
        return "//   \(project)\n//   \(fileName) created by HuckleberryGen (on: \(hgGenCurrentDate) for: \(name))\n//\n//   Copyright (c) \(hgGenCurrentYear) \(companyInfo) \(contact1Info) \(contact2Info)\n//\n \(type.staticText)"
    }
    
    var needsMoreInformation: Bool {
        get {
            if name == "" { return true }
            return false
        }
    }
    
}

extension LicenseInfo: HGEncodable {
    
    static var new: LicenseInfo {
        return LicenseInfo(name: "", company: "", contact1: "", contact2: "", type: .AllRightsReserved)
    }
    
    var encode: AnyObject {
        var dict = HGDICT()
        dict["company"] = company
        dict["contact1"] = contact1
        dict["contact2"] = contact2
        dict["name"] = name
        dict["type"] = type.int
        return dict
    }
    
    static func decode(object object: AnyObject) -> LicenseInfo {
        let dict = hgdict(fromObject: object, decoderName: "LicenseInfo")
        let name = dict["name"].string
        let company = dict["company"].string
        let contact1 = dict["contact1"].string
        let contact2 = dict["contact2"].string
        let type = dict["type"].licenseType
        return LicenseInfo(name: name, company: company, contact1: contact1, contact2: contact2, type: type)
    }
}

enum LicenseType: Int16 {
    case MIT = 0
    case AllRightsReserved = 1
    
    static func create(int int: Int) -> LicenseType {
        switch (int) {
        case 0: return .MIT
        case 1: return .AllRightsReserved
        default:
            HGReportHandler.report("int: |\(int)| is not an LicenseType mapable, returning .MIT", response: .Error)
            return .MIT
        }
    }
    
    var int: Int {
        return Int(self.rawValue)
    }
    
    var staticText: String {
        switch(self) {
        case .MIT: return "//   The MIT License (MIT)\n//\n//   Permission is hereby granted, free of charge, to any person obtaining a copy\n//   of this software and associated documentation files (the \"Software\"), to deal\n//   in the Software without restriction, including without limitation the rights\n//   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n//   copies of the Software, and to permit persons to whom the Software is\n//   furnished to do so, subject to the following conditions:\n//\n//   The above copyright notice and this permission notice shall be included in all\n//   copies or substantial portions of the Software.\n//\n//   THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n//   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n//   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n//   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n//   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n//   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n//   SOFTWARE"
        case .AllRightsReserved: return "   All Rights Reserved."
        }
    }
}



