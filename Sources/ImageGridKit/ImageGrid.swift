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

            let spacing: CGFloat = 1.0

            return UICollectionViewCompositionalLayout { sectionIndex, environment in
                
                // Small item - each takes 1/2 width and 1/2 height of the small grid container
                let smallItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(0.5)
                )
                let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
                smallItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
                
                // 2x2 grid of small items (2/3 width, full height)
                let smallGridGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(2/3),
                        heightDimension: .fractionalHeight(1.0)
                    ),
                    subitem: smallItem,
                    count: 2
                )
                
                // Large item (1/3 width, full height)
                let largeItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1.0)
                )
                let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
                largeItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
                
                // ODD BLOCK: 2x2 grid on LEFT, Big on RIGHT
                let oddBlockGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(0.5)
                    ),
                    subitems: [smallGridGroup, largeItem]
                )
                
                // EVEN BLOCK: Big on LEFT, 2x2 grid on RIGHT
                let evenBlockGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(0.5)
                    ),
                    subitems: [largeItem, smallGridGroup]
                )
                
                // Combine both blocks in a vertical group (10 items total - alternating pattern)
                let combinedGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(1.0)
                    ),
                    subitems: [oddBlockGroup, evenBlockGroup]
                )

                return NSCollectionLayoutSection(group: combinedGroup)
            }
        }
}
