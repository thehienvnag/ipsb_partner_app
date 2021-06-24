import 'package:indoor_positioning_visitor/src/common/endpoints.dart';
import 'package:indoor_positioning_visitor/src/models/location.dart';
import 'package:indoor_positioning_visitor/src/services/api/base_service.dart';

mixin ILocationService {}

class LocationService extends BaseService<Location>
    implements ILocationService {
  @override
  String endpoint() {
    return Endpoints.locations;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Location.fromJson(json);
  }
}
