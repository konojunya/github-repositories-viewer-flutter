import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repositories',
      home: HomePage(),
    );
  }
}

class GitHubRepository {
  final String fullName;
  final String description;
  final String language;
  final String htmlUrl;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;

  GitHubRepository.fromJson(Map<String, dynamic> json)
      : fullName = json['full_name'],
        description = json['description'],
        language = json['language'],
        htmlUrl = json['html_url'],
        stargazersCount = json['stargazers_count'],
        watchersCount = json['watchers_count'],
        forksCount = json['forks_count'];
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GitHubRepository> repositories;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GitHub Repositories"),
      ),
      body: ListView.builder(
        itemCount: repositories == null ? 0 : repositories.length,
        itemBuilder: (BuildContext context, int index) {
          final repository = repositories[index];
          return _buildCard(repository);
        },
      ),
    );
  }

  Widget _buildCard(GitHubRepository repository) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              repository.fullName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          repository.language != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                  child: Text(
                    repository.language,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                  ),
                )
              : Container(),
          repository.description != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                  child: Text(repository.description,
                      style: TextStyle(
                          fontWeight: FontWeight.w200, color: Colors.grey)),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.star),
              SizedBox(
                width: 50.0,
                child: Text(repository.stargazersCount.toString()),
              ),
              Icon(Icons.remove_red_eye),
              SizedBox(
                width: 50.0,
                child: Text(repository.watchersCount.toString()),
              ),
              Text("Fork:"),
              SizedBox(
                width: 50.0,
                child: Text(repository.forksCount.toString()),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          )
        ],
      ),
    );
  }

  Future getDate() async {
    List<GitHubRepository> list = [];
    http.Response response = await http.get(
        "https://api.github.com/users/konojunya/repos?sort=updated&per_page=100&page=1");
    List data = json.decode(response.body);
    for (var item in data) {
      list.add(GitHubRepository.fromJson(item));
    }
    setState(() {
      repositories = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }
}
