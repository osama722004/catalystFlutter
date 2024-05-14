import 'dart:convert';
import 'package:catalyst/home/profile.dart';
import 'package:catalyst/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:catalyst/home/project.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key? key, required this.user}) : super(key: key);
initState(){
  print(user);
}
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNum = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            if (pageNum == 0) ...[
              // Content for Home tab
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black),
                  onSubmitted: (value) {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder<List<Project>>(
                  future: fetchProjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('No projects available'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].info),
                            subtitle: Text(
                              'Size: ${snapshot.data![index].size}, Budget: ${snapshot.data![index].budget}',
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ] else if (pageNum == 1) ...[
              // Content for Profile tab

              ProfileView(user: widget.user),

            ],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: pageNum,
          selectedItemColor: Colors.blue[800],
          onTap: (index) {
            setState(() {
              print(widget.user);
              pageNum = index;
            });
          },
        ),
      ),
    );
  }

  Future<List<Project>> fetchProjects() async {
    try {
      final response = await http
          .get(Uri.parse('https://catalyst-lb6l.onrender.com/api/projects'));
      if (response.statusCode == 200) {
        List<dynamic> projectsJson = jsonDecode(response.body);
        return projectsJson.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement your search results here
    return Center(
      child: Text('Searching for $query...'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement your suggestions here
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Suggestion 1'),
          onTap: () {
            query = 'Suggestion 1';
          },
        ),
        ListTile(
          title: Text('Suggestion 2'),
          onTap: () {
            query = 'Suggestion 2';
          },
        ),
      ],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      primaryColor: Colors.blue, // Change the color as needed
    );
  }
}
