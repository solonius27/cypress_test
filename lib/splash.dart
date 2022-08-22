import 'package:cached_network_image/cached_network_image.dart';
import 'package:cypress_test/appProvider.dart';
import 'package:cypress_test/app_model.dart';
import 'package:cypress_test/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Size? size;
  List<AppModel>? listitem;
  bool pageloading = true;
  List<String>? imageslist;

  @override
  void initState() {
    doinit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: pageloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  appText("Fetching data.....\nThis may take a few seconds", 12,
                      topmargin: 10.0)
                ],
              ),
            )
          : Container(
              margin: pageMargin,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: size!.height,
                      width: size!.width,
                      child: ListWheelScrollView.useDelegate(
                        useMagnifier: false,
                        magnification: 0.1,
                        diameterRatio: 100.0,
                        //physics: FixedExtentScrollPhysics(),
                        childDelegate: ListWheelChildLoopingListDelegate(
                            children: listitem!
                                .map((e) => CusView(e.albumname, e.images))
                                .toList()),
                        itemExtent: 165.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> doinit() async {
    listitem =
        await Provider.of<AppProvider>(context, listen: false).getAlbums();
    setState(() {
      pageloading = false;
    });
  }
}

class CusView extends StatelessWidget {
  final albumtext;
  List<String>? items;

  CusView(this.albumtext, this.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: calculateSize(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(albumtext, 13, bottommargin: 10.0, align: TextAlign.start),
          SizedBox(
            height: calculateSize(100),
            child: ListView.builder(
              itemCount: items!.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) => Container(
                color: Colors.red,
                width: calculateSize(100),
                margin: EdgeInsets.only(right: 30),
                child: CachedNetworkImage(
                  imageUrl: items![i],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
