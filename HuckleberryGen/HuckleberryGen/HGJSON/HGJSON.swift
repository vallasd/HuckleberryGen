import Foundation

typealias HGDICT = Dictionary<String, AnyObject>
typealias HGARRAY = [HGDICT]


/// Returns a HGDICT from the object.  If object is not a HGDICT, returns an empty HGDICT.  Will report Error Message if decoderName is not nil and the object is nil or not an HGDICT
func hgdict(fromObject object: AnyObject, decoderName: String?) -> HGDICT {
    let check = object as? HGDICT
    if decoderName != nil && check == nil { HGReportHandler.shared.report("object: |\(object)| is not \(decoderName!) mapable", type: .Error) }
    let dict: HGDICT = check ?? HGDICT()
    return dict
}




infix operator ??? { associativity left precedence 150 }
infix operator <<< { associativity right precedence 100 assignment }

func <<< (var lhs: AnyObject?, rhs: String) {
    if lhs is String { lhs = rhs; return }
    lhs = nil
}