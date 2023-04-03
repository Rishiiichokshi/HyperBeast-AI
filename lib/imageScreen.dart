import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  TextEditingController inputText = TextEditingController();
  String apikey = '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';
  String url = 'https://api.openai.com/v1/images/generations';
  String? image;

  Future<void> getAIImage() async {
    if (inputText.text.isNotEmpty) {
      var data = {"prompt": inputText.text, "n": 1, "size": "256x256"};

      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer ${apikey}",
            "Content-type": "application/json"
          },
          body: jsonEncode(data));

      var jsonResponse = jsonDecode(res.body);

      image = jsonResponse['data'][0]['url'];
      setState(() {});
    } else {
      print("Enter Something");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          'Generate Images',
          style: TextStyle(fontFamily: "Poppins", fontSize: 24.0),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image != null
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: Colors.black, width: 6)),
                      child: Image.network(
                        image!,
                        width: 256,
                        height: 256,
                      ),
                    )
                  : Container(
                      child: Text("Please Enter Text To Generate AI Image"),
                      padding: EdgeInsets.only(bottom: 23),
                    ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: inputText,
                  decoration: InputDecoration(
                    hintText: "Ask me to Generate Images for you...",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 195, 193, 193)),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  getAIImage();
                  inputText.clear();
                },
                child: Text("Submit"),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     if (image != null) {
              //       await GallerySaver.saveImage(image!, albumName: "chat");
              //     } else {
              //       print("No image to download");
              //     }
              //   },
              //   child: Text("Download"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
