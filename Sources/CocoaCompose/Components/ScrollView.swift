import Cocoa

public class ScrollView: NSScrollView {
    private let itemStack = NSStackView()

    public init(orientation: NSUserInterfaceLayoutOrientation = .vertical, views: [NSView]) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        drawsBackground = false

        hasHorizontalScroller = false
        hasVerticalScroller = true
        
        let clipView = FlippedClipView()
        clipView.drawsBackground = false
        
        contentView = clipView
        clipView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            clipView.topAnchor.constraint(equalTo: topAnchor),
            clipView.leadingAnchor.constraint(equalTo: leadingAnchor),
            clipView.trailingAnchor.constraint(equalTo: trailingAnchor),
            clipView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        views.forEach { itemStack.addArrangedSubview($0) }
        itemStack.distribution = .fill
        itemStack.orientation = orientation
        itemStack.alignment = orientation == .vertical ? .leading : .top
        itemStack.spacing = orientation == .vertical ? 7 : 10
        
        documentView = itemStack
        
        itemStack.translatesAutoresizingMaskIntoConstraints = false
        clipView.addConstraints([
            itemStack.topAnchor.constraint(equalTo: clipView.topAnchor),
            itemStack.leadingAnchor.constraint(equalTo: clipView.leadingAnchor),
            itemStack.trailingAnchor.constraint(equalTo: clipView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var views: [NSView] {
        get {
            itemStack.arrangedSubviews
        }
        set {
            itemStack.removeAllArrangedSubviews()
            itemStack.addArrangedSubviews(newValue)
        }
    }
}
