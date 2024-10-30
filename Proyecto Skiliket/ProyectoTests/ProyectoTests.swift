import XCTest
@testable import Proyecto

final class ProyectoTests: XCTestCase {

    var createAccountVC: CreateAccountViewController!
    var projectsTableVC: ProjectsTableViewController!
    var postsTableVC: PostsTableViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        createAccountVC = storyboard.instantiateViewController(withIdentifier: "CreateAccountViewController") as? CreateAccountViewController
        projectsTableVC = storyboard.instantiateViewController(withIdentifier: "ProjectsTableViewController") as? ProjectsTableViewController
        postsTableVC = storyboard.instantiateViewController(withIdentifier: "PostsTableViewController") as? PostsTableViewController

        createAccountVC.loadViewIfNeeded()
        projectsTableVC.loadViewIfNeeded()
        postsTableVC.loadViewIfNeeded()
        
        let userPost1 = UserPost(comments: [], content: "Post about Swift", likes: 10, postDate: "2024-10-10", postID: 1, postURL: "https://example.com/post1", userID: "user1", userURL: "https://example.com/user1", username: "User 1")
        let userPost2 = UserPost(comments: [], content: "Post about iOS", likes: 5, postDate: "2024-10-11", postID: 2, postURL: "https://example.com/post2", userID: "user2", userURL: "https://example.com/user2", username: "User 2")
        let userPost3 = UserPost(comments: [], content: "Post about Xcode", likes: 7, postDate: "2024-10-12", postID: 3, postURL: "https://example.com/post3", userID: "user3", userURL: "https://example.com/user3", username: "User 3")

        let posts = Posts(projectID: 1, projectName: "iOS Development", userPosts: [userPost1, userPost2, userPost3])
        
        postsTableVC.postsList = [posts]
        postsTableVC.userPostsList = posts.userPosts
        postsTableVC.filteredPostsList = posts.userPosts
        postsTableVC.searchFilteredPostsList = posts.userPosts
    }
    
    override func tearDownWithError() throws {
        createAccountVC = nil
        projectsTableVC = nil
        postsTableVC = nil
        try super.tearDownWithError()
    }

    // Test 1: Check if the user filled all fields in CreateAccountViewController
    func testUserFilledAllFields() throws {
        createAccountVC.EmailTextField.text = "testuser@example.com"
        createAccountVC.FullNameTextfield.text = "Test User"
        createAccountVC.AddressTextField.text = "123 Test Street"
        createAccountVC.AgeTextField.text = "30"
        createAccountVC.PasswordTextField.text = "password123"
        createAccountVC.selectedZone = "Mexico City"
        createAccountVC.isCheckButtonChecked = true

        createAccountVC.Register(UIButton())

        XCTAssertEqual(createAccountVC.EmailTextField.text, "testuser@example.com")
        XCTAssertEqual(createAccountVC.FullNameTextfield.text, "Test User")
        XCTAssertEqual(createAccountVC.AddressTextField.text, "123 Test Street")
        XCTAssertEqual(createAccountVC.AgeTextField.text, "30")
        XCTAssertEqual(createAccountVC.PasswordTextField.text, "password123")
        XCTAssertEqual(createAccountVC.selectedZone, "Mexico City")
        XCTAssertTrue(createAccountVC.isCheckButtonChecked)
    }
    
    // Test 2: Check if the user doesn't select 5 projects in ProjectsTableViewController and sends out an error
    func testLessThanFiveProjectsSelectedShowsError() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = projectsTableVC
        window.makeKeyAndVisible()

        projectsTableVC.projectsList = [Project(challenges: ["Challenge 1"], communityInvolvement: CommunityInvolvement(participants: 10, posts: 5, targetGroups: ["Group 1"]),
                                                description: "Description 1", endDate: "2024-12-31", id: 1, location: [Location(city: "Mexico City", country: .méxico, devicesDeployed: 10)],
                                                monitoredVariables: ["Variable 1"], name: "Project 1", objectives: ["Objective 1"], solutions: ["Solution 1"], startDate: "2024-01-01", status: "Active",
                                                technologiesUsed: TechnologiesUsed(ioTDevices: true, mobileApp: true, webPlatform: true, gisMapping: false, drones: false, airQualitySensors: false, cameraTraps: false, droneSurveillance: false, eLearningPlatform: false),
                                                topic: "Topic 1", urlTopic: "https://example.com/topic1")]

        XCTAssertFalse(projectsTableVC.projectsList.isEmpty, "Projects list should not be empty")
        
        projectsTableVC.projectsList[0].isChecked = true
        projectsTableVC.nextButtonTapped()

        let expectation = self.expectation(description: "Wait for alert to appear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.projectsTableVC.presentedViewController is UIAlertController {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3.0)
        let presentedVC = projectsTableVC.presentedViewController as? UIAlertController
        XCTAssertNotNil(presentedVC)
        XCTAssertEqual(presentedVC?.title, "Selection Error")
        XCTAssertEqual(presentedVC?.message, "Please select at least 5 projects to proceed.")
    }

    // Test 3: Check if the user selects 5 or more projects and can advance
    func testFiveOrMoreProjectsSelectedAdvances() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = projectsTableVC
        window.makeKeyAndVisible()

        projectsTableVC.projectsList.append(contentsOf: [
            Project(challenges: ["Challenge 2"], communityInvolvement: CommunityInvolvement(participants: 20, posts: 10, targetGroups: ["Group 2"]),
                    description: "Description 2", endDate: "2024-12-31", id: 2, location: [Location(city: "Guadalajara", country: .méxico, devicesDeployed: 15)],
                    monitoredVariables: ["Variable 2"], name: "Project 2", objectives: ["Objective 2"], solutions: ["Solution 2"], startDate: "2024-01-01", status: "Active",
                    technologiesUsed: TechnologiesUsed(ioTDevices: false, mobileApp: true, webPlatform: true, gisMapping: true, drones: false, airQualitySensors: false, cameraTraps: false, droneSurveillance: false, eLearningPlatform: true),
                    topic: "Topic 2", urlTopic: "https://example.com/topic2"),
            Project(challenges: ["Challenge 3"], communityInvolvement: CommunityInvolvement(participants: 30, posts: 15, targetGroups: ["Group 3"]),
                    description: "Description 3", endDate: "2024-12-31", id: 3, location: [Location(city: "Monterrey", country: .méxico, devicesDeployed: 20)],
                    monitoredVariables: ["Variable 3"], name: "Project 3", objectives: ["Objective 3"], solutions: ["Solution 3"], startDate: "2024-01-01", status: "Active",
                    technologiesUsed: TechnologiesUsed(ioTDevices: true, mobileApp: true, webPlatform: true, gisMapping: false, drones: false, airQualitySensors: false, cameraTraps: false, droneSurveillance: false, eLearningPlatform: false),
                    topic: "Topic 3", urlTopic: "https://example.com/topic3"),
            Project(challenges: ["Challenge 4"], communityInvolvement: CommunityInvolvement(participants: 40, posts: 20, targetGroups: ["Group 4"]),
                    description: "Description 4", endDate: "2024-12-31", id: 4, location: [Location(city: "Toronto", country: .canadá, devicesDeployed: 25)],
                    monitoredVariables: ["Variable 4"], name: "Project 4", objectives: ["Objective 4"], solutions: ["Solution 4"], startDate: "2024-01-01", status: "Active",
                    technologiesUsed: TechnologiesUsed(ioTDevices: false, mobileApp: true, webPlatform: true, gisMapping: true, drones: false, airQualitySensors: false, cameraTraps: false, droneSurveillance: false, eLearningPlatform: true),
                    topic: "Topic 4", urlTopic: "https://example.com/topic4"),
            Project(challenges: ["Challenge 4"], communityInvolvement: CommunityInvolvement(participants: 40, posts: 20, targetGroups: ["Group 4"]),
                    description: "Description 4", endDate: "2024-12-31", id: 4, location: [Location(city: "Toronto", country: .canadá, devicesDeployed: 25)],
                    monitoredVariables: ["Variable 4"], name: "Project 4", objectives: ["Objective 4"], solutions: ["Solution 4"], startDate: "2024-01-01", status: "Active",
                    technologiesUsed: TechnologiesUsed(ioTDevices: false, mobileApp: true, webPlatform: true, gisMapping: true, drones: false, airQualitySensors: false, cameraTraps: false, droneSurveillance: false, eLearningPlatform: true),
                    topic: "Topic 4", urlTopic: "https://example.com/topic4"),
            Project(challenges: ["Challenge 4"], communityInvolvement: CommunityInvolvement(participants: 40, posts: 20, targetGroups: ["Group 4"]),
                    description: "Description 4", endDate: "2024-12-31", id: 4, location: [Location(city: "Toronto", country: .canadá, devicesDeployed: 25)],
                    monitoredVariables: ["Variable 4"], name: "Project 4", objectives: ["Objective 4"], solutions: ["Solution 4"], startDate: "2024-01-01", status: "Active",
                    technologiesUsed: TechnologiesUsed(ioTDevices: false, mobileApp: true, webPlatform: true, gisMapping: true, drones: false, airQualitySensors: false, cameraTraps: false, droneSurveillance: false, eLearningPlatform: true),
                    topic: "Topic 4", urlTopic: "https://example.com/topic4")
        ])

        projectsTableVC.projectsList[0].isChecked = true
        projectsTableVC.projectsList[1].isChecked = true
        projectsTableVC.projectsList[2].isChecked = true
        projectsTableVC.projectsList[3].isChecked = true
        projectsTableVC.projectsList[4].isChecked = true

        projectsTableVC.nextButtonTapped()
        let presentedVC = projectsTableVC.presentedViewController as? UIAlertController
        XCTAssertNil(presentedVC)
    }

    // Test 4: Verify if the search bar works in PostsTableViewController
    func testSearchBarWorks() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = postsTableVC
        window.makeKeyAndVisible()

        postsTableVC.searchController.searchBar.text = "Swift"
        postsTableVC.updateSearchResults(for: postsTableVC.searchController)

        let searchResults = postsTableVC.searchFilteredPostsList
        XCTAssertEqual(searchResults.count, 1)
        XCTAssertEqual(searchResults.first?.content, "Post about Swift")
    }
    
    // Test 5: Verify if the search bar doesn't work in PostsTableViewController
    func testSearchBarNoMatches() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = postsTableVC
        window.makeKeyAndVisible()

        postsTableVC.searchController.searchBar.text = "Nonexistent"
        postsTableVC.updateSearchResults(for: postsTableVC.searchController)

        let searchResults = postsTableVC.searchFilteredPostsList
        XCTAssertEqual(searchResults.count, 0, "The search results should return no matches for a nonexistent query.")
    }
    
    // Test 6: Check if the user tries to register with a weak password
    func testWeakPassword() throws {
        createAccountVC.EmailTextField.text = "testuser@example.com"
        createAccountVC.FullNameTextfield.text = "Test User"
        createAccountVC.AddressTextField.text = "123 Test Street"
        createAccountVC.AgeTextField.text = "30"
        createAccountVC.PasswordTextField.text = "123"
        createAccountVC.selectedZone = "Mexico City"
        createAccountVC.isCheckButtonChecked = true

        createAccountVC.Register(UIButton())

        XCTAssertTrue(createAccountVC.PasswordTextField.text!.count < 6, "The password must be stronger (more than 6 characters).")
    }
    
    // Test 7: Check if the user tries to register with a strong password
    func testStrongPassword() throws {
        createAccountVC.EmailTextField.text = "testuser@example.com"
        createAccountVC.FullNameTextfield.text = "Test User"
        createAccountVC.AddressTextField.text = "123 Test Street"
        createAccountVC.AgeTextField.text = "30"
        createAccountVC.PasswordTextField.text = "1234567"
        createAccountVC.selectedZone = "Mexico City"
        createAccountVC.isCheckButtonChecked = true

        createAccountVC.Register(UIButton())

        XCTAssertTrue(createAccountVC.PasswordTextField.text!.count > 6, "The password is strong enough (more than 6 characters).")
    }
    
    // Test 8: Check if the user tries to register with an email that has a valid structure
    func testValidEmailStructure() throws {
        createAccountVC.EmailTextField.text = "testuser@example.com"
        createAccountVC.FullNameTextfield.text = "Test User"
        createAccountVC.AddressTextField.text = "123 Test Street"
        createAccountVC.AgeTextField.text = "30"
        createAccountVC.PasswordTextField.text = "1234567"
        createAccountVC.selectedZone = "Mexico City"
        createAccountVC.isCheckButtonChecked = true

        createAccountVC.Register(UIButton())

        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)

        XCTAssertTrue(emailPredicate.evaluate(with: createAccountVC.EmailTextField.text), "The email structure is valid.")
    }

    // Test 9: Check if the user tries to register with an email that has an invalid structure
    func testInvalidEmailStructure() throws {
        createAccountVC.EmailTextField.text = "testuser-example.com"
        createAccountVC.FullNameTextfield.text = "Test User"
        createAccountVC.AddressTextField.text = "123 Test Street"
        createAccountVC.AgeTextField.text = "30"
        createAccountVC.PasswordTextField.text = "1234567"
        createAccountVC.selectedZone = "Mexico City"
        createAccountVC.isCheckButtonChecked = true

        createAccountVC.Register(UIButton())

        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)

        XCTAssertFalse(emailPredicate.evaluate(with: createAccountVC.EmailTextField.text), "The email structure is invalid.")
    }

    // Test 10: Check if the user tries to register with an age that isn't a number
    func testInvalidAgeStructure() throws {
        createAccountVC.EmailTextField.text = "testuser@example.com"
        createAccountVC.FullNameTextfield.text = "Test User"
        createAccountVC.AddressTextField.text = "123 Test Street"
        createAccountVC.AgeTextField.text = "3t"
        createAccountVC.PasswordTextField.text = "1234567"
        createAccountVC.selectedZone = "Mexico City"
        createAccountVC.isCheckButtonChecked = true

        createAccountVC.Register(UIButton())

        let agePattern = "^[0-9]+$"
        let agePredicate = NSPredicate(format: "SELF MATCHES %@", agePattern)

        XCTAssertFalse(agePredicate.evaluate(with: createAccountVC.AgeTextField.text), "The age structure is invalid.")
    }
    
    // Test 11: Check if the user tries to register with an age that is a number
    func testValidAgeStructure() throws {
        createAccountVC.EmailTextField.text = "testuser@example.com"
        createAccountVC.FullNameTextfield.text = "Test User"
        createAccountVC.AddressTextField.text = "123 Test Street"
        createAccountVC.AgeTextField.text = "30"
        createAccountVC.PasswordTextField.text = "1234567"
        createAccountVC.selectedZone = "Mexico City"
        createAccountVC.isCheckButtonChecked = true

        createAccountVC.Register(UIButton())

        let agePattern = "^[0-9]+$"
        let agePredicate = NSPredicate(format: "SELF MATCHES %@", agePattern)

        XCTAssertTrue(agePredicate.evaluate(with: createAccountVC.AgeTextField.text), "The age structure is valid.")
    }
}
