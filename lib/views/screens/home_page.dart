import 'dart:convert';
import 'package:animal_app/Model/image_model.dart';

import '../../Model/global.dart';
import '../../Helper/animal_DB_helper.dart';
import '../../Helper/image_API_helper.dart';
import '../../Model/animal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            backgroundColor: Colors.blueGrey,
            floating: true,
            snap: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                width: 180,
                height: 70,
                alignment: Alignment.center,
                child: Text(
                  "ANIMALS",
                  style: GoogleFonts.acme().copyWith(
                      fontSize: 25,
                      letterSpacing: 2,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,),
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.grey.withOpacity(0.5)
                    ],),),
              ),
              background: Image.asset(
                "assets/images/animal.jpg",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    global.inint = i;

                    global.Images = (await Image_api.image_api.feach_Data(
                        Animal_name: "${global.Animal_name[i]['name']}"))?.cast<Image_Modal>();
                    Navigator.of(context).pushNamed('detail_page',
                        arguments: global.Animal_name[i]);
                    String Jsondata = await rootBundle
                        .loadString("assets/json_data/my_json_data.json");
                    Map decodedData = jsonDecode(Jsondata);
                    List data = decodedData["${global.Animal_name[i]['name']}"];
                    print(data.length);
                    Animal_db.animal_db.deleteAllData();
                    data.forEach((e) async {
// print(e);
                      Animal_Modal a1 = Animal_Modal(
                          name: e['name'],
                          color: e['characteristics']['color'],
                          average_litter_size: e['characteristics']
                          ['average_litter_size'],
                          loction: e['locations'][0],
                          skin_type: e['characteristics']['skin_type'],
                          lifespan: e['characteristics']['lifespan'],
                          type: e['characteristics']['type'],
                          diet: e['characteristics']['diet']);

                      print(a1.name);

                      int? res =
                      await Animal_db.animal_db.inserRecode(data: a1);
                      print(res);
                    });
                  },
                  child: Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "${global.Animal_name[i]['image']}",
                            height: 250,
                            fit: BoxFit.fitHeight,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 160,
                            decoration: BoxDecoration(color: Colors.black54,borderRadius: BorderRadius.circular(15),border: Border.all(width: 5)),
                            child: Text(
                              "${global.Animal_name[i]['name']}".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: global.Animal_name.length),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          )
        ],
      ),
    );
  }
}