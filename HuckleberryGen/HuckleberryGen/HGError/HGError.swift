// TODO: UPDATE FOR UIKIT
// import UIKit


// STATIC SETTING, CHANGE THESE

struct HGReportHandler {
    
    static let shared = HGReportHandler()
    
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
}


