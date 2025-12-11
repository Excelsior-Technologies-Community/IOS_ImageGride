//
//  ImageGrid.swift
//  Complete Instagram-style Grid Implementation
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

// MARK: - Main Compositional View
public struct CompositionalCollectionView: UIViewControllerRepresentable {

    public let images: [ImageModel]

    public init(images: [ImageModel]) {
        self.images = images
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Int, ImageModel>

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func makeUIViewController(context: Context) -> UIViewController {

        let layout = CompositionalLayoutBuilder.createInstagramLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, ImageModel> { cell, indexPath, model in

            let imageView = UIImageView(image: UIImage(named: model.imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .systemGray6

            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.contentView.addSubview(imageView)
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear

            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ])
        }

        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }

        context.coordinator.dataSource = dataSource

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

        collectionView.backgroundColor = .black
        vc.view.backgroundColor = .black

        return vc
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    // MARK: - Coordinator
    public class Coordinator: NSObject {
        var parent: CompositionalCollectionView
        var dataSource: DataSource?

        init(parent: CompositionalCollectionView) {
            self.parent = parent
        }
    }
}

// MARK: - Layout Builder
public class CompositionalLayoutBuilder {

    public static func createInstagramLayout() -> UICollectionViewLayout {

        let spacing: CGFloat = 1.0

        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            // Small item size
            let smallItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            // Create 2x2 grid group (4 small items)
            let smallGridSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1.0)
            )
            let smallGridGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: smallGridSize,
                repeatingSubitem: smallItem,
                count: 2
            )
            
            // Large item (1/3 width)
            let largeItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)
            )
            let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
            largeItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            // ODD ROW: 4 small on LEFT + 1 big on RIGHT
            let oddRowSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            )
            let oddRowGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: oddRowSize,
                subitems: [smallGridGroup, largeItem]
            )
            
            // EVEN ROW: 1 big on LEFT + 4 small on RIGHT
            let evenRowSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            )
            let evenRowGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: evenRowSize,
                subitems: [largeItem, smallGridGroup]
            )
            
            // Combine both rows
            let combinedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)
                ),
                subitems: [oddRowGroup, evenRowGroup]
            )

            let section = NSCollectionLayoutSection(group: combinedGroup)
            return section
        }
    }
}
