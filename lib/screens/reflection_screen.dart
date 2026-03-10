import 'package:flutter/material.dart';

class ReflectionScreen extends StatelessWidget {
  final String originalText;
  final String aiRewrittenText;

  const ReflectionScreen({
    super.key,
    required this.originalText,
    required this.aiRewrittenText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reflection'),
        backgroundColor: Colors.pink.shade100, // Pastel pink
        elevation: 0, // No shadow for app bar
      ),
      body: Container(
        color: Colors.purple.shade50, // Light lavender background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  // Original Speech Card
                  _buildReflectionCard(
                    context,
                    title: 'Your Spoken Thought',
                    content: originalText,
                    cardColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  // AI Rewritten Reflection Card
                  _buildReflectionCard(
                    context,
                    title: 'AI Rewritten Reflection',
                    content: aiRewrittenText,
                    cardColor: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildActionButton(
                  context,
                  icon: Icons.save,
                  label: 'Save',
                  onPressed: () {
                    // TODO: Implement saving logic
                    print('Save button pressed');
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.edit,
                  label: 'Edit',
                  onPressed: () {
                    // TODO: Implement edit logic
                    print('Edit button pressed');
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.share,
                  label: 'Share',
                  onPressed: () {
                    // TODO: Implement share logic
                    print('Share button pressed');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReflectionCard(
    BuildContext context, {
    required String title,
    required String content,
    required Color cardColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 4, // Soft shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [+
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label, // Unique tag for each FloatingActionButton
          onPressed: onPressed,
          backgroundColor: Colors.pink.shade200,
          elevation: 3,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
