import Cocoa

public class Box: NSView {
    private let contentView = NSView()

    public init(title: String? = nil, orientation: NSUserInterfaceLayoutOrientation = .vertical, views: [NSView]) {
        super.init(frame: .zero)
        
        contentView.wantsLayer = true
        
        contentView.layer?.borderWidth = 1
        contentView.layer?.borderColor = NSColor.lightGray.withAlphaComponent(0.15).cgColor
        contentView.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.05).cgColor
        contentView.layer?.cornerRadius = 5

        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        
        if let title {
            let label = Label()
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .secondaryLabelColor
            label.stringValue = title
            
            let spacer = NSView()
            spacer.widthAnchor.constraint(equalToConstant: 5).isActive = true
            
            let titleStack = NSStackView(views: [spacer, label])
            titleStack.orientation = .horizontal
            titleStack.spacing = 0

            stackView.addArrangedSubview(titleStack)
        }

        stackView.addArrangedSubview(contentView)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        let itemStack = NSStackView(views: views)
        itemStack.distribution = .fill
        itemStack.orientation = orientation
        itemStack.alignment = orientation == .vertical ? .leading : .top
        itemStack.spacing = orientation == .vertical ? 7 : 7
        
        contentView.addSubview(itemStack)
        itemStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            itemStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            itemStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            itemStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layout() {
        super.layout()
        
        contentView.layer?.borderColor = NSColor.lightGray.withAlphaComponent(0.15).cgColor
        contentView.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.05).cgColor
    }
}
