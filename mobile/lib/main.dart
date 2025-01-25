import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dishcovery/provider/location_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dishcovery/screens/question_flow_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchNearbyRestaurants();
  }

  Future<void> _fetchNearbyRestaurants() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final position = locationProvider.currentPosition;

    if (position == null) {
      // Handle location not available
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your actual backend API endpoint
      final response = await http.get(Uri.parse(
          'https://your-backend-api.com/restaurants?lat=${position.latitude}&lng=${position.longitude}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
        });
      } else {
        // Handle server errors
      }
    } catch (e) {
      // Handle network errors
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) async {
    setState(() {
      _searchQuery = query;
    });
    if (query.isNotEmpty) {
      await _fetchSearchSuggestions(query);
    }
  }

  Future<void> _fetchSearchSuggestions(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://your-backend-api.com/search-suggestions?query=$query'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
        });
      } else {
        // Handle server errors
      }
    } catch (e) {
      // Handle network errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Discover Restaurants'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.refresh),
              onPressed: () {
                locationProvider.refreshLocation();
                _fetchNearbyRestaurants();
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                onChanged: _onSearch,
                onSubmitted: (value) {
                  // Optional: implement final search action
                },
                placeholder: 'Search for restaurants',
              ),
            ),
            // Restaurant List
            Expanded(
              child: _isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : _restaurants.isEmpty
                      ? const Center(child: Text('No restaurants found.'))
                      : ListView.builder(
                          itemCount: _restaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = _restaurants[index];
                            return RestaurantCard(restaurant: restaurant);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class Restaurant {
  final String name;
  final String address;
  final double rating;
  final String imageUrl;

  Restaurant({
    required this.name,
    required this.address,
    required this.rating,
    required this.imageUrl,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? 'Unknown',
      address: json['address'] ?? 'No address provided',
      rating: (json['rating'] != null) ? json['rating'].toDouble() : 0.0,
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/50',
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // Navigate to question flow for recommendations at this restaurant
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuestionFlowScreen(
              restaurantName: restaurant.name,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: Image.network(
            restaurant.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(restaurant.name),
          subtitle: Text(restaurant.address),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.star,
                  color: CupertinoColors.systemYellow, size: 16),
              Text(restaurant.rating.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
