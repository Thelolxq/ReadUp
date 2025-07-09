import 'package:flutter/material.dart';
import 'package:read_up/screens/homePages/libros_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imagesList = [
    'assets/libros/libro1.jpg',
    'assets/libros/libro2.jpg',
    'assets/libros/libro3.jpg'
  ];

 

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const String user = "Ary";
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            user,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: 
      
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                "Home",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 27, 63, 154),
                ),
              ),
              Text(
                "Stayn on track",
                style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width / 2.25,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 27, 63, 154),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(102, 0, 0, 0),
                            blurRadius: 10)
                      ],
                    ),
                  ),
                  Container(
                    width: size.width / 2.25,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(102, 0, 0, 0),
                            blurRadius: 10)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle("For you"),
              _buildImageList(),
              SizedBox(height: 20),
              _buildSectionTitle("Popular"),
              _buildImageList(),
              SizedBox(height: 20),
              _buildSectionTitle("Generos"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width / 2.25,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 27, 63, 154),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(102, 0, 0, 0),
                            blurRadius: 10)
                      ],
                    ),
                    child: Center(
                        child: Text(
                      "Rom-com",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                  Container(
                    width: size.width / 2.25,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 27, 63, 154),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(102, 0, 0, 0),
                            blurRadius: 10)
                      ],
                    ),
                    child: Center(
                        child: Text(
                      "Terror",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: Color.fromARGB(255, 51, 89, 179),
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 194, 194, 194),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 27, 63, 154),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.forward_rounded, size: 30),
          color: Color.fromARGB(255, 27, 63, 154),
          style: IconButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              overlayColor: Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildImageList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagesList[index],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
