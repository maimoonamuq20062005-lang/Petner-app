class AppConstants {
  // App Info
  static const String appName = 'PETNER';
  static const String appTagline = 'Find the perfect companion for your pet';
  static const String appVersion = '1.0.0';

  // Routes
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeUserSetup = '/user-setup';
  static const String routePetSetup = '/pet-setup';
  static const String routeHome = '/home';
  static const String routeDiscover = '/discover';
  static const String routePetDetail = '/pet-detail';
  static const String routeMatch = '/match';
  static const String routeChatList = '/chats';
  static const String routeChat = '/chat';
  static const String routeMap = '/map';
  static const String routeNotifications = '/notifications';
  static const String routeSettings = '/settings';
  static const String routeAdminPanel = '/admin';
  static const String routeProfile = '/profile';

  // Asset Paths
  static const String assetsImages = 'assets/images/';
  static const String logoAsset = 'assets/images/logo.png';

  // Hive Box Names
  static const String hiveUserBox = 'user_box';
  static const String hivePetBox = 'pet_box';
  static const String hiveChatBox = 'chat_box';
  static const String hiveSettingsBox = 'settings_box';

  // Hive Keys
  static const String hiveKeyUser = 'current_user';
  static const String hiveKeyOnboarded = 'onboarded';
  static const String hiveKeyLoggedIn = 'logged_in';

  // Pagination
  static const int pageSize = 20;

  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 400);
  static const Duration animSlow = Duration(milliseconds: 600);
  static const Duration animVerySlow = Duration(milliseconds: 1000);

  // Pet Attributes
  static const List<String> petSizes = ['Tiny', 'Small', 'Medium', 'Large', 'Giant'];
  static const List<String> energyLevels = ['Low', 'Moderate', 'High'];
  static const List<String> dietTypes = ['Omnivore', 'Carnivore', 'Herbivore', 'Special'];
  static const List<String> dietPreferences = ['Homemade', 'Processed', 'Mixed'];
  static const List<String> socialBehaviours = ['Shy', 'Friendly', 'Playful', 'Dominant', 'Independent'];
  static const List<String> livingEnvironments = ['Apartment', 'House', 'House with Yard', 'Farm'];
  static const List<String> petGenders = ['Male', 'Female'];
  static const List<String> healthStatuses = ['Excellent', 'Good', 'Fair', 'Needs Care'];
  static const List<String> commonDogBreeds = [
    'Labrador Retriever', 'Golden Retriever', 'Bulldog', 'Beagle', 'Poodle',
    'German Shepherd', 'Husky', 'Chihuahua', 'Dachshund', 'Shih Tzu',
    'Pomeranian', 'Border Collie', 'Cocker Spaniel', 'Mixed Breed',
  ];
  static const List<String> commonCatBreeds = [
    'Persian', 'Maine Coon', 'Siamese', 'Ragdoll', 'Bengal',
    'British Shorthair', 'Sphynx', 'Russian Blue', 'Abyssinian', 'Mixed Breed',
  ];
  static const List<String> petTypes = ['Dog', 'Cat', 'Rabbit', 'Bird', 'Other'];
}
