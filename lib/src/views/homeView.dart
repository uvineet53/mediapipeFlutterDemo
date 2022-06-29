import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediapipedemo/src/views/widgets/modelCard.dart';
import 'package:mediapipedemo/src/views/widgets/homeCard.dart';
import 'package:mediapipedemo/src/views/widgets/homeHeader.dart';
import 'package:mediapipedemo/src/views/widgets/tagBuilder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint("Could not launch");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[900],
      ),
      drawer: Drawer(),
      body: ListView(
        padding: const EdgeInsets.all(18),
        shrinkWrap: true,
        children: [
          homeHeader(),
          tagBuilder("Explore More"),
          VxSwiper.builder(
              scrollPhysics: BouncingScrollPhysics(),
              height: Get.height * .35,
              enlargeCenterPage: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () async {
                      await launchInBrowser(
                          Uri.parse(data[index]['link'].toString()));
                    },
                    child: homeCards(data[index]));
              }),
          tagBuilder("Mediapipe x Flutter").py4(),
          GestureDetector(
            onTap: () => Get.toNamed("/facemesh"),
            child: const ModelCard(
              title: "Face Mesh",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: social.map((e) {
              return IconButton(
                  onPressed: () async {
                    await launchInBrowser(Uri.parse(e['link']));
                  },
                  icon: Icon(
                    e['icon'],
                    size: 30,
                    color: Vx.gray400,
                  ));
            }).toList(),
          ).py16(),
          "Made with ❤️ by Atript Aatma"
              .text
              .gray500
              .semiBold
              .lg
              .makeCentered(),
        ],
      ),
    );
  }
}
