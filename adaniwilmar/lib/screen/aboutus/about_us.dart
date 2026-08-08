import 'package:adaniwilmar/config/constant.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';


class AboutUsScreen extends StatefulWidget {

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>{
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  String versionName="";
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      versionName = packageInfo.version;
      changeVersion();
    });
    return SafeArea(
            child: Scaffold(
              primary: false,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              appBar: const CustomAppBar(title: "About Us", backArrow: true),
              body: Stack(
                // overflow: Overflow.visible,
                children: [
                  Positioned(
                    child: Container(
                      child: Constant.bgImgGlobal,
                    ),
                  ),
                  Column(
                        children: [
                          Container(height:Constant.containerTopWrapper),
                          CurveBorderBox(
                              boxLRPadding: 0,
                              boxofWidget: Container(
                                height: screenHeight * 0.98,
                                width: screenWidth*0.98,
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                child:  SingleChildScrollView(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(child:Container(
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      color: Colors.white,
                                      height: screenHeight * 0.1,
                                      width: screenWidth*0.30,
                                      child:
                                      Constant.loginGroupLogoAboutUs!,
                                    )),
                                    Center(child:Container(
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      color: Colors.transparent,
                                      height: screenHeight * 0.02,
                                      width: screenWidth*0.30,
                                      child:
                                      Text("Version:"+versionName,textAlign:TextAlign.center,style:TextStyle(color: Colors.orange,
                                          fontSize: Constant.fontSize15,fontWeight: Constant.fontWeight600)),
                                    )),
                                    const SizedBox(height: 18.0),
                                    Row(children:[
                                      Container(
                                        width: 3,
                                        height: 30,
                                        color: Constant.callToCcolor1,
                                        margin:
                                        const EdgeInsets.only(top: 3,left:0),
                                      ),
                                      SizedBox(width: 10,),
                                      Padding(
                                          padding: EdgeInsets.only(top:5),
                                          child:Text(
                                            Constants.aboutAwlAgriBussiness,
                                            style: TextStyle(
                                                fontSize: Constant.fontSize20,
                                                color: Constant.colorBlack,
                                                fontWeight: Constant.fontWeight600),
                                          )),
                                    ]),
                                    SizedBox(width: 10,),
                                    Padding(
                                        padding: EdgeInsets.only(top:5,left:10),
                                        child:Text(
                                          "We are one of the few large FMCG food companies in India to offer most of the essential kitchen commodities for Indian consumers, including edible oil, wheat flour, rice, pulses and sugar. Our products are offered under a diverse range of brands across a broad price spectrum and cater to different customer groups.\n\nWe are a joint venture incorporated in January 1999 between the Adani Group, which is a multinational diversified business group with significant interests across transport and logistics, and energy and utility sectors, and the Wilmar Group, one of Asia’s leading agribusiness groups which was ranked among the largest listed companies by market capitalization on the Singapore Exchange as of February 2021. As a joint venture between the Adani Group and the Wilmar Group, we benefit from our strong parentage. We benefit from the Adani Group’s in-depth understanding of local markets, extensive experience in domestic trading and advanced logistics network in India, and leverage on the Wilmar Group’s global sourcing capabilities and technical know-how.",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: Constant.fontSize16,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                          ),

                                        )),
                                    const SizedBox(height: 12.0),
                                    Row(children:[
                                      Container(
                                        width: 3,
                                        height: 30,
                                        color: Constant.callToCcolor1,
                                        margin:
                                        const EdgeInsets.only(top: 3,left:0),
                                      ),
                                      SizedBox(width: 10,),
                                      Padding(
                                          padding: EdgeInsets.only(top:5),
                                          child:Text(
                                            "Key Pointers",
                                            style: TextStyle(
                                                fontSize: Constant.fontSize20,
                                                color: Constant.colorBlack,
                                                fontWeight: Constant.fontWeight600),
                                          )),
                                    ]),
                                    SizedBox(width: 10,),
                                    Padding(
                                        padding: EdgeInsets.only(top:5,left:10),
                                        child:Column(children:[
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                          "One of the few large FMCG food companies in India to offer most of the essential kitchen commodities for Indian consumers, including edible oil, wheat flour, rice, pulses and sugar.",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: Constant.fontSize16,
                                            color: Constant.colorDullGray77,
                                            fontWeight: Constant.fontWeight400,
                                          )),
                                        )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "No. 1 edible oil brand in India / “Fortune”, our flagship brand, is the largest selling edible oil brand in India.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "One of the fastest growing packaged food companies in India.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "India’s largest importer of crude edible oil",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Mundra is the one of the largest single location refineries in India with a designed capacity of approximately 5,000 tonnes per day.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Largest lauric fat manufacturer in India.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Largest manufacturer of castor oil in India and one of the largest basic oleochemical manufacturers in India",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Largest exporter of castor oil and its derivatives and one of the largest exporters of oleochemicals in India.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )])
                                        ])),
                                    const SizedBox(height: 12.0),
                                    Row(children:[
                                      Container(
                                        width: 3,
                                        height: 30,
                                        color: Constant.callToCcolor1,
                                        margin:
                                        const EdgeInsets.only(top: 3,left:0),
                                      ),
                                      SizedBox(width: 10,),
                                      Padding(
                                          padding: EdgeInsets.only(top:5),
                                          child:Text(
                                            "Awards & Accolades",
                                            style: TextStyle(
                                                fontSize: Constant.fontSize20,
                                                color: Constant.colorBlack,
                                                fontWeight: Constant.fontWeight600),
                                          )),
                                    ]),
                                    SizedBox(width: 10,),
                                    Padding(
                                        padding: EdgeInsets.only(top:5,left:10),
                                        child:Column(children:[
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Confederation of Indian Industry Award for Food Safety in 2020 for the Unit-1 of the Mundra, Krishnapatnam and Neemuch manufacturing facilities",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "No. 1 edible oil brand in India / “Fortune”, our flagship brand, is the largest selling edible oil brand in India.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "One of the top 100 most trusted brands in India by The Economic Times Brand Equity in 2020 for the Fortune brand",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "India’s largest importer of crude edible oil",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "One of India’s 50 most admired brands by White Page International in 2017",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "India’s most attractive edible oil brands by TRA Research in 2016",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Superbrand by Superbrands Council in 2018",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Great Place to Work Certification by Great Place to Work Institute, India since 2017",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Largest manufacturer of castor oil in India and one of the largest basic oleochemical manufacturers in India",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )]),
                                          SizedBox(height: 10,),
                                          Row(children:[
                                            Text("•",style: TextStyle(
                                              fontSize: Constant.fontSize24,
                                              color: Constant.colorDullGray77,
                                              fontWeight: Constant.fontWeight400,
                                            ),),
                                            SizedBox(width: 10,),
                                            Expanded(child:Text(
                                                "Largest exporter of castor oil and its derivatives and one of the largest exporters of oleochemicals in India",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: Constant.fontSize16,
                                                  color: Constant.colorDullGray77,
                                                  fontWeight: Constant.fontWeight400,
                                                )),
                                            )])
                                        ])),
                                  ],
                                )),
                              )),
                        ],
                      ),
                ],
              ),
            ));
  }
  void changeVersion(){
    setState(() {

    });
  }
}
