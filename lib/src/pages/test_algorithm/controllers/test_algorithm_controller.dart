import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/algorithm/shortest_path/graph.dart';
import 'package:indoor_positioning_visitor/src/algorithm/shortest_path/shortest_path.dart';
import 'package:indoor_positioning_visitor/src/services/api/edge_service.dart';
import 'package:indoor_positioning_visitor/src/services/api/location_service.dart';
import 'package:indoor_positioning_visitor/src/widgets/image_view/image_view_controller.dart';
import 'package:indoor_positioning_visitor/src/widgets/indoor_map/indoor_map_controller.dart';

class TestAlgorithmController extends GetxController {
  /// Inject EdgeService
  IEdgeService _edgeService = Get.find();

  /// Inject LocationService
  ILocationService _locationService = Get.find();

  /// Find shortest path algorithm
  IShortestPath _shortestPath = Get.find();

  /// Destination source id
  var destSourceId = 35.obs;

  /// From source id
  var fromSourceId = 30.obs;

  /// Get edges from API
  Future<void> getEdges() async {
    // Get edges from API
    var edges = await _edgeService.getEdges([2, 3, 4]);

    // Build graph for Dijiktra algorithm
    var graph = Graph.from(edges);

    // Get shortest path from destination source id
    _shortestPath.getShortestPath(
      graph,
      47,
    );

    // Retrieve path from depart source id
    print(graph.getPathFrom(30));
    // print(graphFromDest.value.getPathFrom(35));
  }

  /// Get stairs and lift on a floor
  Future<void> getStairsAndLifts() async {
    // Get stairs and lifts from API
    var locations = await _locationService.getStairsAndLifts(2);
    print(locations);
  }

  /// IndoorMapController
  IndoorMapController _mapController = IndoorMapController();

  @override
  void onInit() {
    super.onInit();
    _mapController.loadStoresOnMap([]);
    _mapController.setPathOnMap([]);
  }
}
