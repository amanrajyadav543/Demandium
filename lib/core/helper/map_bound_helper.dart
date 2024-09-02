import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';

class MapHelper {
  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1 ?? 0, y1 ?? 0), southwest: LatLng(x0 ?? 0, y0 ?? 0));
  }

  static double getDistanceBetweenUserCurrentLocationAndProvider(AddressModel userCurrentAddress, ProviderData providerModel){

    double userLat = double.tryParse(userCurrentAddress.latitude ?? "0.00") ?? 0.0 ;
    double userLon = double.tryParse(userCurrentAddress.longitude ?? "0.00") ?? 0.0 ;

    double providerLat = providerModel.coordinates?.latitude ?? 0.0 ;
    double providerLon = providerModel.coordinates?.longitude ?? 0.0 ;

    return  Geolocator.distanceBetween(userLat, userLon, providerLat, providerLon)/1000;
  }


}