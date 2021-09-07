//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import LayoutExtension

private var heights: [CGFloat] = [
    20, 70, 136, 120, 90, 200, 86, 75, 300, 122, 56, 88,
    20, 70, 136, 120, 90, 200, 86, 75, 300, 122, 56, 88
]

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).autoLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView) {
            $0.fill()
        }

        collectionView.register(CustomCell.classForCoder(), forCellWithReuseIdentifier: "CustomCell")
    }

    func update(cell: CustomCell, indexPath: IndexPath) {
        cell.height = heights[indexPath.row]
        cell.backgroundColor = UIColor.random()
    }

    // MARK: - Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heights.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        self.update(cell: cell, indexPath: indexPath)
        return cell
    }

    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.size.height,
            height: heights[indexPath.row])
    }
}

class CustomCell: UICollectionViewCell {
    var height: CGFloat?

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let indexPath = layoutAttributes.indexPath
        layoutAttributes.frame = CGRect(
            origin: layoutAttributes.frame.origin,
            size: CGSize(width: 390, height: heights[indexPath.item])
        )
        return layoutAttributes
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ViewController()

//: [Next](@next)
