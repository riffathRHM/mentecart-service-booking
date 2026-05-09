import 'package:flutter/material.dart';
import 'package:mentecart_mobile/core/network/api_client.dart';
import 'package:mentecart_mobile/data/models/service/service_model.dart';
import '/core/constants/app_colors.dart';
import '/core/constants/app_typography.dart';
import '/core/constants/app_dimensions.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedCategory = "All";
  String searchQuery = "";

  late ApiClient apiClient;
  List<ServiceModel> allServices = [];
  List<ServiceModel> filteredServices = [];
  bool isLoading = true;
  String? errorMessage;

  final List<String> categories = ["All", "cleaning", "maintenance", "wellness", "testing"];

  @override
  void initState() {
    super.initState();
    apiClient = ApiClient();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await apiClient.getServices(
        category: selectedCategory != "All" ? selectedCategory : null,
      );
      
      debugPrint('API call - selectedCategory: $selectedCategory, category param: ${selectedCategory != "All" ? selectedCategory : null}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['services'] ?? [];
        debugPrint('API Response - Total services from API: ${data.length}');
        
        setState(() {
          allServices = data
              .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
              .where((service) => service.id != null && service.title != null)
              .toList();
          
          debugPrint('Mapped services after filtering nulls: ${allServices.length}');
          for (var service in allServices) {
            debugPrint('Service: ${service.title} - Category: ${service.category}');
          }
          
          _applyFilters();
          debugPrint('Filtered services: ${filteredServices.length}');
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load services (Status: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error in _fetchServices: $e');
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    debugPrint('Applying filters - allServices: ${allServices.length}, selectedCategory: $selectedCategory, searchQuery: $searchQuery');
    
    filteredServices = allServices.where((service) {
      // Always include all services if no search query (category filtering is done at API level when fetching)
      if (searchQuery.isEmpty) {
        return true;
      }
      
      // If search query exists, filter by search
      final matchesSearch =
          (service.title?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          (service.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          (service.category?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      
      return matchesSearch;
    }).toList();
    
    debugPrint('Filtered services result: ${filteredServices.length}');
  }

  void _onCategorySelected(String category) {
    debugPrint('Category selected: $category');
    debugPrint('Previous selectedCategory: $selectedCategory');
    setState(() {
      selectedCategory = category;
    });
    debugPrint('New selectedCategory: $selectedCategory');
    _fetchServices();
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text("MenteCart"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          /// search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search services...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// category
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories
                  .map((category) => chip(category == "All" ? category : category.capitalize()))
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),

          /// cards or loading/error
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage ?? 'Unknown error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchServices,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredServices.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No services found',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  final service = filteredServices[index];

                  return GestureDetector(
                    onTap: () {
                      if (service.id != null) {
                        Navigator.pushNamed(
                          context,
                          '/service-detail',
                          arguments: service.id,
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            color: Colors.black.withOpacity(.05),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor:
                                AppColors.primary.withOpacity(.1),
                            child: Icon(
                              Icons.miscellaneous_services,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.title ?? 'Unknown',
                                  style: AppTypography.bodyLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  service.category?.capitalize() ?? 'Other',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${(service.price ?? 0).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => selectedIndex = index);

          if (index == 1) {
            Navigator.pushNamed(context, '/cart');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/bookings');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget chip(String label) {
    bool selected = selectedCategory.toLowerCase() == label.toLowerCase();

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
        onSelected: (_) {
          // Special handling for "All" category
          final categoryToSelect = label == "All" ? "All" : label.toLowerCase();
          _onCategorySelected(categoryToSelect);
        },
      ),
    );
  }
}