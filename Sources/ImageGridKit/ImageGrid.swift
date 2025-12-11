//
//  ImageGrid.swift
//

import UIKit
import SwiftUI

// MARK: - Public Image Model
public struct ImageModel: Identifiable, Hashable {
    public let id = UUID()
    public let imageName: String

    public init(imageName: String) {
        self.imageName = imageName
    }
}

// MARK: - SwiftUI Wrapper
public struct CompositionalCollectionView: UIViewControllerRepresentable {

    public let images: [ImageModel]

    public init(images: [ImageModel]) {
        self.images = images
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        let layout = CompositionalLayoutBuilder.createInstagramLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, ImageModel> { cell, _, item in
            let imageView = UIImageView(image: UIImage(named: item.imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.contentView.addSubview(imageView)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ])
        }

        // Diffable datasource
        let dataSource = UICollectionViewDiffableDataSource<Int, ImageModel>(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }

        // Snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(images)
        dataSource.apply(snapshot, animatingDifferences: false)

        let vc = UIViewController()
        vc.view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
        ])

        return vc
    }

    public func updateUIViewController(_ vc: UIViewController, context: Context) {}
}

// MARK: - Layout Builder
public class CompositionalLayoutBuilder {

    public static func createInstagramLayout() -> UICollectionViewLayout {

        let spacing: CGFloat = 2

        return UICollectionViewCompositionalLayout { sectionIndex, environment in

            // 🔥 Pattern repeats every 5 items
            // Odd blocks = BIG RIGHT
            // Even blocks = BIG LEFT

            let isEvenBlock = (sectionIndex % 2 == 1)

            // Small item 1/3 width, 1/6 height
            let smallItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.5)
                )
            )
            smallItem.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

            // 2 small stacked vertically
            let smallColumn = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1.0)
                ),
                subitem: smallItem,
                count: 2
            )

            // 4 small items (2 × 2)
            let fourSmall = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(2/3),
                    heightDimension: .fractionalHeight(1.0)
                ),
                subitem: smallColumn,
                count: 2
            )

            // Big tall item
            let bigItem = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            bigItem.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

            // ROW pattern:
            // even block → big left
            // odd block → big right

            let rowGroup = isEvenBlock ?
            NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1/3)
                ),
                subitems: [bigItem, fourSmall]
            )
            :
            NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1/3)
                ),
                subitems: [fourSmall, bigItem]
            )

            return NSCollectionLayoutSection(group: rowGroup)
        }
    }
}
