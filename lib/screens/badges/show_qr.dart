import 'package:client/graphQL/feed.dart';
import 'package:client/models/post/main.dart';
import 'package:client/widgets/card/action_buttons.dart';
import 'package:client/widgets/helpers/loading.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/text/label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes.dart';
import '../../widgets/helpers/error.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphQL/badge.dart';

class ShowQRPage extends StatefulWidget {
  final PostModel post;
  const ShowQRPage({Key? key, required this.post}) : super(key: key);

  @override
  State<ShowQRPage> createState() => _ShowQRPageState();
}

class _ShowQRPageState extends State<ShowQRPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomAppBar(
            title: 'Show QR',
          ),
          leading: CustomIconButton(
            icon: Icons.arrow_back,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          automaticallyImplyLeading: false,
        ),
        body: Query(
            options: QueryOptions(
                document: gql(FeedGQL().findOnePost),
                variables: {'Postid': widget.post.id}),
            builder: (QueryResult? result, {fetchMore, refetch}) {
              print(result);
              if (result!.isLoading && result.data == null) {
                return const Loading();
              }
              return SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Text(result!.data!['isQRActive'] ? 'true' : 'false'),

                      if (result.data!['findOnePost']['isQRActive'] == null ||
                          result.data!['findOnePost']['isQRActive'] == false)
                        Container(
                          height: 50,
                          child: Text('Event is not active'),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.network(
                              'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${widget.post.id}'),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GamifyPostButton(
                            postId: widget.post.id,
                            isQRActive: result.data!['findOnePost']
                                ['isQRActive'],
                            pointsValue: result.data!['findOnePost']
                                ['pointsValue']),
                      ),
                    ]),
              );
            }));
  }
}
