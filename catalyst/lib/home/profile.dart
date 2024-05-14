import 'dart:io';

import 'package:catalyst/home/add_project.dart';
import 'package:catalyst/home/project.dart';
import 'package:catalyst/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  final User user;

  ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  File? _imageFile;
  int _selectedIndex = 0;
  List<dynamic> projects = [];
  late List wid; // Declare wid as a late variable

  @override
  void initState() {
    super.initState();
    projects = widget.user.projects ?? [];
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _selectedIndex = 1; // Set default selected index to 0 (projects)

    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      setState(() {
        _imageFile = null;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 88),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 50,
            child: widget.user.image != null && widget.user.image!.isNotEmpty
                ? ClipOval(child: Image.network(widget.user.image!, fit: BoxFit.cover, width: 100, height: 100))
                : Icon(Icons.person, size: 50),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              color: Colors.black87,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          '${widget.user.firstName ?? 'First Name'} ${widget.user.lastName ?? 'Last Name'}',
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          widget.user.email ?? 'Email',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Investments',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
        SizedBox(height: 10),
        _selectedIndex == 0
            ? projects.isNotEmpty
            ? GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 0.75,
          ),
          itemCount: projects.length + 1, // Add 1 for the GestureDetector
          itemBuilder: (context, index) {
            if (index < projects.length) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${widget.user.firstName ?? ''} ${widget.user.lastName ?? ''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.more_horiz),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(projects[index]['info'] ?? 'No Info'),
                      ),
                      if (projects[index]['img'] != null)
                        Image.network(
                          projects[index]['img'],
                          fit: BoxFit.cover,
                          height: 100,
                        )
                      else
                        Image.asset(
                          'assets/images/Animation - 1715359820798.json',
                        ),
                    ],
                  ),
                ),
              );
            } else {
              // This is the last item, add the GestureDetector
              return GestureDetector(
                onTap: () {
                  // Handle the tap on the last item
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      'Load More',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        )
            : GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => AddProject(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(seconds: 1)),
                  (route) => false,
            );
          },
          child: Card(
            margin: EdgeInsets.all(8),
            child: Center(
              child: Text(
                'Add Project',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        )
            : Text("investment"),
      ],
    );
  }
}
