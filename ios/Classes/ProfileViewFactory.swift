import Foundation
import Kingfisher

class ProfileViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return ProfileView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class ProfileView: NSObject, FlutterPlatformView {
    private let parentView = UIView()
    private let nameLabel = CustomLabel()
    private let defaultImage = "https://cdn-images-1.medium.com/max/280/1*X5PBTDQQ2Csztg3a6wofIQ@2x.png"
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        super.init()
        
        FlutterMethodChannel(name: Channel.view, binaryMessenger: messenger!).setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == Method.setName else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            let name = call.arguments as! String
            if name.isEmpty || name.count < 5 {
                result(false)
                return
            }
            self.nameLabel.text = name
            result(true)
        })
        
        var name = "..."
        var role = "..."
        var image = defaultImage
        if let argumentsDictionary = args as? Dictionary<String, Any> {
            name = argumentsDictionary["name"] as! String
            role = argumentsDictionary["role"] as! String
            image = argumentsDictionary["image"] as! String
        }
        createProfileView(name: name, role: role, image: image)
    }
    
    func view() -> UIView {
        return parentView
    }
    
    func createProfileView(name: String, role: String, image: String){
        let screenSize: CGRect = UIScreen.main.bounds
        parentView.frame = CGRect(x: 0, y: 0,width:  screenSize.width,height: 230)
        parentView.bounds = parentView.frame.insetBy(dx: 22, dy: 2)
        
        let card = UIView(frame: CGRect(x: 22, y: 22, width: parentView.frame.width, height: parentView.frame.height))
        card.backgroundColor = .white
        card.layer.cornerRadius = 6
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize(width: 2, height: 2)
        card.layer.shadowOpacity = 0.5
        card.layer.shadowRadius = 2.0
        
        parentView.addSubview(card)
        
        let size = CGSize(width: 100, height: 100)
        let processor = ResizingImageProcessor(referenceSize:size)
            |> RoundCornerImageProcessor(cornerRadius: size.width / 2)
        
        let imageView = UIImageView()
        imageView.kf.setImage(
            with: URL(string: image),
            options: [
                .processor(processor),
            ])
        
        nameLabel.text = name
        nameLabel.textColor = .black
        nameLabel.font = nameLabel.font.withSize(32)
        nameLabel.edgeInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        let roleLabel = CustomLabel()
        roleLabel.edgeInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        roleLabel.text = role
        roleLabel.textColor = .gray
        roleLabel.font = nameLabel.font.withSize(18)
        
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(roleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
    }
}


class CustomLabel: UILabel {
    var edgeInset: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
}
