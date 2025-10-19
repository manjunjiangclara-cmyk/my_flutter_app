import Flutter
import UIKit
import SwiftUI

// Liquid Glass View Controller
class LiquidGlassViewController: UIViewController {
    private var blurEffectView: UIVisualEffectView!
    private var containerView: UIView!
    private var buttonsStackView: UIStackView!
    private var buttons: [UIButton] = []
    private var onButtonTap: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLiquidGlassEffect()
        setupButtons()
    }
    
    private func setupLiquidGlassEffect() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 240),
            containerView.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = 26
        blurEffectView.layer.masksToBounds = true
        
        blurEffectView.layer.borderWidth = 1.0
        blurEffectView.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        
        blurEffectView.layer.shadowColor = UIColor.black.cgColor
        blurEffectView.layer.shadowOffset = CGSize(width: 0, height: 2)
        blurEffectView.layer.shadowRadius = 8
        blurEffectView.layer.shadowOpacity = 0.1
        
        containerView.addSubview(blurEffectView)
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupButtons() {
        buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 8
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        blurEffectView.contentView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor, constant: 8),
            buttonsStackView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: -16),
            buttonsStackView.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor, constant: -8)
        ])
        
        let icons = ["book.fill", "pencil", "gearshape.fill"]
        for (index, iconName) in icons.enumerated() {
            let button = createButton(iconName: iconName, index: index)
            buttons.append(button)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(iconName: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        button.setImage(icon, for: .normal)
        
        button.tintColor = UIColor.label.withAlphaComponent(0.7)
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        button.tag = index
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        onButtonTap?(index)
        updateSelectedButton(index: index)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func updateSelectedButton(index: Int) {
        for (i, button) in buttons.enumerated() {
            if i == index {
                button.tintColor = UIColor.label
                button.backgroundColor = UIColor.white.withAlphaComponent(0.15)
                button.layer.cornerRadius = 18
                button.layer.masksToBounds = true
                button.layer.borderWidth = 0.5
                button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            } else {
                button.tintColor = UIColor.label.withAlphaComponent(0.7)
                button.backgroundColor = UIColor.clear
                button.layer.cornerRadius = 0
                button.layer.borderWidth = 0
            }
        }
    }
    
    func setButtonTapCallback(_ callback: @escaping (Int) -> Void) {
        onButtonTap = callback
    }
    
    func setSelectedIndex(_ index: Int) {
        updateSelectedButton(index: index)
    }
}

// Platform View Factory
class LiquidGlassViewFactory: NSObject, FlutterPlatformViewFactory {
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
        return LiquidGlassView(
            frame: frame,
            viewId: viewId,
            messenger: messenger
        )
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec()
    }
}

// Platform View
class LiquidGlassView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var liquidGlassVC: LiquidGlassViewController
    private var channel: FlutterMethodChannel
    
    init(
        frame: CGRect,
        viewId: Int64,
        messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        liquidGlassVC = LiquidGlassViewController()
        channel = FlutterMethodChannel(
            name: "liquid_glass_\(viewId)",
            binaryMessenger: messenger
        )
        
        super.init()
        
        setupView()
        setupMethodChannel()
    }
    
    func view() -> UIView {
        return _view
    }
    
    private func setupView() {
        _view.backgroundColor = UIColor.clear
        
        liquidGlassVC.view.translatesAutoresizingMaskIntoConstraints = false
        _view.addSubview(liquidGlassVC.view)
        
        NSLayoutConstraint.activate([
            liquidGlassVC.view.topAnchor.constraint(equalTo: _view.topAnchor),
            liquidGlassVC.view.leadingAnchor.constraint(equalTo: _view.leadingAnchor),
            liquidGlassVC.view.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
            liquidGlassVC.view.bottomAnchor.constraint(equalTo: _view.bottomAnchor)
        ])
        
        liquidGlassVC.setButtonTapCallback { [weak self] index in
            self?.channel.invokeMethod("onButtonTap", arguments: index)
        }
    }
    
    private func setupMethodChannel() {
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "setSelectedIndex":
                if let index = call.arguments as? Int {
                    self?.liquidGlassVC.setSelectedIndex(index)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected integer", details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // 注册液态玻璃 PlatformView
    let liquidGlassFactory = LiquidGlassViewFactory(messenger: controller.binaryMessenger)
    registrar(forPlugin: "LiquidGlassPlugin")?.register(
        liquidGlassFactory,
        withId: "liquid_glass_view"
    )
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
