import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ApiServices/ApiServices.dart';
import '../../Components/customAppbar.dart';
import '../HomePage.dart';

class CityCategoryPage extends StatefulWidget {
  final String City;

  const CityCategoryPage({super.key, required this.City});

  @override
  State<CityCategoryPage> createState() => _CityCategoryPageState();
}

class _CityCategoryPageState extends State<CityCategoryPage> {
  List<dynamic> _searchResults = [];

  bool _isSearching = false;

  Future<void> fetchProperties(String query) async {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (_isSearching) {
      final results = await ApiFunctions.fetchCityResults(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  Future<void> _updateSearchResults(String query) async {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (_isSearching) {
      final results = await ApiFunctions.fetchSearchResults(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchProperties(widget.City);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        IsSort: false,
        onSearch: _updateSearchResults,
        context: context, // Pass the search callback
      ),
      body: Column(
        children: [
          // / Display search results when active
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return SearchListingCard(item: result);
                },
              ),
            ),
        ],
      ),
    );
  }
}
