import 'package:flutter/widgets.dart';

CategoryNotifier categoryNotifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier{

  String _selectedCategory = '카테고리 선택';

  String get currentCategory => _selectedCategory;

  set(String newCategory){
    _selectedCategory = newCategory;
    notifyListeners();
  }
}

const List<String> categories = [
  '전자기기',
  '생활가전',
  '가구/인테리어',
  '유아동',
  '생활/가공식품',
  '유아도서',
  '스포츠/레저',
  '여성잡화',
  '여성의류',
  '남성패션/잡화',
  '게임/취미'
];