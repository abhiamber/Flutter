import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter APP',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> data = [];
  bool isLoading = false;
  bool hasError = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http
          .get(Uri.parse('https://odd-lime-bandicoot-tutu.cyclic.app/prod'));
      // print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Welcome To The List Item')),
        ),
        // body: Container(),r
        body: RefreshIndicator(
          onRefresh: refreshData,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
                  ? const Center(child: Text('Error fetching data.'))
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var item = data[index];
                        var fullName = item['name']['title'] +
                            " " +
                            item['name']['first'] +
                            " " +
                            item['name']['last'];
                        var email = item['email'];
                        var city = item['location']['city'];
                        var name = item['nat'];
                        // print(fullName);
                        // print(email);
                        // print(profileUrl);

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 209, 13, 176),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    name.toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          140,
                                      child: Text(
                                        fullName,
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    email.toString(),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    city.toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 172, 171, 171),
                                        fontSize: 15),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            refreshData();
          },
          child: const Icon(Icons.refresh),
        ));
  }
}
