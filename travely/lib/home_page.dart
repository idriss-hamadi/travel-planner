import 'package:flutter/material.dart';
import 'popular_places_page.dart';
import 'budget_planner_page.dart';
import 'safety_tips_page.dart';
import 'travel_checklist_page.dart';
import 'user_reviews_page.dart';
import 'favorites_page.dart';
import 'travel_deals_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Planner'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCard(
                context,
                'Popular Places',
                'Find the most popular travel destinations.',
                Icons.location_city,
                Colors.pinkAccent,
                PopularPlacesPage(),
              ),
              _buildCard(
                context,
                'Budget Planner',
                'Plan your travel budget efficiently.',
                Icons.attach_money,
                Colors.green,
                BudgetPlannerPage(),
              ),
              _buildCard(
                context,
                'Safety Tips',
                'Essential safety tips for women travelers.',
                Icons.security,
                Colors.blue,
                SafetyTipsPage(),
              ),
              _buildCard(
                context,
                'Travel Checklist',
                'Keep track of everything you need for your trip.',
                Icons.checklist,
                Colors.orange,
                TravelChecklistPage(),
              ),
              _buildCard(
                context,
                'User Reviews',
                'Read reviews from other women travelers.',
                Icons.rate_review,
                Colors.purple,
                UserReviewsPage(),
              ),
              _buildCard(
                context,
                'Map',
                'View and explore travel maps.',
                Icons.map,
                Colors.red,
                FavoritesPage(),
              ),
              _buildCard(
                context,
                'Chatbot',
                'Get the best travel deals and advice.',
                Icons.chat,
                Colors.teal,
                TravelDealsPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String subtitle, IconData icon, Color color, Widget page) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}
