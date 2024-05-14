import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key}) : super(key: key);

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  File? _imageFile;

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

  int stockNum = 0;
  int stockPrice = 0;
  String projectInfo = "";
  List<String> sizeList = ["small", 'medium', 'large'];
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new Project',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Icon(Icons.business),
            ),
          ),
          SizedBox(height: 20),
          Form(
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.numbers,
                        color: Color.fromRGBO(77, 134, 156, 1)),
                    labelText: 'Number of stocks',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      stockNum = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.money,
                        color: Color.fromRGBO(77, 134, 156, 1)),
                    labelText: 'Price of stocks',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      stockPrice = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.info,
                        color: Color.fromRGBO(77, 134, 156, 1)),
                    labelText: 'Project Info',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      projectInfo = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedSize,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.format_size,
                        color: Color.fromRGBO(77, 134, 156, 1)),
                    labelText: 'Project Size',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  items: sizeList.map((size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSize = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add your logic to save the project
                  },
                  child: Text('Save Project'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(77, 134, 156, 1),
                    minimumSize: Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
