import 'package:client/models/post/actions.dart';

class TicketsModel {
  final List<TicketModel> tickets;

  TicketsModel({required this.tickets});

  TicketsModel.fromJson(dynamic data)
      : tickets = (data["getAllTickets"] as List<dynamic>)
            .map((e) => TicketModel.fromJson(e))
            .toList() as List<TicketModel>;
}

class TicketModel {
  final String id;
  final String title;
  final String description;
  final String? resolveDescription;
  final LinkModel? link;
  final String updatedAt;
  final String createdAt;
  final CreatedByModel createdBy;
  final CreatedByModel? resolvedBy;
  final bool canResolve;
  final String? imageUrls;
  final List<String>? photo;

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
      this.resolvedBy,
      this.photo,
      this.resolveDescription);

  TicketModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        description = data['description'],
        canResolve = data['canResolve'],
        link = data['link'] != null
            ? LinkModel(name: 'name', link: data['link'])
            : null,
        createdAt = data['createdAt'],
        createdBy = CreatedByModel.fromJson(
          data['createdBy'],
        ),
        resolvedBy = data['resolvedBy'] != null
            ? CreatedByModel.fromJson(
                data['resolvedBy'],
              )
            : null,
        updatedAt = data['resolvedAt'],
        imageUrls = data['imageUrls'],
        resolveDescription =
            data['resolveDescription'] ?? data['resolveDescription'],
        photo = data['imageUrls'] != '' && data['imageUrls'] != null
            ? data['imageUrls'].split(' AND ')
            : null;
}
