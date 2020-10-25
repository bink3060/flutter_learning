void main2() {
  Injector injector = Injector();
  injector.add(() => Person('Filip'));
  injector.add(() => City('New York'));

  Person person = injector.get<Person>();
  City city = injector.get<City>();

  print(person.name);
  print(city.name);
}

class Person {
  String name;

  Person(this.name);
}

class City {
  String name;

  City(this.name);
}

typedef T CreateInstanceFn<T>();

class Injector {
  final _factories = Map<String, dynamic>();

  Injector._internal();
 
  static final Injector _singleton = Injector._internal();

  factory Injector() => _singleton;


  String _generateKey<T>(T type) {
    return '${type.toString()}_instance';
  }

  void add<T>(CreateInstanceFn<T> createInstance) {
    final typeKey = _generateKey(T);

    _factories[typeKey] = createInstance();
  }

  T get<T>() {
    final typeKey = _generateKey(T);
    
    T instance = _factories[typeKey];

    if (instance == null) print('Cannot find instance for type $typeKey');

    return instance;
  }
}
