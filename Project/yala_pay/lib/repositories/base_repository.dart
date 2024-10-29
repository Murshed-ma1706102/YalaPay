abstract class BaseRepository<T> {
  List<T> getAll();
  T? getById(String id);
  void add(T item);
  void update(String id, T updatedItem);
  void delete(String id);
}
