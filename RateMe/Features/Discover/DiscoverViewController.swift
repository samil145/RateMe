import UIKit

class DiscoverViewController: BaseViewController {
    
    // MARK: - Properties
    private var profiles: [Profile] = []
    private var currentIndex = 0
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search professionals..."
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private var currentCard: ProfileCardView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        loadProfiles()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    private func setupCardContainer() {
        view.addSubview(cardContainer)
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardContainer.heightAnchor.constraint(equalTo: cardContainer.widthAnchor, multiplier: 1.3)
        ])
    }
    
    private func loadProfiles() {
        // In a real app, this would be an API call
        profiles = Profile.mockProfiles
        setupCardContainer()
        showNextCard()
    }
    
    private func showNextCard() {
        guard currentIndex < profiles.count else {
            // No more profiles to show
            let label = UILabel()
            label.text = "No more profiles to show"
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            cardContainer.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: cardContainer.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor)
            ])
            return
        }
        
        let profile = profiles[currentIndex]
        let card = ProfileCardView()
        card.configure(with: profile)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        // Remove previous card
        currentCard?.removeFromSuperview()
        currentCard = card
        
        cardContainer.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: cardContainer.topAnchor),
            card.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor)
        ])
        
        // Add pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        card.addGestureRecognizer(panGesture)
        card.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view as? ProfileCardView else { return }
        
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            let rotation = translation.x / 300
            card.transform = transform.rotated(by: rotation)
            
        case .ended:
            let threshold: CGFloat = 100
            let shouldDismiss = abs(translation.x) > threshold || abs(velocity.x) > 1000
            
            if shouldDismiss {
                let direction: CGFloat = translation.x > 0 ? 1 : -1
                UIView.animate(withDuration: 0.3, animations: {
                    card.transform = CGAffineTransform(translationX: direction * 1000, y: 0)
                }) { _ in
                    card.removeFromSuperview()
                    self.currentIndex += 1
                    self.showNextCard()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    card.transform = .identity
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - UISearchResultsUpdating
extension DiscoverViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            // Reset to original profiles
            currentIndex = 0
            showNextCard()
            return
        }
        
        // Filter profiles based on search text
        let filteredProfiles = profiles.filter { profile in
            profile.name.localizedCaseInsensitiveContains(searchText) ||
            profile.profession.localizedCaseInsensitiveContains(searchText) ||
            profile.bio.localizedCaseInsensitiveContains(searchText)
        }
        
        // Update current profiles and reset index
        profiles = filteredProfiles
        currentIndex = 0
        showNextCard()
    }
} 
