import 'package:cypress_test/app_model.dart';
import 'package:cypress_test/networkutils.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

class AppProvider with ChangeNotifier {
  var BASE_URL = "https://jsonplaceholder.typicode.com";

  List<AppModel> listitem = [];
  final dbHelper = DatabaseHelper.instance;

  Future<void> insertintoalbumdb(albumid, title) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnalbumid: albumid,
      DatabaseHelper.columnalbumtitle: title,
    };
    final id = await dbHelper.insert(row, DatabaseHelper.albumtable);
    print('inserted row id: $id');

    //queryUsertable();
  }

  Future<void> insertintoalbumartdb(albumid, imgurl) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnartalbumid: albumid,
      DatabaseHelper.columnimgurl: imgurl
    };
    final id = await dbHelper.insert(row, DatabaseHelper.albumartstable);
    print('inserted album art row id: $id');

    //queryUsertable();
  }

  Future<void> queryUsertable() async {
    final allRows = await dbHelper.queryAllRows(DatabaseHelper.albumtable);
    final albumartrows =
        await dbHelper.queryAllRows(DatabaseHelper.albumartstable);

    for (var v in allRows) {
      var albumid = v["albumid"];
      List<String> images = [];

      for (var x in albumartrows) {
        if (albumid == x["albumid"]) {
          images.add(x["imageurl"]);
        }
      }

      listitem.add(
        AppModel(albumID: v["albumid"], albumname: v["title"], images: images),
      );
    }
  }

  Future<List<AppModel>> getAlbums() async {
    await queryUsertable();
    if (listitem.isNotEmpty) {
      return listitem;
    }

    int count = 0;

    try {
      var response =
          await NetwokUtils.getRequest("$BASE_URL/albums") as List<dynamic>;

      for (var element in response) {
        insertintoalbumdb(element["id"].toString(), element["title"]);
        var images = await getimages(element["id"].toString());
        for (var x in images) {
          insertintoalbumartdb(element["id"].toString(), x.toString());
        }

        listitem.add(
          AppModel(
              albumname: element["title"],
              albumID: element["id"].toString(),
              images: images),
        );
      }

      return listitem;
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Future<List<String>> getimages(id) async {
    try {
      var response =
          await NetwokUtils.getRequest("$BASE_URL/photos?albumId=$id")
              as List<dynamic>;

      List<String> imagesurl = [];

      for (var e in response) {
        imagesurl.add(e["thumbnailUrl"]);
      }

      return imagesurl;
    } on Exception catch (e) {
      throw e;
    }
  }
}
