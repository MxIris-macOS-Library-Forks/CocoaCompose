import Cocoa

public class Radio: ConstrainingStackView {
    private let items: [Item]
    private var buttons: [NSButton] = []
    
    private var currentIndex: Int = -1

    public var onChange: ((Int, Int) -> Void)?

    public struct Item {
        public var title: String?
        public var attributedTitle: NSAttributedString?
        public var footer: String?
        public var orientation: NSUserInterfaceLayoutOrientation
        public var views: [NSView]
        
        public init(title: String? = nil, attributedTitle: NSAttributedString? = nil, footer: String? = nil, orientation: NSUserInterfaceLayoutOrientation = .horizontal, views: [NSView] = []) {
            self.title = title
            self.attributedTitle = attributedTitle
            self.footer = footer
            self.orientation = orientation
            self.views = views
        }
    }

    public init(items: [Item] = [], selectedIndex: Int = -1, spacing: CGFloat = 7, onChange: ((Int, Int) -> Void)? = nil) {
        self.items = items
        self.currentIndex = selectedIndex
        self.onChange = onChange

        super.init(orientation: .vertical, alignment: .width, views: [])

        self.distribution = .fill
        self.spacing = spacing
        
        for index in 0 ..< items.count {
            let item = items[index]
            
            let itemStack = ConstrainingStackView(orientation: .vertical, alignment: .width, views: [])
            itemStack.distribution = .fill
            itemStack.spacing = 7

            let button = NSButton()
            button.font = .preferredFont(forTextStyle: .body)
            button.setButtonType(.radio)
            button.target = self
            button.action = #selector(buttonAction)
            button.tag = index

            if let title = item.attributedTitle {
                button.attributedTitle = title
            } else {
                button.title = item.title ?? ""
            }

            buttons.append(button)
            
            if item.views.isEmpty {
                let buttonRow = NSStackView(views: [button, NSView()])
                buttonRow.orientation = .horizontal
                buttonRow.spacing = 0
                
                itemStack.addArrangedSubview(buttonRow)

            } else {
                let stackView = NSStackView()
                stackView.distribution = .fill
                stackView.orientation = item.orientation
                stackView.alignment = item.orientation == .vertical ? .leading : .firstBaseline
                stackView.spacing = item.orientation == .vertical ? 7 : 10

                if item.orientation == .vertical {
                    let buttonRow = NSStackView(views: [button, NSView()])
                    buttonRow.orientation = .horizontal
                    buttonRow.spacing = 0

                    stackView.addArrangedSubview(buttonRow)
                    
                } else {
                    stackView.addArrangedSubview(button)
                }
                
                stackView.addArrangedSubviews(item.views)

                itemStack.addArrangedSubview(stackView)
            }

            if let footer = item.footer {
                let footerLabel = Label()
                footerLabel.stringValue = footer
                footerLabel.font = .preferredFont(forTextStyle: .subheadline)
                footerLabel.textColor = .secondaryLabelColor
                footerLabel.usesSingleLineMode = false

                footerLabel.setContentCompressionResistancePriority(.init(rawValue: 1), for: .horizontal)
                
                itemStack.addArrangedSubview(footerLabel)
            }
            
            addArrangedSubview(itemStack)
        }
        
        update(selectedIndex: selectedIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var isEnabled: Bool = true {
        didSet {
            for index in 0 ..< items.count {
                buttons[index].isEnabled = isEnabled
                items[index].views.forEach { $0.setSubviewControlsEnabled(isEnabled) }
            }
            
            if isEnabled {
                update(selectedIndex: currentIndex)
            }
        }
    }
    
    public var selectedIndex: Int {
        get {
            currentIndex
        }
        set {
            let previousIndex = selectedIndex
            update(selectedIndex: newValue)
            onChange?(newValue, previousIndex)
        }
    }
    
    private func update(selectedIndex: Int) {
        currentIndex = selectedIndex
        
        for index in 0 ..< items.count {
            buttons[index].state = selectedIndex == index ? .on : .off
            items[index].views.forEach { $0.setSubviewControlsEnabled(selectedIndex == index) }
        }
    }
    
    // MARK: - Actions
    
    @objc func buttonAction(_ sender: NSButton) {
        let previousIndex = selectedIndex
        update(selectedIndex: sender.tag)
        
        onChange?(selectedIndex, previousIndex)
    }
}
