// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:sassila_mobile_ui/modeles/Individu.dart';
import 'package:sassila_mobile_ui/pages/individu_page.dart';

class _AZItem extends ISuspensionBean {
  late final String title;
  late final String tag;
  late final int id;

  _AZItem({required this.title, required this.tag, required this.id});

  @override
  String getSuspensionTag() => tag;
}

class AlphabetScrollList extends StatefulWidget {
  final List<Individu> items;

  const AlphabetScrollList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<AlphabetScrollList> createState() => _AlphabetScrollListState();
}

class _AlphabetScrollListState extends State<AlphabetScrollList> {
  List<_AZItem> azItems = [];

  @override
  void initState() {
    super.initState();
    initList(widget.items);
  }

  void initList(List<Individu> items) {
    azItems = items
        .map((item) => _AZItem(
            title: '${item.prenom} ${item.nom}',
            tag: item.prenom[0].toUpperCase(),
            id: item.id))
        .toList();

    SuspensionUtil.sortListBySuspensionTag(azItems);
    SuspensionUtil.setShowSuspensionStatus(azItems);
  }

  @override
  Widget build(BuildContext context) {
    //setState(() {});
    return AzListView(
      padding: EdgeInsets.all(16),
      data: azItems,
      itemCount: azItems.length,
      itemBuilder: (context, index) {
        final item = azItems[index];

        return _buildListItem(item);
      },
      indexHintBuilder: (context, tag) => Container(
        alignment: Alignment.center,
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        child: Text(
          tag,
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      indexBarMargin: EdgeInsets.all(10),
      indexBarOptions: IndexBarOptions(
          needRebuild: true,
          selectTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          selectItemDecoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          indexHintAlignment: Alignment.centerRight,
          indexHintOffset: Offset(-20, 0)),
    );
  }

  Widget _buildListItem(_AZItem item) {
    //final tag = item.getSuspensionTag;
    final offStage = !item.isShowSuspension;
    return Column(
      children: <Widget>[
        Offstage(
          offstage: offStage,
          child: buildHeader(item.getSuspensionTag()),
        ),
        Container(
          margin: EdgeInsets.only(right: 16),
          child: ListTile(
            title: Text(item.title),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IndividuPage(
                    id: item.id,
                    list: widget.items,
                  ),
                ),
              ),
            },
          ),
        ),
      ],
    );
  }

  Widget buildHeader(String tag) => Container(
        height: 40,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.only(left: 16),
        color: Colors.grey.shade300,
        alignment: Alignment.centerLeft,
        child: Text(
          '$tag',
          softWrap: false,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}
