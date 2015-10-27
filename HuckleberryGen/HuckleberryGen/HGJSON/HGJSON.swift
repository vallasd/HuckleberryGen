import Foundation

typealias HGDICT = Dictionary<String, AnyObject>
typealias HGARRAY = [HGDICT]


/// Returns a HGDICT from the object.  If object is not a HGDICT, returns an empty HGDICT.  Will report Error Message if decoderName is not nil and the object is nil or not an HGDICT
func hgdict(fromObject object: AnyObject, decoderName: String?) -> HGDICT {
    let check = object as? HGDICT
    if decoderName != nil && check == nil { HGReportHandler.report("object: |\(object)| is not \(decoderName!) mapable", response: .Error) }
    let dict: HGDICT = check ?? HGDICT()
    return dict
}



infix operator ??? { associativity left precedence 150 }
infix operator <<< { associativity right precedence 100 assignment }

func <<< (var lhs: AnyObject?, rhs: String) {
    if lhs is String { lhs = rhs; return }
    lhs = nil
}

//struct JSON {
//    
//    // CREATE JSON
//    
//    let value: HGARRAY
//    
//    init(json: HGARRAY) { value = json }
//    
//    // MARK: PARSE JSON
//    
//    func parse<T: HGJSONEncodable>() -> [T]? {
//        
//        T.report.parseJSONForJSONEncodableInfo()
//        
//        var encodableArray: [T] = []
//        for json in self.value { if let person = T.parse(json: json) { encodableArray.append(person) } }
//        
//        if encodableArray.count > 0 { return encodableArray }
//        return nil
//    }
//    
//    func parse<T: HGJSONEncodable>() throws -> T {
//        
//        T.report.parseJSONForJSONEncodableInfo()
//        
//        if value.count > 1 {
//            T.report.onjdErr(nil, key: "no key - original json")
//            throw HGThrownError.JSONNotSingle
//        }
//        
//        let json = value.first
//        if let encodable = T.parse(json: json!) { return encodable }
//        throw HGThrownError.JSONNotParsed
//    }
//    
//    func parse<T: HGJSONEncodable>() throws -> [T] {
//        
//        T.report.parseJSONForJSONEncodableInfo()
//        
//        var encodableArray: [T] = []
//        for json in self.value { if let person = T.parse(json: json) { encodableArray.append(person) } }
//        
//        if encodableArray.count > 0 { return encodableArray }
//        throw HGThrownError.JSONNotParsed
//    }
//    
//    // MARK: CREATE RANDOM JSON OBJECTS
//    
//    static func randPerson(withpies withpies: UInt32) -> HGDICT {
//        
//        var personDict = HGDICT()
//        var person_piesArray = [HGDICT]()
//        
//        personDict["age"] = HGGen.randomAge()
//        personDict["name"] = HGGen.randomName()
//        for _ in 0...withpies { person_piesArray.append(randPie(withPerson: false)) }
//        
//        if withpies > 0 { personDict["pies"] = person_piesArray }
//        
//        return personDict
//    }
//    
//    static func randPie(withPerson withPerson: Bool) -> HGDICT {
//        
//        var pieDict = HGDICT()
//        
//        pieDict["name"] = HGGen.randomPie()
//        if (withPerson == true) { pieDict["person"] = randPerson(withpies: 0) }
//        
//        return pieDict
//    }
//    
//    static func randPersons(count count: UInt32, maxPies: UInt32) -> HGARRAY {
//        var array: HGARRAY = []
//        if count == 0 { return array }
//        for _ in 1...count { array.append(randPerson(withpies: arc4random_uniform(maxPies))) }
//        return array
//    }
//    
//    static func randPersons(count count: UInt32, pies: UInt32) -> HGARRAY {
//        var array: HGARRAY = []
//        if count == 0 { return array }
//        for _ in 1...count { array.append(randPerson(withpies: pies)) }
//        return array
//    }
//    
//    static func randPies(count count: UInt32, withPerson: Bool) -> HGARRAY {
//        var array: HGARRAY = []
//        if count == 0 { return array }
//        for _ in 1...count { array.append(randPie(withPerson: withPerson)) }
//        return array
//    }
//    
//}

