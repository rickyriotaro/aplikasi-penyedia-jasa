import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'jasa.dart';
import 'detail_jasa.dart';
import 'about_developer.dart';

class JasaListView extends StatefulWidget {
  const JasaListView({Key? key}) : super(key: key);

  @override
  JasaListViewState createState() => JasaListViewState();
}

class JasaListViewState extends State<JasaListView> {
  static const String URL = 'http://192.168.1.6/kelompok7';
  late Future<List<Jasa>> result_data;
  List<Jasa> jasaList = [];
  List<Jasa> filteredJasaList = [];
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    result_data = _fetchJasa();
    searchController.addListener(_filterJasa);
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  @override
  void dispose() {
    searchController.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _filterJasa() {
    setState(() {
      filteredJasaList = jasaList.where((jasa) {
        return jasa.nama_jasa
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AboutDeveloper()),
        );
      }
    });
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Widget _buildBody() {
    if (_selectedIndex == 1) {
      return _buildSearchPage();
    }
    return _buildHomePage();
  }

  Widget _buildHomePage() {
    return FutureBuilder<List<Jasa>>(
      future: result_data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          jasaList = snapshot.data!;
          filteredJasaList = jasaList;
          return RefreshIndicator(
            onRefresh: _pullRefresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBanner(),
                  _buildJasaList(filteredJasaList),
                ],
              ),
            ),
          );
        }
        return Center(child: Text("No data available"));
      },
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      result_data = _fetchJasa();
    });
  }

  Future<List<Jasa>> _fetchJasa() async {
    var uri = Uri.parse('$URL/api/read_jasa.php');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List jsonData = jsonResponse['data'];

      List<Jasa> jasaList = jsonData.map((jasa) {
        return Jasa.fromJson(jasa);
      }).toList();

      return jasaList;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Widget _buildBanner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 150,
          child: PageView(
            controller: _pageController,
            children: <Widget>[
              _buildBannerImage('assets/images/1.png'),
              _buildBannerImage('assets/images/2.png'),
              _buildBannerImage('assets/images/3.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildJasaList(List<Jasa> jasaList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: jasaList.length,
      itemBuilder: (context, index) {
        return _buildJasaCard(jasaList[index]);
      },
    );
  }

  Widget _buildJasaCard(Jasa jasa) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        color: Color(0xFFF2F5F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return DetailJasa(data: jasa);
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Image.network(
                  "$URL/image/logo/${jasa.logo}",
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      jasa.nama_jasa,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Harga: ${jasa.harga}",
                      style: TextStyle(
                        color: Color(0xFF0F558F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F558F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            SizedBox(width: 8.0),
            Text('Jasa Polbeng'),
          ],
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF0F558F),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSearchPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _buildJasaList(filteredJasaList),
          ),
        ),
      ],
    );
  }
}
