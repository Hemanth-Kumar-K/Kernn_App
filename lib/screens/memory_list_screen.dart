import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../providers/memory_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/memory_card.dart';
import 'create_memory_screen.dart';

class MemoryListScreen extends StatefulWidget {
  const MemoryListScreen({Key? key}) : super(key: key);

  @override
  _MemoryListScreenState createState() => _MemoryListScreenState();
}

class _MemoryListScreenState extends State<MemoryListScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    try {
      final isBiometricSupported = await auth.isDeviceSupported();
      if (isBiometricSupported) {
        final didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to access your memories',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
        setState(() {
          isAuthenticated = didAuthenticate;
        });
      } else {
        setState(() {
          isAuthenticated =
              true; // Allow access if biometrics are not supported
        });
      }
    } catch (e) {
      setState(() {
        isAuthenticated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Authentication Required'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Please authenticate to access this screen.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final memoryProvider = Provider.of<MemoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memories'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(turns: animation, child: child);
                    },
                    child: Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      key: ValueKey(themeProvider.themeMode),
                    ),
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme(
                      themeProvider.themeMode != ThemeMode.dark,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: memoryProvider.loadMemories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (memoryProvider.memories.isEmpty) {
            return const Center(
              child: Text(
                'No memories found.',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: memoryProvider.memories.length,
              itemBuilder: (context, index) {
                return MemoryCard(memory: memoryProvider.memories[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateMemoryScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Memory'),
      ),
    );
  }
}
