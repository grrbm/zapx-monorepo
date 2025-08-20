class SelectedLocationModel {
  final int id;
  final String name;

  SelectedLocationModel({required this.id, required this.name});

  // Override equality and hashCode to prevent duplicate entries in Set
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SelectedLocationModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
