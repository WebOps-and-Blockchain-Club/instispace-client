class HostelsModel {
  final List<HostelModel> hostels;

  HostelsModel({required this.hostels});

  HostelsModel.fromJson(List<dynamic> data)
      : hostels = data.map((e) => HostelModel.fromJson(e)).toList();

  List<String> getNames() {
    return hostels.map((e) => e.name).toList();
  }
}

class HostelModel {
  final String id;
  final String name;

  HostelModel({required this.id, required this.name});

  HostelModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"];
}
