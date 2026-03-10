import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // TODO: Replace with your actual Gemini API key
  final String _apiKey = 'YOUR_GEMINI_API_KEY'; 

  Future<String> getGeminiAIText({
    required String userTranscript,
  }) async {
    final String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=' + _apiKey;

    final String prompt = "Rewrite the following spoken thought into a clear, reflective, human journal entry. Keep the emotional tone but improve structure and clarity.\n\nText:\n$userTranscript";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String rewrittenText = data['candidates'][0]['content']['parts'][0]['text'];
        return rewrittenText;
      } else {
        print('Failed to call Gemini API: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 'Error: Could not get reflection from AI.';
      }
    } catch (e) {
      print('Exception calling Gemini API: $e');
      return 'Error: Failed to connect to AI service.';
    }
  }
}
