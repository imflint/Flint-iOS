//import UIKit
//
//import SnapKit
//import Then
//
//final class MoreNoMoreCollectionTableExampleViewController: BaseViewController {
//
//    // MARK: - UI
//
//    private let tableView = UITableView(frame: .zero, style: .plain).then {
//        $0.backgroundColor = .clear
//        $0.separatorStyle = .none
//        $0.showsVerticalScrollIndicator = false
//    }
//
//    // MARK: - Data
//
//    private var items: [MoreNoMoreCollectionItem] = []
//
//    // MARK: - LifeCycle
//
//    override func setUI() {
//        view.backgroundColor = .flintBackground
//
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        tableView.register(
//            MoreNoMoreCollectionTableViewCell.self,
//            forCellReuseIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier
//        )
//
//        items = makeDummyItems()
//    }
//
//    override func setHierarchy() {
//        view.addSubview(tableView)
//    }
//
//    override func setLayout() {
//        tableView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//}
//
//// MARK: - UITableViewDataSource
//
//extension MoreNoMoreCollectionTableExampleViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
//    }
//
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath
//    ) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: MoreNoMoreCollectionTableViewCell.reuseIdentifier,
//            for: indexPath
//        ) as? MoreNoMoreCollectionTableViewCell else {
//            return UITableViewCell()
//        }
//
//        cell.configure(items: items)
//
//        cell.onSelectItem = { item in
//            print("didSelect:", item.id)
//        }
//
//        return cell
//    }
//}
//
//// MARK: - UITableViewDelegate
//
//extension MoreNoMoreCollectionTableExampleViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        180
//    }
//}
//
//// MARK: - Dummy
//
//private extension MoreNoMoreCollectionTableExampleViewController {
//
//    func makeDummyItems() -> [MoreNoMoreCollectionItem] {
//        return (0..<10).map { idx in
//            MoreNoMoreCollectionItem(
//                id: UUID(),
//                image: UIImage(named: "img_background_gradiant_middle"),
//                profileImage: UIImage(named: "dummy_profile_\(idx % 3)"),
//                title: "한번 보면 못 빠져나오는 사랑이야기 \(idx)",
//                userName: "사용자 이름"
//            )
//        }
//    }
//}
