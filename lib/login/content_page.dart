import 'package:kishan_hub/edit_profile_page.dart';
import 'package:kishan_hub/page/admin/show_product.dart';
import 'package:kishan_hub/page/market%20price/market_price2.dart';
import 'package:kishan_hub/widgets/home_page.dart';

abstract class Content {
  Future<EditProfile> editProfile();
  Future<ProductPage> admin(String id);
  Future<MainHomePage> store();
  Future<MyMarketPage> marketprice();
}

class ContentPage implements Content {
  Future<EditProfile> editProfile() async {
    return EditProfile();
  }

  Future<ProductPage> admin(String id) async {
    print('listed my products $id');
    return ProductPage(id: id);
  }

  Future<MainHomePage> store() async {
    return MainHomePage();
  }

  Future<MyMarketPage> marketprice() async {
    return MyMarketPage();
  }
}
