import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:thematic_map/network_utils.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  HomePageWidgetState createState() => HomePageWidgetState();
}

class HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  final String _typeName = "geofuse:geolink";
  final String _geoType = "polygon";
  //final String _viewParams = "linktab:csvdata.mb_1496985146753_6532;"
  //    "maptab:geodata.japan_ver52;mapcol:city";
  final String _viewParams = "linktab:csvdata.mb_1499406405018_2185;"
      "maptab:geodata.election;mapcol:senkyoku";
  final int _labScale = 500000;

  String _sld = "";
  String _jSessionId = "";

  String _color = "YellowToRed";
  String _typeRange = "Natural";
  String _propName = "col1";
  int _numRange = 4;
  int _accessToken = 1;

  @override
  void initState() {
    _getSld();
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  _getSld() async {
    Map<String, dynamic> ret = await NetworkUtils.getSld(
        jsessionId: _jSessionId,
        typeName: _typeName, //Layer Name
        color: _color,
        geoType: _geoType,
        propName: _propName,
        typeRange: _typeRange,
        labScale: _labScale,
        numRange: _numRange,
        viewParams: _viewParams);

    if (ret["jsessionid"].toString().isNotEmpty) {
      _jSessionId = ret["jsessionid"];
    }
    _sld = ret["sld"];
    debugPrint("JSESSIONID = $_jSessionId");

    _accessToken += 1;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _sld.isEmpty
        ? Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()))
        : Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            //backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              //backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              automaticallyImplyLeading: false,
              title: const Text(
                'Thematic Map',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              actions: [],
              centerTitle: true,
              elevation: 2,
            ),
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      //color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.grey,
                          child: FlutterMap(
                            options: MapOptions(
                              center: LatLng(35, 139),
                              zoom: 9,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    //'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    //"https://mt1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}",
                                    "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}",
                              ),
                              TileLayer(
                                //opacity: 0.8,
                                backgroundColor: Colors.transparent,
                                wmsOptions: WMSTileLayerOptions(
                                  baseUrl:
                                      'http://localhost:8080/geofuseService/core/wms;jsessionid=$_jSessionId?',
                                  layers: [_typeName],
                                  transparent: true,
                                  version: "1.0.0",
                                  otherParameters: {
                                    //"sld_body": Uri.encodeFull(_sld),
                                    "access_token": _accessToken.toString(),
                                    "viewparams": _viewParams,
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6ECF0),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                              border: Border.all(
                                color: const Color(0x4D101213),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xD539D2C0),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 2),
                                      child: Text(
                                        'Parameters',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 42, 8, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 0, 3, 0),
                                            child: Container(
                                              width: 100,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE6ECF0),
                                              ),
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, -0.050000000000000044),
                                              child: const Text(
                                                'Criteria',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 36,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      const Color(0x4D101213),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 5, 0),
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  value: _propName,
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: "col1",
                                                      child: Text(
                                                        "Column 1",
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "col2",
                                                      child: Text("Column 2"),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "col3",
                                                      child: Text("Column 3"),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: "col4",
                                                      child: Text("Column 4"),
                                                    )
                                                  ],
                                                  onChanged: (s) =>
                                                      setState(() {
                                                    _propName = s!;
                                                  }),
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 15, 8, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 0, 3, 0),
                                            child: Container(
                                              width: 100,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE6ECF0),
                                              ),
                                              child: const Align(
                                                alignment: AlignmentDirectional(
                                                    0, 0.05),
                                                child: Text(
                                                  'Type',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 0, 3, 0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 36,
                                              decoration: const BoxDecoration(
                                                  //color: FlutterFlowTheme.of(context)
                                                  //    .secondaryBackground,
                                                  ),
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0x4D101213),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 3, 0),
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    underline: const SizedBox(),
                                                    value: _typeRange,
                                                    items: const [
                                                      DropdownMenuItem(
                                                        value: "EQRange",
                                                        child: Text(
                                                          "Equal Range",
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "EQCount",
                                                        child:
                                                            Text("Equal Count"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "Natural",
                                                        child: Text(
                                                            "Natural Breaks"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "Geometric",
                                                        child: Text(
                                                            "Geometric Interval"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "Standard",
                                                        child: Text(
                                                            "Standard Deviation"),
                                                      )
                                                    ],
                                                    onChanged: (s) =>
                                                        setState(() {
                                                      _typeRange = s!;
                                                    }),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 15, 8, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 0, 3, 0),
                                            child: Container(
                                              width: 100,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE6ECF0),
                                              ),
                                              child: const Align(
                                                alignment: AlignmentDirectional(
                                                    0, 0.05),
                                                child: Text(
                                                  'Range',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 0, 3, 0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  //color: FlutterFlowTheme.of(context)
                                                  //    .secondaryBackground,
                                                  ),
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0x4D101213),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 3, 0),
                                                  child: DropdownButton<int>(
                                                    isExpanded: true,
                                                    underline: const SizedBox(),
                                                    value: _numRange,
                                                    items: const [
                                                      DropdownMenuItem(
                                                        value: 4,
                                                        child: Text(
                                                          "4",
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 6,
                                                        child: Text("6"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 8,
                                                        child: Text("8"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 10,
                                                        child: Text("10"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 12,
                                                        child: Text("12"),
                                                      )
                                                    ],
                                                    onChanged: (s) =>
                                                        setState(() {
                                                      _numRange = s!;
                                                    }),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 15, 8, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 0, 3, 0),
                                            child: Container(
                                              width: 100,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE6ECF0),
                                              ),
                                              child: const Align(
                                                alignment: AlignmentDirectional(
                                                    0, 0.05),
                                                child: Text(
                                                  'Color',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 0, 3, 0),
                                            child: Container(
                                              width: 100,
                                              height: 40,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0x4D101213),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 3, 0),
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    underline: const SizedBox(),
                                                    value: _color,
                                                    items: const [
                                                      DropdownMenuItem(
                                                        value: "YellowToRed",
                                                        child: Text(
                                                          "Yellow To Red",
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "YellowToGreen",
                                                        child: Text(
                                                            "Yellow To Green"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "RedToMagenta",
                                                        child: Text(
                                                            "Red To Magenta"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "Red",
                                                        child: Text("Red"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "Green",
                                                        child: Text("Green"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "Blue",
                                                        child: Text("Blue"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "Brown",
                                                        child: Text("Brown"),
                                                      ),
                                                    ],
                                                    onChanged: (s) =>
                                                        setState(() {
                                                      _color = s!;
                                                    }),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 22, 0, 0),
                                    child: FilledButton(
                                      onPressed: () async {
                                        await _getSld();
                                      },
                                      style: FilledButton.styleFrom(
                                          backgroundColor: Colors.grey),
                                      child: const Text("Submit"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Image.network(
                                        'http://localhost:8080/geofuseService/core/wms;jsessionid=$_jSessionId?'
                                        'REQUEST=GetLegendGraphic&FORMAT=image/png&'
                                        'TRANSPARENT=true&'
                                        'SERVICE=WMS&LAYER=$_typeName&'
                                        'WIDTH=64&VERSION=1.0.0&'
                                        'VIEWPARAMS=$_viewParams&'
                                        'ACCESS_TOKEN=$_accessToken'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
