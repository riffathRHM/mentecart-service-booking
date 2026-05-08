import 'package:flutter/material.dart';
import '/core/constants/app_colors.dart';
import '/core/constants/app_typography.dart';
import '/core/constants/app_dimensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String selectedCategory = "All";

  final List<Map<String, dynamic>> services = [
    {
      "title": "Home Cleaning",
      "category": "Cleaning",
      "price": "\$50",
      "icon": Icons.cleaning_services,
    },
    {
      "title": "AC Repair",
      "category": "Maintenance",
      "price": "\$80",
      "icon": Icons.ac_unit,
    },
    {
      "title": "Hair Styling",
      "category": "Beauty",
      "price": "\$30",
      "icon": Icons.face,
    },
    {
      "title": "Yoga Class",
      "category": "Wellness",
      "price": "\$25",
      "icon": Icons.self_improvement,
    },
  ];

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
              children: [
                chip("All"),
                chip("Cleaning"),
                chip("Maintenance"),
                chip("Beauty"),
                chip("Wellness"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final item = services[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/service-detail',
                    );
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
                            item["icon"],
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
                                item["title"],
                                style: AppTypography.bodyLarge,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item["category"],
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item["price"],
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
    bool selected = selectedCategory == label;

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
          setState(() {
            selectedCategory = label;
          });
        },
      ),
    );
  }
}