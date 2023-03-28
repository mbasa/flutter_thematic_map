import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NetworkUtils {
  static const String _geoFuseServiceURL =
      "http://localhost:8080/geofuseService/core/generateSld";

  static Future<Map<String, dynamic>> getSld(
      {String jsessionId = "",
      String typeName = "geofuse:geolink",
      String color = "Red",
      String geoType = "polygon",
      String propName = "col1",
      String typeRange = "Natural",
      int labScale = 500000,
      int numRange = 4,
      String viewParams = "linktab:csvdata.mb_1496985146753_6532;"
          "maptab:geodata.japan_ver52;mapcol:city",
      String cql = ""}) async {
    Map<String, dynamic> options = {
      "typename": typeName,
      "color": color,
      "geotype": geoType,
      "propname": propName,
      "typerange": typeRange,
      "labscale": labScale,
      "numrange": numRange,
      "viewparams": viewParams,
      "cql": cql,
    };

    Dio dio = Dio();
    Map<String, dynamic> retVal = {"jsessionid": "", "sld": ""};

    try {
      Response response = await dio.get(
          "$_geoFuseServiceURL;jsessionid=$jsessionId",
          queryParameters: options);
      if (response.statusCode == 200) {
        retVal["sld"] = response.data.toString();

        Headers headers = response.headers;

        String cookie = headers.value("set-cookie") ?? "";

        if (cookie.isNotEmpty) {
          retVal["jsessionid"] = cookie.split(";")[0].split("=")[1];
        }
      } else {
        debugPrint("SLD Request Status Code: ${response.statusCode} "
            "Status Message: ${response.statusMessage}");
      }
    } catch (e) {
      debugPrint("GetSLD Exception: ${e.toString()}");
    }

    return retVal;
  }
}
