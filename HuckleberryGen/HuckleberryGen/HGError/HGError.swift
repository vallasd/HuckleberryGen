// TODO: UPDATE FOR UIKIT
// import UIKit


// STATIC SETTING, CHANGE THESE

struct HGReport {
    
    static let shared = HGReport()
    
    let hgReportHandlerInfo = true
    let hgReportHandlerWarn = true
    let hgReportHandlerError = true
    let hgReportHandlerAlert = true
    let hgReportHandlerAssert = true
    
    func report(_ msg: String, type: HGErrorType) {
        switch (type) {
        case .info:    if hgReportHandlerInfo == false { return }
        case .warn:    if hgReportHandlerInfo == false { return }
        case .error:   if hgReportHandlerInfo == false { return }
        case .alert:   if hgReportHandlerInfo == false { return }
        case .assert:  if hgReportHandlerInfo == false { return }
        }
        let report = "[\(type.string)] " + msg
        print(report)
    }
    
    func decode<T>(_ object: Any, type: T) {
        HGReport.shared.report("Decoding: |\(object)| is not |\(type)| mapable, using error", type: .error)
    }
    
    func setDecode<T>(_ object: Any, type: T) {
        HGReport.shared.report("Decoding: |\(object)| not inserted in set |\(type)|", type: .error)
    }
    
    func notMatch(_ object: Any, object2: Any) {
        HGReport.shared.report("Type: |\(object)| is does not match |\(object2)|", type: .error)
    }
    
    func insertFailed<T>(type: T, object: Any) {
        HGReport.shared.report("Type: |\(type)| failed INSERT object: \(object)", type: .error)
    }
    
    func deleteFailed<T>(type: T, object: Any) {
        HGReport.shared.report("Type: |\(type)| failed DELETE object: \(object)", type: .error)
    }
    
    func getFailed<T>(type: T, keys: [Any], values: [Any]) {
        HGReport.shared.report("|\(type)| failed GET for keys: |\(keys)| values: |\(values)|", type: .error)
    }
    
    func updateFailed<T>(type: T, key: Any, value: Any) {
        HGReport.shared.report("|\(type)| failed UPDATE for key: |\(key)| not valid value: |\(value)|", type: .error)
    }
    
    func updateFailedKeyMismatch<T>(type: T) {
        HGReport.shared.report("Type: |\(type)| failed UPDATE - key.count != values.count", type: .error)
    }
    
    func updateFailedGeneric<T>(type: T) {
        HGReport.shared.report("Type: |\(type)| failed UPDATE - set returned nil object", type: .error)
    }
    
    func validateFailed<T,U>(decoder: T, value: Any, key: Any, expectedType: U) {
        HGReport.shared.report("|\(decoder)| failed VALIDATION for key: |\(key)| value: |\(value)| expected type: |\(expectedType)|", type: .error)
    }
}


