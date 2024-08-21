abstract interface class Datasource {
  Future<void> save(Map<String, dynamic> data);
  Future<void> remove(String key, String value);
  Future<List<Map<String, dynamic>>> list();
}
