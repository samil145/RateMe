import UIKit

class ProfileViewController: BaseViewController {
    
    // MARK: - Properties
    private let profile: Profile
    private var ratings: [Rating] = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let socialLinksStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let contactButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Contact", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let ratingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RatingCell.self, forCellReuseIdentifier: RatingCell.identifier)
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
//        button.backgroundColor = .systemBlue
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(profile: Profile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(professionLabel)
        contentView.addSubview(bioLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(socialLinksStackView)
        contentView.addSubview(contactButton)
        contentView.addSubview(ratingsTableView)
        contentView.addSubview(signOutButton)
        
        setupConstraints()
        setupSocialLinks()
        setupContactButton()
        setupSignOutButton()
        setupRatingsTableView()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            professionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            bioLabel.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 16),
            bioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ratingView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 16),
            ratingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            socialLinksStackView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 24),
            socialLinksStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            socialLinksStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contactButton.topAnchor.constraint(equalTo: socialLinksStackView.bottomAnchor, constant: 24),
            contactButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactButton.heightAnchor.constraint(equalToConstant: 44),
            
            signOutButton.topAnchor.constraint(equalTo: contactButton.bottomAnchor, constant: 24),
            signOutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signOutButton.heightAnchor.constraint(equalToConstant: 44),
            
            ratingsTableView.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 24),
            ratingsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingsTableView.heightAnchor.constraint(equalToConstant: 300),
            ratingsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupSocialLinks() {
        if let linkedin = profile.socialLinks.linkedin {
            let linkedinButton = createSocialButton(title: "LinkedIn", url: linkedin)
            socialLinksStackView.addArrangedSubview(linkedinButton)
        }
        
        if let instagram = profile.socialLinks.instagram {
            let instagramButton = createSocialButton(title: "Instagram", url: instagram)
            socialLinksStackView.addArrangedSubview(instagramButton)
        }
        
        if let youtube = profile.socialLinks.youtube {
            let youtubeButton = createSocialButton(title: "YouTube", url: youtube)
            socialLinksStackView.addArrangedSubview(youtubeButton)
        }
    }
    
    private func createSocialButton(title: String, url: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(socialButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func setupContactButton() {
        contactButton.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
    }
    
    private func setupSignOutButton() {
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
    }
    
    private func setupRatingsTableView() {
        ratingsTableView.delegate = self
        ratingsTableView.dataSource = self
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // Configure profile data
        nameLabel.text = profile.name
        professionLabel.text = profile.profession
        bioLabel.text = profile.bio
        ratingView.setRating(profile.rating)
        
        // Load profile image
        if let url = URL(string: profile.profileImageURL ?? "") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            }.resume()
        }
        
        // Load ratings
        ratings = Rating.mockRatings.filter { $0.toUserId == profile.id }
    }
    
    // MARK: - Actions
    @objc private func socialButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        let urlString: String?
        
        switch title {
        case "LinkedIn":
            urlString = profile.socialLinks.linkedin
        case "Instagram":
            urlString = profile.socialLinks.instagram
        case "YouTube":
            urlString = profile.socialLinks.youtube
        default:
            urlString = nil
        }
        
        if let urlString = urlString, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func contactButtonTapped() {
        // In a real app, this would open a contact form or messaging interface
        showSuccess("Contact request sent!")
    }
    
    @objc private func signOutButtonTapped() {
        signOutTapped()
    }
    
    func signOutTapped() {
        showLoadingView()
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }

            if let error = error
            {
                presentMHAlertOnMainThread(title: "Something Went Wrong", message: error.localizedDescription, buttonTitle: "Ok")
                return
            }

            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    sceneDelegate.checkAuth()
                    self.dismissLoadingView()
                }
            }
            
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.identifier, for: indexPath) as! RatingCell
        let rating = ratings[indexPath.row]
        cell.configure(with: rating)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Rating Cell
class RatingCell: UITableViewCell {
    static let identifier = "RatingCell"
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let raterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
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
        contentView.addSubview(ratingView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(raterLabel)
        
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            commentLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            raterLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 4),
            raterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            raterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with rating: Rating) {
        ratingView.setRating(Double(rating.rating))
        commentLabel.text = rating.comment
        raterLabel.text = "By \(rating.fromUserId)"
    }
} 
