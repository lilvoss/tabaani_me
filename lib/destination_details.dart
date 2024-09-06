import 'package:flutter/material.dart';

class DestinationDetails extends StatefulWidget {
  final String imagePath;
  final String destinationName;

  DestinationDetails({required this.imagePath, required this.destinationName});

  @override
  _DestinationDetailsState createState() => _DestinationDetailsState();
}

class _DestinationDetailsState extends State<DestinationDetails>
    with TickerProviderStateMixin {
  late ScrollController _top3ScrollController;
  late ScrollController _experienceScrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _top3ScrollController = ScrollController();
    _experienceScrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _animationController.repeat();
    _animationController.addListener(() {
      if (_top3ScrollController.hasClients) {
        _top3ScrollController.animateTo(
          _top3ScrollController.offset + 1.0,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
      if (_experienceScrollController.hasClients) {
        _experienceScrollController.animateTo(
          _experienceScrollController.offset + 1.0,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _top3ScrollController.dispose();
    _experienceScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destinationName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  widget.imagePath,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    color: Colors.black.withOpacity(0.3),
                    child: Text(
                      'Things to do in ${widget.destinationName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Going to ${widget.destinationName} and wondering what to do? No need to worry, there are plenty of things to do in ${widget.destinationName} with a local. Join your favorite host and discover the best the city has to offer from an exclusive selection of unique experiences.',
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Top 3 Things to do in ${widget.destinationName}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Most rated experience verified and approved by Tabaani',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 250.0, // Adjust the height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _top3ScrollController,
                child: Row(
                  children: [
                    _buildCard(context, 'Local food home made', 'assets/1.png',
                        '\$50/person-1day', false),
                    _buildCard(context, 'Explore their Traditional Clothing',
                        'assets/2.png', '\$40/person-1day', true),
                    _buildCard(
                        context,
                        'Explore the city of ${widget.destinationName} and its cultures',
                        'assets/3.png',
                        '\$60/person-1day',
                        false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              color: Colors.yellow.shade100, // Light yellow color
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Prioritizing safety our experiences are always',
                      style: TextStyle(
                        color: Colors.blue.shade900, // Navy blue color
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: Text(
                      'Private & Personalized',
                      style: TextStyle(
                        color: Colors.yellow.shade800, // Darker yellow color
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: Text(
                      'No strangers, just you. Fully customize your trip to your needs',
                      style: TextStyle(
                        color: Colors.black, // Darker yellow color
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: Text(
                      'With local expert',
                      style: TextStyle(
                        color: Colors.yellow.shade800, // Darker yellow color
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: Text(
                      'From historical facts to the most up-to-date health regulations',
                      style: TextStyle(
                        color: Colors.black, // Darker yellow color
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: Text(
                      'Without the crowds',
                      style: TextStyle(
                        color: Colors.yellow.shade800, // Darker yellow color
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: Text(
                      'Experiences designed to take you away from the crowds towards authentic local spots',
                      style: TextStyle(
                        color: Colors.black, // Darker yellow color
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Experience for every interest',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Explore experiences matching your desires, so are you a:',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 250.0, // Adjust the height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _experienceScrollController,
                child: Row(
                  children: [
                    _buildCard(
                        context,
                        '${widget.destinationName} for History Buffs',
                        'assets/4.png',
                        'history buff',
                        false),
                    _buildCard(
                        context,
                        '${widget.destinationName} for Adventure Seekers',
                        'assets/5.png',
                        'Adventure',
                        true),
                    _buildCard(
                        context,
                        '${widget.destinationName} for Art Lovers',
                        'assets/6.png',
                        'Art lovers',
                        false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'All things to do in ${widget.destinationName}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          'assets/petra.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.3),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore the city of Petra and their customs',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            CircleAvatar(
                              radius: 30.0, // Size of the circular image
                              backgroundImage: AssetImage(
                                  'assets/khalil.jpg'), // Path to the circular image
                            ),
                            SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text('Connect with Khalil'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String imagePath,
      String price, bool centerText) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.8, // 80% of the screen width
      margin: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: width * 0.8, // 80% of the screen width
                height: 250.0, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black
                      .withOpacity(0.5), // Background color with opacity
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
