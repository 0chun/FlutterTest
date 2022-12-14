import 'package:carrot_market_sample/page/detail.dart';
import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyFavoriteContents extends StatefulWidget {
  const MyFavoriteContents({Key? key}) : super(key: key);

  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  ContentsRepository contentsRepository = ContentsRepository();
  
  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: Text(
        '관심목록',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _makeDataList(List<dynamic> datas) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return DetailContentView(data : datas[index],);
            }));
            print(datas[index]['title']);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Hero(
                    tag: datas[index]['cid']!,
                    child: Image.asset(
                      datas[index]['image']!,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          datas[index]['title']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(datas[index]['location']!,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.3))),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          DataUtils.calcStringToWon(datas[index]['price'] as String),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/heart_off.svg',
                                width: 13,
                                height: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(datas[index]['likes']!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
      itemCount: datas.length,
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
      future: _loadMyFavoriteContentList(),
      builder: (context, dynamic snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return _makeDataList(snapshot.data);
        } else if (snapshot.hasError) {
          if (snapshot.data == null){
            return Center(child: Text("해당 지역에 데이터가 없습니다."));
          }
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<dynamic>?> _loadMyFavoriteContentList() async{
    return await contentsRepository.loadFavoriteContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
