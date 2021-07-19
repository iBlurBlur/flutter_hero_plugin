import Foundation

class ColorStreamHandler:NSObject, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    private let colors = [0xff71C9CE, 0xffA6E3E9, 0xffCBF1F5, 0xffE3FDFD]
    private var index = 0
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        changeColor()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    func changeColor()  {
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(colorEvent), userInfo: nil, repeats: true)
    }
    
    @objc func colorEvent(){
        guard let eventSink = eventSink else {
            return
        }
        
        if index >= colors.count {
            index = 0
        }
        eventSink(colors[index])
        index += 1
    }
}
