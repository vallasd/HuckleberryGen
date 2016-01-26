// TODO: UPDATE FOR UIKIT
// import UIKit

enum HGErrorResponse: String {
    case Info = "[INFO]"
    case Warn = "[WARNING]"
    case Error = "[ERROR]"
    case Alert = "[ALERT]"
    case Assert = "[ASSERT]"
}

enum HGInfo: String {
    case InitJSON = "Initializing JSON"
    case CreateJEEFJ = "Creating JSONEncodable Entity From JSON"
    case ParseFJE = "Parsing JSON For JSONEncodable"
    
    func response() -> HGErrorResponse { return HGErrorResponse.Info }
}

enum HGError: String {
    case Int16 = "Type Not Int16"
    case Int32 = "Type Not Int32"
    case Int = "Type Not Int"
    case Float = "TypeNotFloat"
    case String = "Type Not String"
    case Double = "Type Not Double"
    case ONJ = "Object Not JSON"
    case ONJA = "Object Not JSON Array"
    case ONJD = "Object Not JSON Dict"
    case Parse = "JSON ?? Parse Error"
    
    func response() -> HGErrorResponse { return HGErrorResponse.Error }
}

enum HGThrownError: ErrorType {
    case JSONNotSingle
    case JSONNotArray
    case JSONNotParsed
    case ObjectNotJSON
    case ObjectNotCreated
}

struct HGReport {
    
    let entity: String
    
    // GENERIC MESSAGES
    
    // GETS RID OF OPTIONAL TAG IN DATA
    private func info(details: AnyObject?) -> AnyObject {
        if details != nil { return details as AnyObject! }
        return "none"
    }
    
    private func err(details: AnyObject?, key: String,  error: HGError) {
        let errorString = "\(error.response().rawValue)error: |\(error.rawValue)| for entity: |\(entity)| key: |\(key)| - details: \(self.info(details))"
        HGReportHandler.report(errorString, response: error.response())
    }
    
    private func info(info: HGInfo) {
        let infoString = "\(info.response().rawValue)action: |\(info.rawValue)| for entity: |\(entity)|"
        HGReportHandler.report(infoString, response: info.response())
    }
    
    // ERRORS
    
    func stringErr(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.String) }
    func intErr(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.Int) }
    func int16Err(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.Int16) }
    func int32Err(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.Int32) }
    func floatErr(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.Float) }
    func doubleErr(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.Double) }
    func onjErr(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.ONJ) }
    func onjaErr(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.ONJA) }
    func onjdErr(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.ONJD) }
    func parseErr(details: AnyObject?, key: String) { self.err(details, key: key, error: HGError.Parse) }
    
    // INFO
    func initJsonInfo() { self.info(HGInfo.InitJSON) }
    func createSONEncodableEntityFromJSONInfo() { self.info(HGInfo.CreateJEEFJ) }
    func parseJSONForJSONEncodableInfo() { self.info(HGInfo.ParseFJE) }
}

// STATIC SETTING, CHANGE THESE

let hgReportHandlerInfo = true
let hgReportHandlerWarn = true
let hgReportHandlerError = true
let hgReportHandlerAlert = true
let hgReportHandlerAssert = true


struct HGReportHandler {
    
    static let shared = HGReportHandler()
    static var reportedError = false
    // var alertDelegate: UIViewController? = nil
    
    static func report(string: String, response: HGErrorResponse) {
        switch (response) {
        case .Info:    if( hgReportHandlerInfo == true) { print("\(string)") }
        case .Warn:    if( hgReportHandlerWarn == true) { print("\(string)") }
        case .Error:   if( hgReportHandlerError == true) { print("\(string)") }
        case .Alert:   if( hgReportHandlerAlert == true) { print("\(string)") }
        case .Assert:  if( hgReportHandlerAssert == true) { assert(true, string) }
        }
    }
    
    /*
    private static func alert(message: String) {
        if let vc = HGReportHandler.shared.alertDelegate {
            let alert = UIAlertController(title: "SwiftGen Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            vc.presentViewController(alert, animated: true, completion: nil)
        } else {
            print("[WARNING] No Delegate For Alert Message - \(message)");
        }
    }
    */
}


