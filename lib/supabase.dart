import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://wwnegkiwhowfwrldrqsb.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind3bmVna2l3aG93ZndybGRycXNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU1MTI1MjEsImV4cCI6MjA3MTA4ODUyMX0.sDHgmKjrCvd2IX-9CQWBVs2OATU3XfUMWTzjCWMM4-A';

  static Future<void> initialize() async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
