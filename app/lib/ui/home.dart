import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mogicians_manual/ui/tabs.dart';
import 'package:mogicians_manual/data/models.dart';
import 'package:mogicians_manual/service/theme_provider.dart';
import 'package:mogicians_manual/service/toast_util.dart';

class HomePage extends StatefulWidget {
  final String title;
  final bool isNovember;
  final ThemeMode themeMode;
  final VoidCallback onThemeModeChanged;

  HomePage({
    Key key,
    this.isNovember,
    this.title,
    @required this.themeMode,
    @required this.onThemeModeChanged,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ToastUtil {
  int _selectedIndex = 0;

  var _shuoModel = TabShuoModel();
  var _xueModel = TabXueModel();
  var _douModel = TabDouModel();
  var _changModel = TabChangModel();
  var _genModel = TabGenModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(widget.isNovember ? MdiIcons.candle : MdiIcons.glasses),
        title: Text(widget.title),
        actions: _getAppbarActions(),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: _getTab(),
      ),
      bottomNavigationBar: _getBottomNav(),
    );
  }

  Widget _getTab() {
    final isNov = widget.isNovember;
    switch (_selectedIndex) {
      case 0:
        return ScopedModel<TabShuoModel>(
          model: _shuoModel,
          child: TabShuo(isNov),
        );
      case 1:
        return ScopedModel<TabXueModel>(
          model: _xueModel,
          child: TabXue(isNov),
        );
      case 2:
        return ScopedModel<TabDouModel>(
          model: _douModel,
          child: TabDou(isNov),
        );
      case 3:
        return ScopedModel<TabChangModel>(
          model: _changModel,
          child: TabChang(isNov, _selectMusicItem),
        );
      case 4:
        return ScopedModel<TabGenModel>(
          model: _genModel,
          child: TabGen(isNov),
        );
      default:
        throw Exception('Invalid index!');
    }
  }

  List<Widget> _getAppbarActions() {
    final options = <ActionOption>[

      ActionOption(
        title: '源码',
        iconData: MdiIcons.github,
        firstUrl:
            'https://github.com/naco-siren/mogicians-manual/tree/master/app/README.md',
      ),
      ActionOption(
        title: '反馈',
        iconData: Icons.bug_report,
        firstUrl: 'https://github.com/naco-siren/mogicians-manual/issues',
      ),
      ActionOption(
        title: '开发者',
        iconData: MdiIcons.guyFawkesMask,
        firstUrl: 'zhihu://people/naco_siren',
        secondUrl: 'https://www.zhihu.com/people/naco_siren',
      ),
    ];

    if (!widget.isNovember) {
      options.insert(0, ActionOption(
        title: '夜间模式',
        iconData: MyThemeDataProvider.getBrightnessIcon(widget.themeMode),
      ));
    }

    return <Widget>[
      IconButton(
        icon: Icon(options[0].iconData),
        onPressed: widget.onThemeModeChanged,
      ),
      IconButton(
        icon: Icon(options[1].iconData),
        onPressed: () => _launchUrl(options[1]),
      ),
      PopupMenuButton<ActionOption>(
        itemBuilder: (BuildContext context) =>
          options.skip(2).map((ActionOption option) {
            return PopupMenuItem<ActionOption>(
              value: option,
              child: Text(option.title),
            );
          }).toList(),
        onSelected: (option) => _launchUrl(option),
      ),
    ];
  }

  _launchUrl(ActionOption option) async {
    final firstUri = Uri.parse(option.firstUrl);
    if (await canLaunchUrl(firstUri)) {
      return await launchUrl(firstUri);
    }

    final secondUri = Uri.parse(option.secondUrl);
    if (secondUri != null && await canLaunchUrl(secondUri)) {
      return await launchUrl(secondUri);
    }

    showToast(context, 'Deep ♂ Dark ♂ Fantasy');
  }

  Widget _getBottomNav() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: '【说】', icon: Icon(Icons.mic)),
          BottomNavigationBarItem(
              label: '【学】', icon: Icon(Icons.local_library)),
          BottomNavigationBarItem(
              label: '【逗】', icon: Icon(Icons.sentiment_very_satisfied)),
          BottomNavigationBarItem(
              label: '【唱】', icon: Icon(Icons.music_note)),
          BottomNavigationBarItem(
              label: '【哏】', icon: Icon(Icons.school)),
        ],
        currentIndex: _selectedIndex,
        onTap: _selectTabItem,
      );

  _selectTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _selectMusicItem(int index) {
    _changModel.curIdx = index;
  }
}

class ActionOption {
  final String title;
  final IconData iconData;
  final String firstUrl;
  final String secondUrl;

  const ActionOption(
      {this.title, this.iconData, this.firstUrl, this.secondUrl});
}
