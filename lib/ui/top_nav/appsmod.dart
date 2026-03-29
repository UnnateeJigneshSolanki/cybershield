import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

enum _AppsFilter {
  all,
  user,
  system,
}

class _AppsPageState extends State<AppsPage> {
  List<AppInfo> _allApps = [];
  bool _loading = true;
  String? _error;
  _AppsFilter _filter = _AppsFilter.all;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final apps = await InstalledApps.getInstalledApps(true, true);

      apps.sort(
        (a, b) => (a.name ?? '')
            .toLowerCase()
            .compareTo((b.name ?? '').toLowerCase()),
      );

      if (!mounted) return;

      setState(() {
        _allApps = apps;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  bool _isSystemApp(AppInfo app) {
    final package = app.packageName ?? '';

    return package.startsWith('com.android') ||
        package.startsWith('com.google.android') ||
        package.startsWith('android');
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF00E5FF);

    Iterable<AppInfo> visible = _allApps;

    if (_filter == _AppsFilter.user) {
      visible = _allApps.where((a) => !_isSystemApp(a));
    } else if (_filter == _AppsFilter.system) {
      visible = _allApps.where((a) => _isSystemApp(a));
    }

    final visibleList = visible.toList();

    final totalUser =
        _allApps.where((a) => !_isSystemApp(a)).length;
    final totalSystem =
        _allApps.where((a) => _isSystemApp(a)).length;

    return Scaffold(
      backgroundColor: const Color(0xFF00012B),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Installed Apps',
                    style: TextStyle(
                      fontSize: 20,
                      color: accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'User: $totalUser  •  System: $totalSystem',
                    style: const TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // REPLACE the SegmentedButton SizedBox with this:
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _AppsFilter.values.map((filterType) {
                        final isSelected = _filter == filterType;
                        return GestureDetector(
                          onTap: () => setState(() => _filter = filterType),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? accent.withValues(alpha: 0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? accent : Colors.white10,
                                width: 1.5,
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                )
                              ] : [],
                            ),
                            child: Text(
                              filterType.name.toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? accent : Colors.white38,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadApps,
                color: accent,
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: accent))
                    : _error != null
                    ? ListView(children: [Center(child: Padding(padding: const EdgeInsets.only(top: 80), child: Text('Failed: $_error', style: const TextStyle(color: Colors.white70))))])
                    : visibleList.isEmpty
                    ? ListView(children: const [Center(child: Padding(padding: EdgeInsets.only(top: 80), child: Text('No apps found', style: TextStyle(color: Colors.white70))))])
                    : GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 columns for that high-tech grid look
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8, // Adjusts height of the tiles
                  ),
                  itemCount: visibleList.length,
                  itemBuilder: (context, index) {
                    final app = visibleList[index];
                    return InkWell(
                      onTap: () => app.packageName != null ? InstalledApps.startApp(app.packageName!) : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0D3A), // Midnight Blue Tiles
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (app.icon != null)
                              Image.memory(app.icon!, width: 45, height: 45)
                            else
                              const Icon(Icons.android, color: accent, size: 40),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                app.name ?? 'Unknown',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}