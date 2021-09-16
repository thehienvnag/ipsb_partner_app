import 'package:ipsb_partner_app/src/common/endpoints.dart';
import 'package:ipsb_partner_app/src/models/locator_tag.dart';
import 'package:ipsb_partner_app/src/services/api/base_service.dart';

mixin ILocatorTagService {
  Future<LocatorTag?> postLocatorTag(
      String macAddress, String status, int floorPlanId, int locationId);
}

class LocatorTagService extends BaseService<LocatorTag>
    implements ILocatorTagService {
  @override
  String endpoint() {
    return Endpoints.locatorTag;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw LocatorTag.fromJson(json);
  }

  @override
  Future<LocatorTag?> postLocatorTag(
      String macAddress, String status, int floorPlanId, int locationId) {
    return postBase({
      "macAddress": macAddress,
      "status": status,
      "floorPlanId": floorPlanId,
      "locationId": locationId,
    });
  }
}
