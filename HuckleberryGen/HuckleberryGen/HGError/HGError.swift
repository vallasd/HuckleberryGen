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
        HGReport.shared.report("|\(type)| |DECODING FAILED| not  mapable object: |\(object)|", type: .error)
    }
    
    func setDecode<T>(_ object: Any, type: T) {
        HGReport.shared.report("|\(type)| |DECODING FAILED| not inserted object: |\(object)|", type: .error)
    }
    
    func notMatch(_ object: Any, object2: Any) {
        HGReport.shared.report("|\(object)| is does not match |\(object2)|", type: .error)
    }
    
    func insertFailed<T>(set: T, object: Any) {
        HGReport.shared.report("|\(set)| |INSERT FAILED| object: \(object)", type: .error)
    }
    
    func deleteFailed<T>(set: T, object: Any) {
        HGReport.shared.report("|\(set)| |DELETE FAILED| object: \(object)", type: .error)
    }
    
    func getFailed<T>(set: T, keys: [Any], values: [Any]) {
        HGReport.shared.report("|\(set)| |GET FAILED| for keys: |\(keys)| values: |\(values)|", type: .error)
    }
    
    func updateFailed<T>(set: T, key: Any, value: Any) {
        HGReport.shared.report("|\(set)| |UPDATE FAILED| for key: |\(key)| not valid value: |\(value)|", type: .error)
    }
    
    func updateFailedKeyMismatch<T>(set: T) {
        HGReport.shared.report("|\(set)| |UPDATE FAILED| key.count != values.count", type: .error)
    }
    
    func updateFailedGeneric<T>(set: T) {
        HGReport.shared.report("|\(set)| |UPDATE FAILED| nil object returned, possible stale objects", type: .error)
    }
    
    func usedName<T>(name: String, type: T) {
        HGReport.shared.report("|\(type)| |USED NAME| name: |\(name)| already used", type: .error)
    }
    
    func validateFailed<T,U>(decoder: T, value: Any, key: Any, expectedType: U) {
        HGReport.shared.report("|\(decoder)| |VALIDATION FAILED| for key: |\(key)| value: |\(value)| expected type: |\(expectedType)|", type: .error)
    }
}


