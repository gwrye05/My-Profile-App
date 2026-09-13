import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),

          centerTitle: true,

          backgroundColor: Colors.blue,
        ),

        drawer: Drawer(
          child: Builder(
            builder: (context) {
              return ListView(
                children: [
                  const DrawerHeader(child: Text('My Profile App')),

                  ListTile(
                    title: const Text('Home'),

                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    title: const Text('My Hobbies'),

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const HobbiesScreen(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    title: const Text('Favorite Pics'),

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const FavoritePicsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),

        body: Container(
          color: Colors.pink[50],

          child: Column(
            children: [
              const SizedBox(height: 100),

              const CircleAvatar(
                radius: 42,

                backgroundColor: Colors.blue,

                child: Icon(Icons.person, size: 45, color: Colors.white),
              ),

              const SizedBox(height: 15),

              const Text(
                'Gabriel Wrye',

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),

              const Text(
                'Flutter Beginner & App Creator',

                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Icon(Icons.location_pin, color: Colors.red),

                  const Text(
                    'Warner Robins, GA, USA',

                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(width: 15),

                  const Icon(Icons.email, color: Colors.blue),

                  const Text(
                    'gwrye@gmail.com',

                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => const HobbiesScreen(),
                    ),
                  );
                },

                child: const Text('My hobbies'),
              ),

              const SizedBox(height: 10),

              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => const FavoritePicsScreen(),
                    ),
                  );
                },

                child: const Text('My favorite pics'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HobbiesScreen extends StatelessWidget {
  const HobbiesScreen({super.key});

  static const List<String> hobbies = [
    'Listening to Music',

    'Playing Video Games',

    'Photography',

    'Watching Movies',

    'Going for a Run',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Hobbies'),

        backgroundColor: Colors.blue,
      ),

      body: Container(
        color: Colors.pink[50],

        child: ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: hobbies.length,

          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),

              elevation: 1,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,

                  child: Text(
                    '${index + 1}',

                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                title: Text(
                  hobbies[index],

                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavoritePicsScreen extends StatelessWidget {
  const FavoritePicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Pics'),

        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GridView.count(
          crossAxisCount: 2,

          crossAxisSpacing: 20,

          mainAxisSpacing: 20,

          children: [
            _buildPicTile('Picture 1'),

            _buildPicTile('Picture 2'),

            _buildPicTile('Picture 3'),

            _buildPicTile('Picture 4'),
          ],
        ),
      ),
    );
  }

  Widget _buildPicTile(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(Icons.image, size: 48, color: Colors.white),

          const SizedBox(height: 8),

          Text(
            label,

            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
