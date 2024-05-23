import 'package:carousel_slider/carousel_slider.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals/constants.dart';
import '../models/recommendations.model.dart';
import '../models/user.model.dart';
import '../network/api_service.dart';
import '../providers/user_provider.dart';
import '../widgets/navbar.dart';
import '../widgets/recommendations.dart';
import '../widgets/story_view_page.dart';

const primaryColor = Color(0xFF8761D2);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final apiService = ApiService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Recommendations? selectedRecommendation;

  late Animation<double> gap;
  late Animation<double> base;
  late Animation<double> reverse;
  late AnimationController controller;

  var model = [
    "https://images-static.nykaa.com/uploads/f5a1d948-7947-4241-a08e-caac8d991c48.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/c622c7aa-7cdb-43ba-98b7-acb48df7f7c5.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/fea188e3-9067-4c1f-a3a3-07560f60d73d.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/2f2275d3-0b85-4189-8fb3-7318ca1c3bec.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/9a4d3606-9aeb-4285-8db1-4918428a1c76.jpg?tr=w-300,cm-pad_resize",
    "https://images-static.nykaa.com/uploads/455bf3cd-82d4-4b2c-ab5d-e56491edc0f1.jpg?tr=w-300,cm-pad_resize",
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);

    gap = Tween<double>(begin: 15.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  void _loadCurrentUser() async {
    try {
      final User? user = await ApiService.getCurrentUser();

      final recommendations =
          await ApiService.getRecommendations(user?.id as String);

      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).setUser(user!);
      Provider.of<UserProvider>(context, listen: false)
          .setRecommendations(recommendations);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final recommendations =
        Provider.of<UserProvider>(context).recommendations ?? [];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.pink[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StoryViewPage(model, 0),
                            ),
                          ),
                          child: DashedCircle(
                            gapSize: 20,
                            dashes: 20,
                            color: primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 35.0,
                                backgroundImage: user?.profileImageUrl != null
                                    ? NetworkImage(user!.profileImageUrl!)
                                    : const AssetImage(
                                            "lib/assets/avatarPlaceholder.png")
                                        as ImageProvider,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'user',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Welcome to Cosmetic Advisor',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: CarouselSlider(
                      items: Constants.tips
                          .map((tip) => Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  color: Colors.pink[200],
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          tip['title'] ?? "",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          tip['description'] ?? "",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              'Подробнее',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {/* ... */},
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 150,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('lib/assets/mainBanner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Constants.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: 105,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.pink[200],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Constants.categories[index].icon,
                            size: 24,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Constants.categories[index].name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              RecommendationsBlock(recommendations!),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        onCurrentUserLoad: _loadCurrentUser,
      ),
    );
  }
}
