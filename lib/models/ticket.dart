import 'package:client/models/post/actions.dart';

class TicketsModel {
  final List<TicketModel> tickets;
  final int total;

  TicketsModel({required this.tickets, required this.total});

  TicketsModel.fromJson(dynamic data)
      : tickets = (data["findtickets"]["list"] as List<dynamic>)
            .map((e) => TicketModel.fromJson(e))
            .toList() as List<TicketModel>,
        total = data["findtickets"]['total'];
}

class TicketModel {
  final String id;
  final String title;
  final String description;
  final LinkModel? link;
  final String updatedAt;
  final String createdAt;
  final CreatedByModel createdBy;
  final CreatedByModel resolvedBy;
  final bool canResolve;
  final String? imageUrls;

  TicketModel(
      this.id,
      this.title,
      this.description,
      this.link,
      this.updatedAt,
      this.createdAt,
      this.createdBy,
      this.canResolve,
      this.imageUrls,
      this.resolvedBy);

  TicketModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        description = data['description'],
        canResolve = data['canResolve'],
        link = data['link'],
        createdAt = data['createdAt'],
        createdBy = CreatedByModel.fromJson(
          data['createdBy'],
        ),
        resolvedBy = CreatedByModel.fromJson(
          data['resolvedBy'],
        ),
        updatedAt = data['updatedAt'],
        imageUrls = data['imageUrls'];
}
