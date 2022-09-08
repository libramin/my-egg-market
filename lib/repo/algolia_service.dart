import 'package:algolia/algolia.dart';
import 'package:my_egg_market/data/item_model.dart';

const Algolia algolia = Algolia.init(
  applicationId: '505OUXOBPH',
  apiKey: '25c9e5b210c5f40422ccb4793e6c848c',
);


class AlgoliaService {
  static final AlgoliaService _algoliaService = AlgoliaService._internal();
  factory AlgoliaService() => _algoliaService;
  AlgoliaService._internal();

  Future<List<ItemModel>> queryItems (String queryStr)async{
    AlgoliaQuery query = algolia.instance.index('items').query(queryStr);
    AlgoliaQuerySnapshot algoliaSnapshot = await query.getObjects();
    List<AlgoliaObjectSnapshot> hits = algoliaSnapshot.hits;
    List<ItemModel> items =[];
    hits.forEach((element) {
      ItemModel item = ItemModel.fromAlgolia(element.data, element.objectID);
      items.add(item);
    });
    return items;
  }
}