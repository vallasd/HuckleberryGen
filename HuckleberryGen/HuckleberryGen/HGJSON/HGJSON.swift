import Foundation

typealias HGDICT = Dictionary<String, Any>
typealias HGARRAY = [HGDICT]

class HG {
    
    static func decode(hgarray: Any, decoderName n: String?) -> HGARRAY {
        let c = hgarray as? HGARRAY
        if n != nil && c == nil {
            HGReport.shared.report("object: |\(hgarray)| is not \(n!) mapable", type: .error)
        }
        return c ?? HGARRAY()
    }
    
    static func decode(hgdict: Any, decoderName n: String?) -> HGDICT {
        let c = hgdict as? HGDICT
        if n != nil && c == nil {
            HGReport.shared.report("object: |\(hgdict)| is not \(n!) mapable", type: .error)
        }
        return c ?? HGDICT()
    }
    
    static func decode(int: Any, decoderName n: String?) -> Int {
        let c = int as? Int
        if n != nil && c == nil {
            HGReport.shared.report("object: |\(int)| is not \(n!) mapable", type: .error)
        }
        return c ?? 0
    }
    
    static func decode<T>(int8: Any, decoder: T) -> Int8 {
        if let i = int8 as? Int, i < 255 { return Int8(i) }
        if let c = int8 as? Int8 { return c }
        HGReport.shared.report("object: |\(int8)| is not |\(decoder)| mapable, returning 0", type: .error)
        return 0
    }
    
    static func decode(string: Any, decoderName n: String?) -> String {
        let c = string as? String
        if n != nil && c == nil {
            HGReport.shared.report("object: |\(string)| is not \(n!) mapable", type: .error)
        }
        return c ?? ""
    }
}
