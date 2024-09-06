import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreDetailScreen extends StatefulWidget {
  final String imagePath;
  final String label;
  final String description;
  final List<Map<String, String>> topActivities;

  ExploreDetailScreen({
    required this.imagePath,
    required this.label,
    required this.description,
    required this.topActivities,
  });

  @override
  _ExploreDetailScreenState createState() => _ExploreDetailScreenState();
}

class _ExploreDetailScreenState extends State<ExploreDetailScreen> {
  late PageController _pageController;
  late PageController _localPageController;
  late Timer _timer;
  late Timer _localTimer;
  late List<bool> isFavorited;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _localPageController = PageController(initialPage: 0);
    _startAutoScroll();
    _startLocalAutoScroll();
    isFavorited = List<bool>.filled(widget.topActivities.length, false);
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage == 3) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startLocalAutoScroll() {
    _localTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_localPageController.hasClients) {
        int nextPage = _localPageController.page!.round() + 1;
        if (nextPage == 3) {
          nextPage = 0;
        }
        _localPageController.animateToPage(
          nextPage,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      isFavorited[index] = !isFavorited[index];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorited[index] ? 'Added to wishlist' : 'Removed from wishlist',
        ),
      ),
    );
  }

  void _showActivityDetails(Map<String, String> activity) {
    PageController imagePageController = PageController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200.0,
                  child: Stack(
                    children: [
                      PageView(
                        controller: imagePageController,
                        children: List.generate(3, (index) {
                          return Image.asset(
                            activity['image']!,
                            fit: BoxFit.cover,
                            width: 300.0,
                          );
                        }),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return GestureDetector(
                              onTap: () {
                                imagePageController.animateToPage(
                                  index,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Image.asset(
                                  activity['image']!,
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  activity['title']!,
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  activity['description']!,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Cost: ${activity['cost']}',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _localTimer.cancel();
    _pageController.dispose();
    _localPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.label,
          style: GoogleFonts.roboto(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Image.asset(widget.imagePath),
          SizedBox(height: 20),
          Text(
            widget.label,
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            widget.description,
            style: GoogleFonts.roboto(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            'Top Activities',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.topActivities.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 300.0,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            widget.topActivities[index]['image']!,
                            fit: BoxFit.cover,
                            height: 200.0,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.topActivities[index]['name']!,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Container(
            color: Color(0xFFF8F8F8),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prioritizing safety our experiences are always',
                  style: GoogleFonts.roboto(
                    color: Colors.blueGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Private & personalized',
                  style: GoogleFonts.roboto(
                    color: Color(0xFFFFB700),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'No strangers, just you. Fully customize your trip to your needs.',
                  style: GoogleFonts.roboto(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  'With a local expert',
                  style: GoogleFonts.roboto(
                    color: Color(0xFFFFB700),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'From historical facts to the most up-to-date health regulations.',
                  style: GoogleFonts.roboto(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  'Without the crowds',
                  style: GoogleFonts.roboto(
                    color: Color(0xFFFFB700),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Experiences designed to take you away from the crowds towards authentic local spots.',
                  style: GoogleFonts.roboto(fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Experiences for every interest',
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Explore experiences matching your desires, so are you a:',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 350.0,
            child: PageView(
              controller: _pageController,
              children: [
                _buildExperienceCard(
                  context,
                  'assets/tozeur.jpg',
                  'Bike Tour for',
                  'Adventures',
                  'Hiking - Wildlife & Nature - Camping - Day Trips...',
                ),
                _buildExperienceCard(
                  context,
                  'assets/petra.jpg',
                  'Cultural Tour for',
                  'History Buffs',
                  'Museums - Ancient Ruins - Historical Sites...',
                ),
                _buildExperienceCard(
                  context,
                  'assets/dubai.jpg',
                  'Food Tour for',
                  'Gastronomes',
                  'Local Cuisine - Street Food - Gourmet Experiences...',
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'All things to do in (that activity)',
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildActivityList(context),
          SizedBox(height: 20),
          Text(
            'Explore with a local of your choice',
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Learn about their personal stories, and find out how you can explore Marrakech together',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 350.0,
            child: PageView(
              controller: _localPageController,
              children: _buildLocalCards(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(BuildContext context, String imagePath,
      String title, String subtitle, String description) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              imagePath,
              height: 350.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    List<Map<String, String>> activities = [
      {
        'title': 'Bike ride at Bidda Park (Center of Doha)',
        'description': 'Walking tour',
        'cost': '\$25/person - 2-3 Hour',
        'image': 'assets/2.png',
        'avatar': 'assets/ayoub.jpg',
      },
      {
        'title': 'Try local cuisine',
        'description': 'Taste the delicious local dishes and street food.',
        'cost': '\$15/person - 1 Hour',
        'image': 'assets/1.png',
        'avatar': 'assets/bechir.jpg',
      },
      {
        'title': 'Hiking in nature',
        'description': 'Enjoy scenic hikes through beautiful landscapes.',
        'cost': '\$20/person - 4 Hour',
        'image': 'assets/camp.jfif',
        'avatar': 'assets/fares.jpg',
      },
    ];

    return Column(
      children: activities.map((activity) {
        int index = activities.indexOf(activity);
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: Image.asset(
                      activity['image']!,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => _showActivityDetails(activity),
                          child: Icon(Icons.visibility, color: Colors.white),
                        ),
                        SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () => _toggleFavorite(index),
                          child: Icon(
                            isFavorited[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                isFavorited[index] ? Colors.red : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(activity['avatar']!),
                ),
                title: Text(
                  activity['description']!,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title']!,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      activity['cost']!,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildLocalCards() {
    List<Map<String, String>> locals = [
      {
        'name': 'Ayoub',
        'role': 'Platform Admin',
        'image': 'assets/ayoub.jpg',
      },
      {
        'name': 'Khalil',
        'role': 'Full of life',
        'image': 'assets/khalil.jpg',
      },
      {
        'name': 'Fares',
        'role': 'Explorer',
        'image': 'assets/fares.jpg',
      },
      // Add more locals here
    ];

    return locals.map((local) {
      return Container(
        width: 200,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  local['image']!,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Hello I am',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        local['name']!,
                        style: GoogleFonts.roboto(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        local['role']!,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Connect with'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
