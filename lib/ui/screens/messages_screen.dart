import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:neptun_app/ui/screens/main_app_frame.dart';
import 'package:neptun_app/ui/viewmodels/messages_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    super.key,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<MessagesViewmodel>(context, listen: false).getMessages();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var messagesViewmodel = context.watch<MessagesViewmodel>();

    return AppFrame(
      title: Text("Messages"),
      child: Column(
        children: [
          messagesArea(messagesViewmodel, context),
        ],
      ),
    );
  }

  Flexible messagesArea(
      MessagesViewmodel messagesViewmodel, BuildContext context) {
    return Flexible(
      child: RefreshIndicator(
        onRefresh: () async => messagesViewmodel.getMessages(),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          }),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Builder(builder: (context) {
                  if (messagesViewmodel.messages.isNotEmpty) {
                    return singleMessage(messagesViewmodel, context);
                  } else {
                    return Container();
                  }
                }),
                Padding(
                  // load more button
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      messagesViewmodel.getMessages(loadMore: true);
                    },
                    child: Text("Load more"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ExpansionPanelList singleMessage(
      MessagesViewmodel messagesViewmodel, BuildContext context) {
    return ExpansionPanelList.radio(
      expandedHeaderPadding: EdgeInsets.zero,
      //materialGapSize: 5,
      children: messagesViewmodel.messages.map((message) {
        return ExpansionPanelRadio(
          hasIcon: false,
          canTapOnHeader: true,
          value: message.id,
          headerBuilder: (context, isExpanded) {
            return ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              isThreeLine: true,
              title: Text(message.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(message.sender),
                  Text(message.getDate()),
                ],
              ),
            );
          },
          body: Card(
            child: Html(
                data: message.body,
                onLinkTap: (url, attributes, element) {
                  Future.microtask(() async {
                    await launchUrl(Uri.parse(url ?? ""));
                  });
                }),
          ),
        );
      }).toList(),
    );
  }
}
