//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

@testable import StreamChatUI
import XCTest

class ContainerStackView_Tests: XCTestCase {
    var views: [UIView] = []
    
    let axis: [String: NSLayoutConstraint.Axis] = [
        "vertical": .vertical,
        "horizontal": .horizontal
    ]
    
    let alignments: [String: ContainerStackView.Alignment] = [
        "fill": .fill,
        "axisLeading": .leading,
        "axisTrailing": .trailing,
        "center": .center
    ]
    
    let distributions: [String: ContainerStackView.Distribution] = [
        "natural": .natural,
        "equal": .equal
    ]
    
    let spacings: [CGFloat] = [.infinity, 32, 0]
    
    override func setUp() {
        super.setUp()
        
        let texts = ["Long label 1", "Lbl2", "Label 3"]
        let colors: [UIColor] = [.red, .green, .blue]
        
        views = zip(texts, colors).map { text, color in
            let label = UILabel().withoutAutoresizingMaskConstraints
            label.text = text
            label.backgroundColor = color
            return label
        }
    }

    func testAppearance_withOneViewOnly() {
        let views = [self.views.first!]

        let containerH = ContainerStackView(
            axis: .horizontal,
            arrangedSubviews: views
        ).withoutAutoresizingMaskConstraints

        AssertSnapshot(containerH, variants: [.defaultLight], suffix: "horizontal")

        let containerV = ContainerStackView(
            axis: .vertical,
            arrangedSubviews: views
        ).withoutAutoresizingMaskConstraints

        AssertSnapshot(containerV, variants: [.defaultLight], suffix: "vertical")
    }
    
    func testAppearance() {
        let container = ContainerStackView(
            axis: .vertical,
            alignment: .fill,
            arrangedSubviews: views
        ).withoutAutoresizingMaskConstraints
        
        axis.forEach { (axisName, axis) in
            alignments.forEach { (alignmentName, alignment) in
                distributions.forEach { (distributionName, distribution) in
                    spacings.forEach { spacing in
                        container.axis = axis
                        container.alignment = alignment
                        container.distribution = distribution
                        container.spacing = .init(spacing)

                        container.setNeedsLayout()
                        container.layoutIfNeeded()
                        let suffix = "\(axisName)-\(alignmentName)-\(distributionName)-\(spacing)"
                        AssertSnapshot(container, variants: [.defaultLight], suffix: suffix)
                    }
                }
            }
        }
    }
}
