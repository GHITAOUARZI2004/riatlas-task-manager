import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/category.dart';

class CategoryDialog extends StatefulWidget {
  final Category? category;
  final Function(Category) onSave;

  const CategoryDialog({super.key, this.category, required this.onSave});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _nameController = TextEditingController();
  late IconData _selectedIcon;
  late Color _selectedColor;

  // Custom curated list of adorable shapes
  final List<IconData> _cuteIcons = [
    Icons.favorite,         // Heart
    Icons.auto_awesome,     // Sparkles
    Icons.cruelty_free,     // Cute Bunny
    Icons.cake,             // Sweet Cake
    Icons.icecream,         // Ice Cream
    Icons.cookie,           // Cookie
    Icons.pets,             // Paw Print
    Icons.flutter_dash,     // Cute Bird
    Icons.face_3,           // Princess Hair/Bow reference
    Icons.spa,              // Sakura Flower
    Icons.music_note,       // Melodies
    Icons.coffee,           // Warm Tea Cup
    Icons.celebration,      // Party Bows
    Icons.shopping_bag,     // Cute Tote bag
    Icons.nightlight_round, // Dreamy Moon
    Icons.wb_sunny,         // Happy Sun
  ];

  // Expanded collection of dreamy pastel candy colors
  final List<Color> _cuteColors = [
    const Color(0xFFFF9EAA), // Strawberry Milk Pink
    const Color(0xFFFFD0EC), // Soft Cotton Candy Blossom
    const Color(0xFFB1AFFF), // Dreamy Pastel Lavender
    const Color(0xFFC1F0C2), // Fresh Sweet Mint
    const Color(0xFFFFD39A), // Cozy Peach Apricot
    const Color(0xFF9AD0EC), // Clear Sky Baby Blue
    const Color(0xFFFEE440), // Sunny Lemon Drop
    const Color(0xFFE8A0BF), // Deep Tulip Pink
  ];

  @override
  void initState() {
    super.initState();
    _selectedIcon = _cuteIcons.first;
    _selectedColor = _cuteColors.first;

    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedIcon = _iconFromName(widget.category!.iconName);
      _selectedColor = Color(widget.category!.colorValue);
    }
  }

  IconData _iconFromName(String name) {
    final map = <String, IconData>{
      'favorite': Icons.favorite, 'auto_awesome': Icons.auto_awesome,
      'cruelty_free': Icons.cruelty_free, 'cake': Icons.cake,
      'icecream': Icons.icecream, 'cookie': Icons.cookie,
      'pets': Icons.pets, 'flutter_dash': Icons.flutter_dash,
      'face_3': Icons.face_3, 'spa': Icons.spa,
      'music_note': Icons.music_note, 'coffee': Icons.coffee,
      'celebration': Icons.celebration, 'shopping_bag': Icons.shopping_bag,
      'nightlight_round': Icons.nightlight_round, 'wb_sunny': Icons.wb_sunny,
    };
    return map[name] ?? Icons.favorite;
  }

  String _iconToName(IconData icon) {
    final map = <IconData, String>{
      Icons.favorite: 'favorite', Icons.auto_awesome: 'auto_awesome',
      Icons.cruelty_free: 'cruelty_free', Icons.cake: 'cake',
      Icons.icecream: 'icecream', Icons.cookie: 'cookie',
      Icons.pets: 'pets', Icons.flutter_dash: 'flutter_dash',
      Icons.face_3: 'face_3', Icons.spa: 'spa',
      Icons.music_note: 'music_note', Icons.coffee: 'coffee',
      Icons.celebration: 'celebration', Icons.shopping_bag: 'shopping_bag',
      Icons.nightlight_round: 'nightlight_round', Icons.wb_sunny: 'wb_sunny',
    };
    return map[icon] ?? 'favorite';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return Dialog(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: const BorderSide(color: Color(0xFFFF9EAA), width: 3.5), 
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 640),
        child: Stack(
          children: [
            // 1. Dreamy Pastel Gradient Backdrop
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFF0F5), Colors.white, Color(0xFFEBF4FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // 2. Sparkly Floating Magical Decor Layer
            ...List.generate(4, (index) {
              final alignments = [
                Alignment.topLeft, Alignment.topRight, 
                Alignment.bottomLeft, Alignment.bottomRight
              ];
              return Positioned.fill(
                child: Align(
                  alignment: alignments[index],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const Icon(Icons.auto_awesome, color: Color(0xFFFFD0EC), size: 24)
                        .animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.3, 1.3), duration: (1000 + index * 300).ms)
                        .blur(begin: const Offset(0, 0), end: const Offset(1.5, 1.5)),
                  ),
                ),
              );
            }),

            // 3. Main Dynamic Content Sheet
            Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview Card Header Block
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _selectedColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedColor.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Icon(_selectedIcon, color: _selectedColor, size: 32)
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .shake(hz: 2, curve: Curves.easeInOut, duration: 1500.ms),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEditing ? 'Edit Category' : 'New Category',
                                style: const TextStyle(
                                  fontSize: 22, 
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE8A0BF),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Create something wonderful ✨',
                                style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Category text editor field
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Name your category...',
                        prefixIcon: Icon(_selectedIcon, color: _selectedColor),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.9),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: const Color(0xFFFF9EAA).withValues(alpha: 0.3), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: _selectedColor, width: 2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cute Grid Picker Section
                    Row(
                      children: const [
                        Icon(Icons.star_rounded, size: 18, color: Color(0xFFFF9EAA)),
                        SizedBox(width: 4),
                        Text('Pick an Icon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFE8A0BF))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _cuteIcons.map((icon) {
                        final isSelected = _selectedIcon == icon;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIcon = icon),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: isSelected ? _selectedColor.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? _selectedColor : Colors.grey.shade100,
                                width: 2.5,
                              ),
                            ),
                            child: Icon(
                              icon,
                              color: isSelected ? _selectedColor : Colors.grey.shade400,
                              size: 20,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Color Palettes Selection Blocks
                    Row(
                      children: const [
                        Icon(Icons.palette_outlined, size: 16, color: Color(0xFFFF9EAA)),
                        SizedBox(width: 4),
                        Text('Pick a Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFE8A0BF))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _cuteColors.map((color) {
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected ? color.withValues(alpha: 0.5) : color.withValues(alpha: 0.15),
                                  blurRadius: isSelected ? 10 : 4,
                                  spreadRadius: isSelected ? 2 : 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white, size: 18)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Navigation Action Control Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFFD0EC), width: 1.5),
                              foregroundColor: const Color(0xFFFF9EAA),
                              backgroundColor: Colors.white.withValues(alpha: 0.6),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final name = _nameController.text.trim();
                              if (name.isEmpty) return;
                              final category = Category(
                                name: name,
                                iconName: _iconToName(_selectedIcon),
                                colorValue: _selectedColor.toARGB32(),
                              );
                              await widget.onSave(category);
                              if (context.mounted) Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF9EAA), Color(0xFFE8A0BF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF9EAA).withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  isEditing ? 'Save ✨' : 'Add ✨',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          )
                          // Triple Custom Button Animation Pipeline: Pulse + Shimmer Effect loop
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.03, 1.03), duration: 1200.ms, curve: Curves.easeInOut)
                          .then()
                          .shimmer(delay: 1500.ms, duration: 1000.ms, color: Colors.white30),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}