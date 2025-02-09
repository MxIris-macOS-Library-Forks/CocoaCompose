import Cocoa

public class PreferenceGroup: NSStackView {
    private var titleLabels: [Label]
    
    var leadAnchor: NSLayoutDimension? { titleLabels.first?.widthAnchor }

    public struct Item {
        public var title: String
        public var views: [NSView]
        
        public init(title: String, views: [NSView] = []) {
            self.title = title
            self.views = views
        }
    }

    public init(footer: String? = nil, items: [Item]) {
        var labels: [Label] = []
        var stackViews: [NSStackView] = []
        
        for item in items {
            let label = Label()
            label.stringValue = item.title
            label.font = .preferredFont(forTextStyle: .body)
            label.textColor = .labelColor
            label.alignment = .right
            
            labels.append(label)

            let rowStack = NSStackView(views: item.views)
            rowStack.distribution = .fill
            rowStack.orientation = .horizontal
            rowStack.alignment = .firstBaseline
            rowStack.spacing = 12
            
            let stackView = NSStackView(views: [label, rowStack])
            stackView.distribution = .fill
            stackView.orientation = .horizontal
            stackView.alignment = .top
            stackView.spacing = 7
            
            stackViews.append(stackView)
            
            if let view = item.views.first {
                switch view {
                case is Button, is Checkbox, is DatePicker, is FontPicker, is PopUp, is TextField, is TimePicker:
                    stackView.alignment = .firstBaseline
                case is NSButton, is NSTextField:
                    stackView.alignment = .firstBaseline
                default:
                    break
                }
            }
        }
        
        self.titleLabels = labels
        
        super.init(frame: .zero)

        self.distribution = .fill
        self.orientation = .vertical
        self.alignment = .leading
        self.spacing = 7
        
        self.wantsLayer = true
        self.layer?.masksToBounds = false

        addArrangedSubviews(stackViews)
        
        if let footer {
            let label = Label()
            label.stringValue = footer
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .secondaryLabelColor
            label.usesSingleLineMode = false

            label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
            label.setContentCompressionResistancePriority(.init(rawValue: 1), for: .horizontal)
            
            addArrangedSubview(label)
        }
        
        alignLeadAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func alignLeadAnchors() {
        let anchors = titleLabels.map { $0.widthAnchor }
        if let first = anchors.first {
            for anchor in anchors where anchor != first {
                anchor.constraint(equalTo: first).isActive = true
            }
        }
    }
}
