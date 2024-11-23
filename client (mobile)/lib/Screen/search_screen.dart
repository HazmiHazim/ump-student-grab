import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search-screen";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode for the TextField

  @override
  void initState() {
    super.initState();
    // Automatically request focus when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose FocusNode to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150.0, // Adjust the height to fit the design
        automaticallyImplyLeading: false, // Disable default back arrow
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context), // Navigate back
                ),
                Text(
                  "Search",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add left and right gaps
              child: TextField(
                focusNode: _searchFocusNode, // Assign the FocusNode
                decoration: InputDecoration(
                  hintText: "Type to search...",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search), // Add the search icon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Remove border for cleaner look
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value; // Update query as user types
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: query.isEmpty
                  ? Center(child: Text("Type something to search."))
                  : ListView.builder(
                itemCount: 10, // Example list size
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Result ${index + 1} for \"$query\""),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


