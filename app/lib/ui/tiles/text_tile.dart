import 'package:flutter/material.dart';

import 'package:clipboard_manager/clipboard_manager.dart';

import 'package:mogicians_manual/data/list_items.dart';
import 'package:mogicians_manual/service/toast_util.dart';

class TextTile extends StatefulWidget {
  TextTile(this.item, this.isNovember);

  final TextItem item;
  final bool isNovember;

  @override
  State createState() => _TextTileState();
}

class _TextTileState extends State<TextTile> with ToastUtil {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Card(
      shape: BeveledRectangleBorder(),
      color: Theme.of(context).cardColor,
      elevation: 2,
      child: InkWell(
          onTap: () {
            setState(() {
              item.isExpanded = !item.isExpanded;
            });
          },
          onLongPress: () {
            if (item.isExpanded) {
              _copyToClipboard(context, item.title, item.body);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _generateChildren(),
          )),
      margin: EdgeInsets.all(0),
    );
  }

  List<Widget> _generateChildren() {
    final item = widget.item;
    List<Widget> contents = [];
    contents.add(Text(
      item.title,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: 1.1,
          fontSize: 18
      ),
    ));
    if (item.isExpanded) {
      contents.add(SizedBox(height: 8));
      contents.add(
        Text(
          item.body,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              letterSpacing: 1.02,
              height: 1.05,
              fontSize: 16,
          ),
        ),
      );
    }

    List<Widget> children = [];

    children.add(Container(
      color: Theme.of(context).dialogBackgroundColor,
      height: 1,
    ));

    children.add(Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: contents,
      ),
    ));

    return children;
  }

  void _copyToClipboard(BuildContext context, String title, String body) {
    String content = '【$title】\n$body';
    String message = "已复制到剪贴板";
    if (widget.isNovember) message += "。阿门……";
    ClipboardManager.copyToClipBoard(content).then((result) {
      showToast(context, message);
    });
  }
}