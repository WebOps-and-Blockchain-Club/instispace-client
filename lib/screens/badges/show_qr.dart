import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/graphQL/feed.dart';
import 'package:client/models/event_points.dart';
import 'package:client/models/post/main.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/card/action_buttons.dart';
import 'package:client/widgets/helpers/loading.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/text/label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import '../../themes.dart';
import '../../widgets/helpers/error.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphQL/badge.dart';

class ShowQRPage extends StatefulWidget {
  final String postId;
  const ShowQRPage({Key? key, required this.postId}) : super(key: key);

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
                variables: {'Postid': widget.postId}),
            builder: (QueryResult? result, {fetchMore, refetch}) {
              print(result);
              if (result!.isLoading && result.data == null) {
                return const Loading();
              }
              return SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:CrossAxisAlignment.center,
                    children: [
                      //Text(result!.data!['isQRActive'] ? 'true' : 'false'),
                      SizedBox(
                        width: 300,
                        child: Row(
                          children: [
                            if(result.data!['findOnePost']['pointsValue'] != null) Text('${result.data!['findOnePost']['pointsValue']} Points', style: TextStyle(fontSize: 24),),
                            IconButton(onPressed: (){
                              showDialogForQR(context, widget.postId, false, true);
                            }, icon: Icon(CustomIcons.edit))
                          ],
                        ),
                      ),
                      if (result.data!['findOnePost']['isQRActive'] == null ||
                          result.data!['findOnePost']['isQRActive'] == false)
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(height: 300, width: 300, child: Icon(Icons.image, size: 100,),),
                        )
                        
                      else
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: CachedNetworkImage(
                            imageUrl: 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${widget.postId}',
                            placeholder: (context, url)=> const Loading(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          )
                        ),
                      Mutation(
                        options: MutationOptions(document: gql(BadgeGQL().toggleIsQRActive), onCompleted: (data) {
                          refetch!();
                        },),
                        builder: (runMutation, mutationResult) {
                          print(mutationResult);
                          return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CustomElevatedButton(
                           isLoading: mutationResult!.isLoading,
                            text: result.data!['findOnePost']['isQRActive'] == true ? 'Stop' : 'Start',
                            onPressed: (){
                              
                                runMutation({
                                  'postId': widget.postId,
                                  'points': result.data!['findOnePost']['pointsValue']
                                });
                              
                          },),
                        );
                        }),
                    ]),
              );
            }));
  }
}
