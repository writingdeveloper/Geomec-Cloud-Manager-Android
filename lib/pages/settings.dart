import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'pages.dart';
import '../services/services.dart';
import '../shared/shared.dart';

class SettingsPage extends StatefulWidget {
  final ConnectionPage currentConnectionPage;

  SettingsPage({this.currentConnectionPage});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  Widget _buildHeadline(
    String title, {
    bool hasSwitch = false,
    Function onChanged,
  }) {
    String sortLabel;
    if (hasSwitch) {
      if (SettingsVariables.sort == "name") {
        if (SettingsVariables.sortIsDescending) {
          sortLabel = "(A-Z)";
        } else {
          sortLabel = "(Z-A)";
        }
      } else {
        if (SettingsVariables.sortIsDescending) {
          sortLabel = "(New-Old)";
        } else {
          sortLabel = "(Old-New)";
        }
      }
    }
    return Padding(
      padding: EdgeInsets.only(
        top: hasSwitch ? 0 : 12,
        bottom: hasSwitch ? 0 : 12,
        left: 16,
        right: 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
              letterSpacing: .7,
              color: Theme.of(context).accentColor,
            ),
          ),
          hasSwitch
              ? Row(
                  children: <Widget>[
                    Text(
                      sortLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                        letterSpacing: .7,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    SizedBox(width: 6.0),
                    Switch(
                      activeColor: Theme.of(context).accentColor,
                      activeThumbImage:
                          AssetImage("assets/arrow_drop_down.png"),
                      inactiveThumbImage:
                          AssetImage("assets/arrow_drop_up.png"),
                      value: SettingsVariables.sortIsDescending,
                      onChanged: onChanged,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildRadioListTile({
    @required String titleLabel,
    @required String value,
    @required bool isView,
  }) {
    return RadioListTile(
      activeColor: Theme.of(context).accentColor,
      title: Text(titleLabel),
      groupValue: isView ? SettingsVariables.view : SettingsVariables.sort,
      value: value,
      onChanged: (String radioValue) async {
        if (isView) {
          await SettingsVariables.setView(value);
        } else {
          await SettingsVariables.setSort(value);
          if (widget.currentConnectionPage != null) {
            widget.currentConnectionPage.sortFileInfos();
          }
        }
        setState(() {});
      },
    );
  }

  Widget _buildSaveToWidget() {
    if (Platform.isIOS) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeadline("파일 저장 디렉토리"),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 4,
              bottom: 8,
            ),
            child: Container(
              child: TextField(
                controller: _downloadPathTextController,
                decoration: InputDecoration(
                  labelText: "경로",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Tooltip(
                        message: "Clear",
                        child: CustomIconButton(
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            SettingsVariables.setDownloadDirectory("").then(
                                (_) => _downloadPathTextController.text = "");
                          },
                        ),
                      ),
                      Tooltip(
                        message: "Set to default",
                        child: CustomIconButton(
                          icon: Icon(
                            Icons.settings_backup_restore,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            SettingsVariables.setDownloadDirectoryToDefault()
                                .then((Directory dir) {
                              _downloadPathTextController.text = dir.path;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                onChanged: (String value) async {
                  await SettingsVariables.setDownloadDirectory(value);
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  var _downloadPathTextController =
      TextEditingController(text: SettingsVariables.downloadDirectory.path);

  var _moveCommandTextController =
      TextEditingController(text: SettingsVariables.moveCommand);
  var _copyCommandTextController =
      TextEditingController(text: SettingsVariables.copyCommand);

  String _moveCommandGroupValue =
      SettingsVariables.moveCommand == "mv" ? "default" : "custom";
  String _copyCommandGroupValue =
      SettingsVariables.copyCommand == "cp" ? "default" : "custom";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Provider.of<CustomTheme>(context).isLightTheme(context)
            ? Brightness.light
            : Brightness.dark,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        leading: Padding(
          padding: EdgeInsets.all(7),
          child: CustomIconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text("앱 설정", style: TextStyle(fontSize: 19)),
        titleSpacing: 4,
        elevation: 2,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Scrollbar(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(height: 4),
                _buildHeadline("보기 설정"),
                _buildRadioListTile(
                  titleLabel: "리스트",
                  value: "list",
                  isView: true,
                ),
                _buildRadioListTile(
                  titleLabel: "상세 정보 표시",
                  value: "detailed",
                  isView: true,
                ),
                _buildRadioListTile(
                  titleLabel: "그리드",
                  value: "grid",
                  isView: true,
                ),
                Divider(),
                _buildHeadline(
                  "정렬 방식",
                  hasSwitch: true,
                  onChanged: (bool value) async {
                    await SettingsVariables.setSortIsDescending(value);
                    if (widget.currentConnectionPage != null) {
                      widget.currentConnectionPage.sortFileInfos();
                    }
                    setState(() {});
                  },
                ),
                _buildRadioListTile(
                  titleLabel: "이름",
                  value: "name",
                  isView: false,
                ),
                _buildRadioListTile(
                  titleLabel: "수정 날짜",
                  value: "modificationDate",
                  isView: false,
                ),
                _buildRadioListTile(
                  titleLabel: "마지막 접속기록",
                  value: "lastAccess",
                  isView: false,
                ),
                Divider(),
                _buildHeadline("Appearance"),
                ListTile(
                  title: Text("테마"),
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Opacity(
                      opacity: .6,
                      child: Text(Provider.of<CustomTheme>(context)
                              .themeValue[0]
                              .toUpperCase() +
                          Provider.of<CustomTheme>(context)
                              .themeValue
                              .substring(1)),
                    ),
                  ),
                  onTap: () {
                    customShowDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        content: StatefulBuilder(builder: (context, setState) {
                          return Consumer<CustomTheme>(
                              builder: (context, model, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                RadioListTile(
                                  activeColor: Theme.of(context).accentColor,
                                  title: Text("자동"),
                                  subtitle: Text(
                                      "시스템 테마 정보 설정을 따릅니다\n" +
                                  "자동으로 설정되는 기능입니다"),
                                  value: "automatic",
                                  groupValue: model.themeValue,
                                  onChanged: (String value) async {
                                    await model.setThemeValue(value);
                                    setState(() {});
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Theme.of(context).accentColor,
                                  title: Text("밝은 테마"),
                                  value: "light",
                                  groupValue: model.themeValue,
                                  onChanged: (String value) async {
                                    await model.setThemeValue(value);
                                    setState(() {});
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Theme.of(context).accentColor,
                                  title: Text("어두운 테마"),
                                  value: "dark",
                                  groupValue: model.themeValue,
                                  onChanged: (String value) async {
                                    await model.setThemeValue(value);
                                    setState(() {});
                                  },
                                ),
                                RadioListTile(
                                  activeColor: Theme.of(context).accentColor,
                                  title: Text("검정색 테마"),
                                  value: "black",
                                  groupValue: model.themeValue,
                                  onChanged: (String value) async {
                                    await model.setThemeValue(value);
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          });
                        }),
                      ),
                    );
                  },
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).accentColor,
                  title: Text("숨겨진 파일 표시"),
                  subtitle: Text(".으로 시작하는 파일 표시 유무 설정"),
                  value: SettingsVariables.showHiddenFiles,
                  onChanged: (bool value) async {
                    await SettingsVariables.setShowHiddenFiles(value);
                    setState(() {});
                  },
                ),
                ListTile(
                  title: Text("파일 사이즈 표시 설정"),
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Opacity(
                      opacity: .6,
                      child: Text(
                          SettingsVariables.filesizeUnit[0].toUpperCase() +
                              SettingsVariables.filesizeUnit.substring(1)),
                    ),
                  ),
                  onTap: () {
                    customShowDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        content: StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("자동"),
                                value: "automatic",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("바이트"),
                                value: "B",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("킬로바이트"),
                                value: "KB",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("메가바이트"),
                                value: "MB",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("기가바이트"),
                                value: "GB",
                                groupValue: SettingsVariables.filesizeUnit,
                                onChanged: (String value) async {
                                  await SettingsVariables.setFilesizeUnit(
                                      value, widget.currentConnectionPage);
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        }),
                      ),
                    );
                  },
                ),
                Divider(),
                _buildSaveToWidget(),
                Divider(),
                _buildHeadline("SSH 명렁어 기본 설정"),
                ListTile(
                  title: Text("이동"),
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Opacity(
                      opacity: .6,
                      child: Text(_moveCommandGroupValue[0].toUpperCase() +
                          _moveCommandGroupValue.substring(1)),
                    ),
                  ),
                  onTap: () {
                    customShowDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        content: StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("기본 설정 (권장 설정)"),
                                subtitle: Text("폴더나 파일을 이동할 때 mv 명령어를 사용합니다"),
                                value: "default",
                                groupValue: _moveCommandGroupValue,
                                onChanged: (String value) async {
                                  await SettingsVariables
                                      .setMoveCommandToDefault();
                                  await SettingsVariables.setMoveCommandAppend(
                                      false);
                                  setState(() {
                                    _moveCommandGroupValue = "default";
                                  });
                                },
                              ),
                              _moveCommandGroupValue == "custom"
                                  ? Divider()
                                  : Container(),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("사용자 명령어"),
                                value: "custom",
                                groupValue: _moveCommandGroupValue,
                                onChanged: (String value) async {
                                  await SettingsVariables.setMoveCommand(
                                      _moveCommandTextController.text);
                                  setState(() {
                                    _moveCommandGroupValue = "custom";
                                  });
                                },
                              ),
                              _moveCommandGroupValue == "custom"
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 19, vertical: 10),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "SSH 명령어",
                                        ),
                                        controller: _moveCommandTextController,
                                        onChanged: (String value) async {
                                          await SettingsVariables
                                              .setMoveCommand(value);
                                        },
                                      ),
                                    )
                                  : Container(),
                              _moveCommandGroupValue == "custom"
                                  ? SwitchListTile(
                                      activeColor:
                                          Theme.of(context).accentColor,
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Text(
                                          "디렉토리를 이동시킬 때 SSH 명령어에 -r 옵션 추가",
                                        ),
                                      ),
                                      value:
                                          SettingsVariables.moveCommandAppend,
                                      onChanged: (bool value) async {
                                        await SettingsVariables
                                            .setMoveCommandAppend(value);
                                        setState(() {});
                                      },
                                    )
                                  : Container(),
                            ],
                          );
                        }),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text("복사"),
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Opacity(
                      opacity: .6,
                      child: Text(_copyCommandGroupValue[0].toUpperCase() +
                          _copyCommandGroupValue.substring(1)),
                    ),
                  ),
                  onTap: () {
                    customShowDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        content: StatefulBuilder(builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("기본 설정 (권장 설정)"),
                                subtitle: Text("파일들을 복사할 때에는 cp 명령어를 사용하고 폴더들을 복사할 때에는 cp 명령어에 -r 옵션을 추가합니다"),
                                value: "default",
                                groupValue: _copyCommandGroupValue,
                                onChanged: (String value) async {
                                  await SettingsVariables
                                      .setCopyCommandToDefault();
                                  await SettingsVariables.setCopyCommandAppend(
                                      true);
                                  setState(() {
                                    _copyCommandGroupValue = "default";
                                  });
                                },
                              ),
                              _copyCommandGroupValue == "custom"
                                  ? Divider()
                                  : Container(),
                              RadioListTile(
                                activeColor: Theme.of(context).accentColor,
                                title: Text("사용자 설정"),
                                value: "custom",
                                groupValue: _copyCommandGroupValue,
                                onChanged: (String value) async {
                                  await SettingsVariables.setCopyCommand(
                                      _copyCommandTextController.text);
                                  setState(() {
                                    _copyCommandGroupValue = "custom";
                                  });
                                },
                              ),
                              _copyCommandGroupValue == "custom"
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 19, vertical: 10),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "SSH 명령어",
                                        ),
                                        controller: _copyCommandTextController,
                                        onChanged: (String value) async {
                                          await SettingsVariables
                                              .setCopyCommand(value);
                                        },
                                      ),
                                    )
                                  : Container(),
                              _copyCommandGroupValue == "custom"
                                  ? SwitchListTile(
                                      activeColor:
                                          Theme.of(context).accentColor,
                                      title: Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Text(
                                          "디렉토리를 이동시킬 때 SSH 명령어에 -r 옵션 추가"
                                        ),
                                      ),
                                      value:
                                          SettingsVariables.copyCommandAppend,
                                      onChanged: (bool value) async {
                                        await SettingsVariables
                                            .setCopyCommandAppend(value);
                                        setState(() {});
                                      },
                                    )
                                  : Container(),
                            ],
                          );
                        }),
                      ),
                    );
                  },
                ),
                Divider(),
                _buildHeadline("기타 설정"),
                ListTile(
                  title: Text("모든 연결 해제"),
                  onTap: () {
                    customShowDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        title: Text(
                          "모든 연결을 해제합니까?\n이 작업은 되돌릴수 없습니다.",
                        ),
                        actions: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: EdgeInsets.only(
                                top: 8.5, bottom: 8.0, left: 14.0, right: 14.0),
                            child: Text("취소"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            color: Theme.of(context).accentColor,
                            splashColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: EdgeInsets.only(
                                top: 8.5, bottom: 8.0, left: 14.0, right: 14.0),
                            child: Text(
                              "확인",
                              style: TextStyle(
                                color: Provider.of<CustomTheme>(context)
                                        .isLightTheme(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            elevation: .0,
                            onPressed: () {
                              HomePage.favoritesPage.removeAllConnections();
                              HomePage.recentlyAddedPage.removeAllConnections();
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: .0),
                        ],
                      ),
                    );
                  },
                ),
                Divider(),
                _buildHeadline("프로그램 정보"),
                ListTile(
                  title: Text("Geomec Cloud Manager 정보"),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
                SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
