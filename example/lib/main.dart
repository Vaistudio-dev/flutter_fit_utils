import 'package:example/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fit_utils/flutter_fit_utils.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final Service<User> userService = HiveService("users", User.fromModel);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.init((await getApplicationDocumentsDirectory()).path);
  await userService.repository.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                User newUser = User(name: (await userService.count()).toString());
                var id = await userService.create(newUser);
                newUser = newUser.copyWith(id: id, userId: id);
                await userService.update(newUser);
              },
              child: const Text("Add User"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: AppBar(),
                  body: Container(
                    margin: const EdgeInsets.all(12),
                    child: FutureBuilder(
                      future: userService.getAll(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView(
                            children: [
                              Text("(${snapshot.requireData.length})"),
                              for (final user in snapshot.requireData)
                                ExpansionTile(
                                  title: Text(user.name),
                                  children: [
                                    Text("ID: ${user.id}"),
                                    Text("User ID: ${user.userId}"),
                                  ],
                                ),
                            ],
                          );
                        }

                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                )));
              },
              child: const Text("View Users"),
            ),
          ],
        ),
      ),
    );
  }
}
