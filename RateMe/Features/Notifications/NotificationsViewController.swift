import UIKit

class NotificationsViewController: BaseViewController {
    
    // MARK: - Properties
    private var notifications: [AppNotification] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
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
        title = "Notifications"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Data Loading
    private func loadData() {
        notifications = AppNotification.mockNotifications
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
        let notification = notifications[indexPath.row]
        cell.configure(with: notification)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notifications[indexPath.row]
        
        switch notification.type {
        case .newRating, .newComment, .followerActivity:
            if let profile = Profile.mockProfiles.first(where: { $0.name == notification.message.components(separatedBy: " ")[0] }) {
                let profileVC = ProfileViewController(profile: profile)
                navigationController?.pushViewController(profileVC, animated: true)
            }
            
        case .leaderboardRank:
            let analyticsVC = AnalyticsViewController()
            navigationController?.pushViewController(analyticsVC, animated: true)
            
        case .newFollower:
            if let profile = Profile.mockProfiles.first(where: { $0.name == notification.message.components(separatedBy: " ")[0] }) {
                let profileVC = ProfileViewController(profile: profile)
                navigationController?.pushViewController(profileVC, animated: true)
            }
            
        case .profileUpdate, .milestone:
            break
        }
    }
}

// MARK: - Notification Cell
class NotificationCell: UITableViewCell {
    static let identifier = "NotificationCell"
    
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
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timestampLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            timestampLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with notification: AppNotification) {
        messageLabel.text = notification.message
        
        let iconName: String
        switch notification.type {
        case .newRating:
            iconName = "star.fill"
        case .newComment:
            iconName = "bubble.left.fill"
        case .newFollower:
            iconName = "person.badge.plus.fill"
        case .profileUpdate:
            iconName = "person.crop.circle.badge.checkmark.fill"
        case .milestone:
            iconName = "trophy.fill"
        case .leaderboardRank:
            iconName = "crown.fill"
        case .followerActivity:
            iconName = "square.and.arrow.up.fill"
        }
        iconImageView.image = UIImage(systemName: iconName)
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        timestampLabel.text = formatter.localizedString(for: notification.timestamp, relativeTo: Date())
        
        containerView.backgroundColor = notification.isRead ? .systemBackground : .systemGray6
    }
} 
