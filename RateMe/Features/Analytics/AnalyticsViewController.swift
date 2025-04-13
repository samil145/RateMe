import UIKit

class AnalyticsViewController: BaseViewController {
    
    // MARK: - Properties
    private var leaderboards: [Leaderboard] = []
    private var trendingProfiles: [Profile] = []
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let leaderboardsLabel: UILabel = {
        let label = UILabel()
        label.text = "Leaderboards"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let leaderboardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let trendingLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending Profiles"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trendingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Analytics"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addSubview(leaderboardsLabel)
        contentStackView.addSubview(leaderboardsCollectionView)
        contentStackView.addSubview(trendingLabel)
        contentStackView.addSubview(trendingTableView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        setupLeaderboardsView()
        setupTrendingProfilesView()
    }
    
    private func setupLeaderboardsView() {
        let leaderboardsView = UIView()
        leaderboardsView.translatesAutoresizingMaskIntoConstraints = false
        leaderboardsView.backgroundColor = .systemBackground
        leaderboardsView.layer.cornerRadius = 12
        leaderboardsView.layer.masksToBounds = true
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        // Add leaderboard cards
        for leaderboard in Leaderboard.mockLeaderboards {
            let card = LeaderboardCard(leaderboard: leaderboard)
            stackView.addArrangedSubview(card)
            card.widthAnchor.constraint(equalToConstant: 280).isActive = true
        }
        
        leaderboardsView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: leaderboardsView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leaderboardsView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: leaderboardsView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: leaderboardsView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
//            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        contentStackView.addArrangedSubview(leaderboardsView)
        leaderboardsView.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    private func setupTrendingProfilesView() {
        let trendingView = UIView()
        trendingView.translatesAutoresizingMaskIntoConstraints = false
        trendingView.backgroundColor = .systemBackground
        trendingView.layer.cornerRadius = 12
        trendingView.layer.masksToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Trending Profiles"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        trendingView.addSubview(titleLabel)
        trendingView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: trendingView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: trendingView.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        contentStackView.addArrangedSubview(trendingView)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        leaderboards = Leaderboard.mockLeaderboards
        trendingProfiles = Profile.mockProfiles
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension AnalyticsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leaderboards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeaderboardCell.identifier, for: indexPath) as! LeaderboardCell
        let leaderboard = leaderboards[indexPath.item]
        cell.configure(with: leaderboard)
        return cell
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension AnalyticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        let profile = trendingProfiles[indexPath.row]
        cell.configure(with: profile)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let profile = trendingProfiles[indexPath.row]
        let profileVC = ProfileViewController(profile: profile)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

// MARK: - Leaderboard Cell
class LeaderboardCell: UICollectionViewCell {
    static let identifier = "LeaderboardCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(usersStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            usersStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            usersStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            usersStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            usersStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with leaderboard: Leaderboard) {
        categoryLabel.text = leaderboard.category
        
        usersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        leaderboard.topUsers.enumerated().forEach { index, user in
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .secondaryLabel
            label.text = "\(index + 1). \(user)"
            usersStackView.addArrangedSubview(label)
        }
    }
}

// MARK: - Profile Cell
class ProfileCell: UITableViewCell {
    static let identifier = "ProfileCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(professionLabel)
        contentView.addSubview(ratingView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            professionLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            professionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingView.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with profile: Profile) {
        nameLabel.text = profile.name
        professionLabel.text = profile.profession
        ratingView.setRating(profile.rating)
        
        if let url = URL(string: profile.profileImageURL ?? "") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            }.resume()
        }
    }
}

// MARK: - Leaderboard Card
class LeaderboardCard: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(leaderboard: Leaderboard) {
        super.init(frame: .zero)
        setupUI()
        configure(with: leaderboard)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(usersStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            usersStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            usersStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            usersStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            usersStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with leaderboard: Leaderboard) {
        titleLabel.text = leaderboard.title
        descriptionLabel.text = leaderboard.description
        
        usersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        leaderboard.topUsers.enumerated().forEach { index, user in
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .secondaryLabel
            label.text = "\(index + 1). \(user)"
            usersStackView.addArrangedSubview(label)
        }
    }
} 
