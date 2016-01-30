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
    
    func report(msg: String, type: HGErrorType) {

        switch (type) {
        case .Info:    if hgReportHandlerInfo == false { return }
        case .Warn:    if hgReportHandlerInfo == false { return }
        case .Error:   if hgReportHandlerInfo == false { return }
        case .Alert:   if hgReportHandlerInfo == false { return }
        case .Assert:  if hgReportHandlerInfo == false { return }
        }
        
        let report = "[\(type.string)]" + msg
        print(report)
    }
}


