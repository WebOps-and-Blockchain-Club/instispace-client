class HostelsModel {
  final List<HostelModel> hostels;

  HostelsModel({required this.hostels});

  HostelsModel.fromJson(List<dynamic> data)
      : hostels = data.map((e) => HostelModel.fromJson(e)).toList();

  List<String> getNames() {
    return hostels.map((e) => e.name).toList();
  }

  List<String> getHostelIds() {
    return hostels.map((e) => e.id).toList();
  }

  String? getId(String? name) {
    String? id;
    hostels.forEach(((e) {
      if (e.name == name) id = e.id;
    }));
    return id;
  }

  String? getName(String? id) {
    String? name;
    hostels.forEach(((e) {
      if (e.id == id) name = e.name;
    }));
    return name;
  }

  bool contains(HostelModel hostel) {
    bool isContain = false;
    for (var element in hostels) {
      if (element.id == hostel.id) isContain = true;
    }
    return isContain;
  }

  void add(HostelModel hostel) {
    hostels.add(hostel);
  }

  void remove(HostelModel hostel) {
    hostels.removeWhere((element) => element.id == hostel.id);
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
