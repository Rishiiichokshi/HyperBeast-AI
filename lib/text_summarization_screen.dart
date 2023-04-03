import 'package:example/threedots.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';

final Color backgroundColor = Colors.white;
final Color botBackgroundColor = Color.fromARGB(255, 189, 188, 188);

class TextSummarizationScreen extends StatefulWidget {
  const TextSummarizationScreen({super.key});

  @override
  State<TextSummarizationScreen> createState() =>
      _TextSummarizationScreenState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = "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";

  var url = Uri.https("api.openai.com", "/v1/completions");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $apiKey"
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      'temperature': 0.5,
      'max_tokens': 2500,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    }),
  );

  // Do something with the response
  Map<String, dynamic> newresponse = jsonDecode(response.body);

  return utf8.decode(newresponse['choices'][0]['text'].runes.toList());
}

class _TextSummarizationScreenState extends State<TextSummarizationScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.all(7.0),
          child: Text(
            "Text Summarization",
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 24.0, color: Colors.white),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: ThreeDots(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildInput(),
                  SizedBox(
                    width: 20,
                  ),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        decoration: BoxDecoration(
          color: botBackgroundColor,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.send_rounded,
            color: Colors.black,
          ),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            setState(
              () {
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
            });
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
          },
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 13, right: 10.0),
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(255, 224, 224, 224),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(color: Colors.black),
          controller: _textController,
          decoration: const InputDecoration(
            hintText: "Ask me to write long text/Essay for you...",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  child: CircleAvatar(
                    child: Image.asset(
                      'assets/robot.png',
                      scale: 1.5,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  child: const CircleAvatar(
                    child: Icon(
                      Icons.person_outline,
                    ),
                  ),
                ),
          Flexible(
            flex: 1,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(18.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: chatMessageType == ChatMessageType.user
                      ? Colors.black
                      : botBackgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
                child: SelectableText(
                  text.trim(),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
