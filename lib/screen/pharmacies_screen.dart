// lib/screen/pharmacies_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme_helper.dart';
import '../widgets/notification_button.dart';

class PharmaciesScreen extends StatefulWidget {
  const PharmaciesScreen({super.key});

  @override
  State<PharmaciesScreen> createState() => _PharmaciesScreenState();
}

class _PharmaciesScreenState extends State<PharmaciesScreen> {
  static const Color primary = Color(0xFF2EC4B6);
  final _searchCtrl = TextEditingController();
  String _search = '';

  final List<Map<String, String>> _pharmacies = [];

  @override
  Widget build(BuildContext context) {
    final bg = TH.bg(context);
    final card = TH.card(context);
    final text = TH.text(context);

    final filtered = _pharmacies
        .where((p) =>
            p['name']!.toLowerCase().contains(_search.toLowerCase()) ||
            p['address']!.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Pharmacies',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [NotificationButton()],
      ),
      body: Column(
        children: [
          // Search banner
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search pharmacies...',
                    hintStyle: const TextStyle(color: Colors.white60),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = '');
                            })
                        : null,
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton.icon(
                      onPressed: () => _openMaps('pharmacy near me'),
                      icon: const Icon(Icons.near_me_rounded, color: primary),
                      label: const Text('Find Nearby',
                          style: TextStyle(color: primary)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                        child: OutlinedButton.icon(
                      onPressed: () => _openMaps('pharmacy Dire Dawa Ethiopia'),
                      icon: const Icon(Icons.map_rounded, color: Colors.white),
                      label: const Text('Open Maps',
                          style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${filtered.length} pharmacies found',
                  style: TextStyle(color: TH.subText(context), fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final p = filtered[index];
                final isOpen = p['hours'] == 'Open 24h';
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.local_pharmacy_rounded,
                                  color: primary, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['name']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: text)),
                                  const SizedBox(height: 2),
                                  Text(p['address']!,
                                      style: TextStyle(
                                          color: TH.subText(context),
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isOpen
                                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(p['hours']!,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isOpen
                                          ? const Color(0xFF4CAF50)
                                          : Colors.orange)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: OutlinedButton.icon(
                              onPressed: () => _call(p['phone']!),
                              icon: const Icon(Icons.phone_rounded,
                                  size: 16, color: primary),
                              label: const Text('Call',
                                  style: TextStyle(color: primary)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: primary),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            )),
                            const SizedBox(width: 8),
                            Expanded(
                                child: ElevatedButton.icon(
                              onPressed: () => _openMaps(p['name']!),
                              icon: const Icon(Icons.directions,
                                  size: 16, color: Colors.white),
                              label: const Text('Directions',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _call(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openMaps(String query) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/${Uri.encodeComponent(query)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
