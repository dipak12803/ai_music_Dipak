
import 'dart:convert';

import 'package:ai_music/model/radio.dart';
import 'package:ai_music/utils/ai_util.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers_android/';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
   const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
     List<MyRadio>?radios;
     MyRadio?_selectedRadio;
    Color?_selectedColor;
     bool _isPlaying=false;

     final AudioPlayer _audioPlayer=AudioPlayer();

@override
void initState() {
    
    super.initState();
    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event){
      if(event==PlayerState.playing){
        _isPlaying=true;
      }
      else{
        _isPlaying=false;
      }
    });
}
  fetchRadios() async{
    final radioJson=await rootBundle.loadString("assets/radio.json");
    radios=MyRadioList.fromJson(radioJson).radios;
    //print(radios);
    setState((){

    });
  }

  _playMusic(String url) async{
    await _audioPlayer.play(UrlSource(url));
    _selectedRadio=radios?.firstWhere((element) => element.url==url);
    setState(() {
      
    });
  }
  Future<void> playRadio(int radioId) async {
  // 1. Load the JSON data
  final response = await rootBundle.loadString('assets/radio.json');
  final data = jsonDecode(response) as Map<String, dynamic>;

  // 2. Find the radio object with the matching ID
  final selectedRadio = data['radios'].firstWhere((radio) => radio['id'] == radioId);

  // 3. Check if the radio exists
  if (selectedRadio != null) {
    // 4. Extract the audio URL
    final url = selectedRadio['url'];

    // 5. Call the _playMusic function with the URL
    await _playMusic(url);
  } else {
    // Handle the case where the radio is not found
    print('Radio with ID $radioId not found');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      body: Stack(fit: StackFit.expand,
      clipBehavior: Clip.antiAlias,children: [
        VxAnimatedBox().size(context.screenWidth,context.screenHeight)
        .withGradient(LinearGradient(
          colors: [
            AIColors.primaryColor2,
            _selectedColor??AIColors.primaryColor1,
          ],begin: Alignment.topLeft,end: Alignment.bottomRight
          ),)
        .make(),
        AppBar(
          title: "AI Radio".text.xl4.bold.white.make().shimmer(
            primaryColor: Vx.purple400,
            secondaryColor: Colors.white
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ).h(100.0).p16(),
        radios!=null?VxSwiper.builder(
          itemCount: radios!.length,
          aspectRatio: 1.0,
          enlargeCenterPage: true,
          onPageChanged: (index){
           final colorHex = radios?[index].color; // Ensure radios and index are not null
Color _selectedColor = Colors.transparent; // Default color

if (colorHex != null) {
  int? parsedColor = int.tryParse(colorHex);
  if (parsedColor != null) {
    _selectedColor = Color(parsedColor);
  } else {
    print('Error: Unable to parse colorHex "$colorHex"');
    // Handle invalid colorHex here
  }
}

            setState(() {
              
            });
          },

        itemBuilder: (context,index){
          final rad=radios?[index];

          return VxBox(

            child: ZStack([

              Positioned(
                top: 0.0,
                right:0.0,
                child: VxBox(
                  child:rad?.category.text.uppercase.white.make().px16(),
                ).height(40)
                .black
                .alignCenter
                .withRounded(value: 10.0)
                .make(),
              ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:VStack([
                    rad!.name.text.xl3.white.bold.make(),
                    5.heightBox,
                    rad.tagline.text.sm.white.semiBold.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                  ),
                ),
              Align(
                alignment: Alignment.center,
                
                child:[
                  const Icon(
                  CupertinoIcons.play_circle,
                  color:Colors.white,
                ),
                10.heightBox,
                "Double tap to play".text.gray300.make(),

                ].vStack())

                
            ] ,clip:Clip.antiAlias,
            )
          )
          .clip(Clip.antiAlias)
          .bgImage(DecorationImage(
            image: NetworkImage(rad.image),
            fit:BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3),BlendMode.darken),

          ))
          .border(color:Colors.black,width: 5.0)
          .withRounded(value: 60.0)
          .make()
          .onInkDoubleTap(() {
            _playMusic(rad.url);
          })
          .p16();
          
        },
        ).centered():const Center(child:CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
        ),
        Positioned(
  bottom: 0,
  right: 0,
  left: 0,
  child: Align(
    alignment: Alignment.bottomCenter,
    child: [
      if (_isPlaying)
        "Playing Now -${_selectedRadio?.name} FM".text.white.make(),
      IconButton(
        icon: Icon(
          _isPlaying ? Icons.stop_circle : Icons.play_circle,
          color: Colors.white,
          size: 50.0,
        ),
        onPressed: () {
          setState(() {
            if (_isPlaying) {
              _audioPlayer.stop();
            } else {
              _playMusic(_selectedRadio!.url);
            }
          });
        },
      ),
    ].vStack(),
  ).pOnly(bottom: context.percentHeight * 12),
)

      ],
      ),
    );
  }
}