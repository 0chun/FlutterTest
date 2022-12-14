import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_clone_app/src/components/custom_appbar.dart';
import 'package:youtube_clone_app/src/components/video_widget.dart';
import 'package:youtube_clone_app/src/controller/home_controller.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              title: CustomAppbar(),
              floating: true,
              snap: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    child: VideoWidget(
                        video: controller.youtubeResult.value.items![index]),
                    onTap: () {
                      Get.toNamed(
                          '/detail/${controller.youtubeResult.value.items![index].id!.videoId}');
                    },
                  );
                },
                childCount: controller.youtubeResult.value.items == null
                    ? 0
                    : controller.youtubeResult.value.items!.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
