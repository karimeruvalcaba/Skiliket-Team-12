import UIKit

class ThirtyThreeCollectionViewController: UICollectionViewController {

    var projectsByTopic = [String: [Project]]()

    override func viewDidLoad() {
        super.viewDidLoad()


        setupCollectionViewLayout()

        self.collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        Task {
            do {
                let projects = try await ProjectsPT.fetchProjectPT()
                self.groupProjectsByTopic(projects: projects.projects)
                self.collectionView.reloadData()
            } catch {
                print("Fetch Projects failed with error: \(error.localizedDescription)")
            }
        }
    }

    private func setupCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let screenWidth = UIScreen.main.bounds.width
            let itemWidth = (screenWidth - 30) / 2
            layout.itemSize = CGSize(width: itemWidth, height: 200)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }

    private func groupProjectsByTopic(projects: [Project]) {
        projectsByTopic = Dictionary(grouping: projects, by: { $0.topic })
    }

    // MARK: - UICollectionView data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectsByTopic.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCellIdentifier", for: indexPath) as! ThirtyThreeCollectionViewCell
        
        let topic = Array(projectsByTopic.keys)[indexPath.row]
        let projects = projectsByTopic[topic] ?? []

        let totalParticipants = projects.reduce(0) { $0 + $1.communityInvolvement.participants }
        let totalPosts = projects.reduce(0) { $0 + $1.communityInvolvement.posts }

        let imageUrl = projects.first?.urlTopic ?? ""

        cell.configure(topic: topic, participants: totalParticipants, posts: totalPosts, imageUrl: imageUrl)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            headerView.headerLabel.text = "What are you looking for?"
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = Array(projectsByTopic.keys)[indexPath.row]
        let projects = projectsByTopic[topic] ?? []

        let detailVC = ProjectDetailViewController()
        detailVC.projects = projects
        detailVC.topic = topic

        navigationController?.pushViewController(detailVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProjectDetailsSegue" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let topic = Array(projectsByTopic.keys)[indexPath.row]
                let projects = projectsByTopic[topic] ?? []

                let destinationVC = segue.destination as! ProjectDetailViewController
                destinationVC.projects = projects
            }
        }
    }

    
}
