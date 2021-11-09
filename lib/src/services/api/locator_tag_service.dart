import 'package:ipsb_partner_app/src/common/constants.dart';
import 'package:ipsb_partner_app/src/common/endpoints.dart';
import 'package:ipsb_partner_app/src/models/locator_tag.dart';
import 'package:ipsb_partner_app/src/services/api/base_service.dart';

mixin ILocatorTagService {
  Future<LocatorTag?> postLocatorTag(String macAddress, int buildingId);

  Future<bool> updateLocatorTagByUUID(String uuid, double txPower);

  Future<List<LocatorTag>> getAllLocatorTagByBuildingId(int building);
}

class LocatorTagService extends BaseService<LocatorTag>
    implements ILocatorTagService {
  @override
  String endpoint() {
    return Endpoints.locatorTag;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return LocatorTag.fromJson(json);
  }

  @override
  Future<LocatorTag?> postLocatorTag(String uuid, int buildingId) {
    return postBase({
      "uuid": uuid,
      "buildingId": buildingId.toString(),
    });
  }

  @override
  Future<bool> updateLocatorTagByUUID(String uuid, double txPower) {
    return putBaseWithAdditionalSegment(
      uuid,
      Constants.txPower,
      {"txPower": txPower.toString()},
    );
  }

  @override
  Future<List<LocatorTag>> getAllLocatorTagByBuildingId(int buildingId) {
    return getAllBase({
      "buildingId": buildingId.toString(),
    });
  }
}
