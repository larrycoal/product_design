import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../models/user.dart';
import '../models/auth.dart';

class ConnectedproductModel extends Model {
  List<Product> _products = [];
  User _authenticateduser;
  String _selProductId;
  bool _isloading = false;
}

class ProductsModel extends ConnectedproductModel {
  bool _showfavorites = false;

  List<Product> get allproducts {
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  List<Product> get displayedproducts {
    if (_showfavorites) {
      return _products.where((Product product) => product.isfavorite).toList();
    }
    return List.from(_products);
  }

  bool get showfavorite {
    return _showfavorites;
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product products) {
      return products.id == _selProductId;
    });
  }

  Future<bool> addproduct(
    String title,
    String description,
    double price,
    String image,
  ) async {
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'data:image/jpeg;base64,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',
      'price': price,
      'userEmail': _authenticateduser.email,
      'userid': _authenticateduser.id
    };
    _isloading = true;
    try {
      final http.Response response = await http.post(
          'https://larryproducts-dd5c0.firebaseio.com/larryproducts-dd5c0.json?auth=${_authenticateduser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isloading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      Product newproduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          useremail: _authenticateduser.email,
          userid: _authenticateduser.id);
      _products.add(newproduct);
      _isloading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isloading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteproduct() {
    return http
        .delete(
            'https://larryproducts-dd5c0.firebaseio.com/larryproducts-dd5c0/${selectedProduct.id}.json?auth=${_authenticateduser.token}')
        .then((http.Response response) {
      _isloading = false;
      _products.removeAt(selectedProductIndex);
      notifyListeners();
      return true;
    }).catchError((error) {
      _isloading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isloading = true;
    return http
        .get(
            'https://larryproducts-dd5c0.firebaseio.com/larryproducts-dd5c0.json?auth=${_authenticateduser.token}')
        .then<Null>((http.Response response) {
      final List<Product> fetchedproductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      productListData.forEach((String productId, dynamic productData) {
        final Product fetchedproducts = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            useremail: productData['userEmail'],
            userid: productData['userid']);
        fetchedproductList.add(fetchedproducts);
      });
      _products = fetchedproductList;
      _isloading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isloading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> updateproduct(
    String title,
    String description,
    double price,
    String image,
  ) {
    _isloading = true;
    notifyListeners();
    final Map<String, dynamic> newproduct = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'data:image/jpeg;base64,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',
      'useremail': selectedProduct.useremail,
      'userid': selectedProduct.userid,
    };
    return http
        .put(
            'https://larryproducts-dd5c0.firebaseio.com/larryproducts-dd5c0/${selectedProduct.id}.json?auth=${_authenticateduser.token}',
            body: json.encode(newproduct))
        .then((http.Response response) {
      Product updatedproduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          useremail: selectedProduct.useremail,
          userid: selectedProduct.userid);
      _products[selectedProductIndex] = updatedproduct;
      _isloading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isloading = false;
      notifyListeners();
      return false;
    });
  }

  void togglefavoritebutton() {
    final bool currentlyfavorite = selectedProduct.isfavorite;
    final bool newfavorite = !currentlyfavorite;
    final Product updatedproduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        price: selectedProduct.price,
        description: selectedProduct.description,
        image: selectedProduct.image,
        useremail: selectedProduct.useremail,
        userid: selectedProduct.userid,
        isfavorite: newfavorite);
    _products[selectedProductIndex] = updatedproduct;
    notifyListeners();
  }

  void selectProduct(productId) {
    _selProductId = productId;
  }

  void togglefavorite() {
    _showfavorites = !_showfavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedproductModel {
  Timer _authtimeOut;
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode = AuthMode.Login]) async {
    _isloading = true;
    notifyListeners();
    final Map<String, dynamic> authdata = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (AuthMode.Login) {
      response = await http.post(
          //link not updated for signin also api_key not attached
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]',
          body: json.encode(authdata),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]',
          body: json.encode(authdata),
          headers: {'Content-Type': 'application/json'});
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'something went wrong';
    if (responseData.containsKey('idtoken')) {
      _authenticateduser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      final int time = int.parse(responseData['expiersIn']);
      setAuthTimeout(time);
      final DateTime now = DateTime.now();
      final DateTime expiryTime = now.add(Duration(seconds: time));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('id', responseData['localId']);
      prefs.setString('email', email);
      prefs.setString('expiryTime', expiryTime.toString());
      hasError = false;
    } else if (responseData['message']['EMAIL DOES NOT EXIST']) {
      message = 'Email does not exists';
    } else if (responseData['message']['INVALID-PASSWORD']) {
      message = 'password is invalid';
    } else if (responseData['message']['EMAIL-EXISTS']) {
      message = 'Email already exists';
    }
    message = 'Aunthetication succeded';
    _isloading = false;
    notifyListeners();

    return {'success': !hasError, 'message': message};
  }

  void autoauthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTime = (prefs.getString('expiryTime'));
    final DateTime parsedexpiryTime = DateTime.parse(expiryTime);
    if (token != null) {
      DateTime now = DateTime.now();
      if (parsedexpiryTime.isBefore(now)) {
        _authenticateduser = null;
        notifyListeners();
        return;
      }
      _authenticateduser = User(
          email: prefs.getString('email'),
          id: prefs.getString('id'),
          token: token); 
      final int tokenLifeSpan = parsedexpiryTime.difference(now).inSeconds;
      setAuthTimeout(tokenLifeSpan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticateduser = null;
    _authtimeOut.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('email');
    prefs.remove('id');
  }

  void setAuthTimeout(int time) {
    _authtimeOut = Timer(Duration(seconds: time), logout);
  }

  User get user {
    return _authenticateduser;
  }
}

class UtilityModel extends ConnectedproductModel {
  bool get isloading {
    return _isloading;
  }
}
