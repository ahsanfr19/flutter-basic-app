import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF075E54),  // WhatsApp Dark Green
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> contactNames;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    contactNames = List.generate(20, (index) => getRandomName());
  }

  String getRandomName() {
    List<String> names = [
      "Alice",
      "Bob",
      "Charlie",
      "David",
      "Emma",
      "Frank",
      "Grace",
      "Hank",
      "Ivy",
      "Jack",
      "Katie",
      "Liam",
      "Mia",
      "Noah",
      "Olivia",
      "Peter",
      "Quinn",
      "Ryan",
      "Sofia",
      "Tom",
    ];

    return names[Random().nextInt(names.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchContactsScreen(contactNames: contactNames)),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.message),
              text: "Messages",
            ),
            Tab(
              icon: Icon(Icons.image),
              text: "Status",
            ),
            Tab(
              icon: Icon(Icons.call),
              text: "Calls",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Messages Tab
          ListView.builder(
            itemCount: contactNames.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MessageScreen(contactIndex: index, contactNames: contactNames)),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(contactNames[index][0], style: TextStyle(color: Colors.white)),
                ),
                title: Row(
                  children: [
                    Icon(Icons.account_circle),
                    SizedBox(width: 8),
                    Text(contactNames[index]),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.mail),
                    SizedBox(width: 8),
                    Text("Last message from ${contactNames[index]}"),
                  ],
                ),
              );
            },
          ),

          // Status Tab
          Center(
            child: Text("Status Tab 📷"),
          ),

          // Calls Tab
          ListView.builder(
            itemCount: 5, // Replace with the actual number of calls
            itemBuilder: (context, index) {
              Icon callIcon;
              Color callColor;

              // Replace with your logic for determining call type and color
              if (index % 2 == 0) {
                callIcon = Icon(Icons.call_received);
                callColor = Colors.green;
              } else {
                callIcon = Icon(Icons.call_missed);
                callColor = Colors.red;
              }

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: callColor,
                  child: callIcon,
                  foregroundColor: Colors.white,
                ),
                title: Text("Contact Name $index"),
                subtitle: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 8),
                    Text("Call time and date $index"),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessageContactsScreen(contactNames: contactNames)),
          );
        },
        child: Icon(Icons.message),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class MessageScreen extends StatelessWidget {
  final int contactIndex;
  final List<String> contactNames;

  const MessageScreen({Key? key, required this.contactIndex, required this.contactNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${contactNames[contactIndex]}"),
      ),
      body: Center(
        child: Text("Chat messages with ${contactNames[contactIndex]}"),
      ),
    );
  }
}

class MessageContactsScreen extends StatelessWidget {
  final List<String> contactNames;

  const MessageContactsScreen({Key? key, required this.contactNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Contact to Message"),
      ),
      body: ListView.builder(
        itemCount: contactNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageScreen(contactIndex: index, contactNames: contactNames)),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(contactNames[index][0], style: TextStyle(color: Colors.white)),
            ),
            title: Row(
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 8),
                Text(contactNames[index]),
              ],
            ),
            subtitle: Row(
              children: [
                Icon(Icons.mail),
                SizedBox(width: 8),
                Text("Last message from ${contactNames[index]}"),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SearchContactsScreen extends StatefulWidget {
  final List<String> contactNames;

  const SearchContactsScreen({Key? key, required this.contactNames}) : super(key: key);

  @override
  _SearchContactsScreenState createState() => _SearchContactsScreenState();
}

class _SearchContactsScreenState extends State<SearchContactsScreen> {
  late List<String> searchResults;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchResults = widget.contactNames;
  }

  void _searchContacts(String query) {
    setState(() {
      searchResults = widget.contactNames
          .where((contact) => contact.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _searchContacts,
          decoration: InputDecoration(
            hintText: "Search contacts",
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageScreen(contactIndex: index, contactNames: searchResults)),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(searchResults[index][0], style: TextStyle(color: Colors.white)),
            ),
            title: Row(
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 8),
                Text(searchResults[index]),
              ],
            ),
            subtitle: Row(
              children: [
                Icon(Icons.mail),
                SizedBox(width: 8),
                Text("Last message from ${searchResults[index]}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
