import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:dynamic_forms/src/parser/parser_node.dart';
import 'package:meta/meta.dart';

class JsonParserNode extends ParserNode {
  final Map<String, dynamic> element;
  JsonParserNode(this.element);

  @override
  String getName() {
    return element["@name"];
  }

  @override
  Property<T> getValue<T>(String name, T converter(String s), T defaultValue(),
      {bool isImmutable = true}) {
    var elementValue = element[name];
    if (elementValue == null) {
      return createProperty<T>(defaultValue(), isImmutable);
    }
    if (elementValue is String) {
      return createProperty<T>(converter(elementValue), isImmutable);
    }
    if (elementValue is Map<String, dynamic>) {
      var expression = elementValue["expression"];
      if (expression != null) {
        return StringExpressionProperty<T>(expression);
      }
    }
    return createProperty<T>(defaultValue(), isImmutable);
  }

  @override
  String getPlainStringValue(String propertyName) {
    return element[propertyName] ?? null;
  }

  @override
  Property<List<TFormElement>> getChildren<TFormElement>(
      {FormElement parent,
      String childrenPropertyName,
      ElementParserFunction parser,
      bool isContentProperty = false,
      bool isImmutable = true}) {
    var childrenList = element[childrenPropertyName] as List;
    var children = childrenList == null
        ? List<TFormElement>()
        : childrenList
            .map((c) => parser(JsonParserNode(c), parent))
            .cast<TFormElement>()
            .toList();
    var childrenProperty = createProperty(children, isImmutable);
    return childrenProperty;
  }

  @override
  Property<TFormElement> getChild<TFormElement>({
    @required String propertyName,
    @required ElementParserFunction parser,
    @required FormElement parent,
    @required TFormElement defaultValue(),
    bool isContentProperty = false,
    bool isImmutable = true,
  }) {
    var childElement = element[propertyName] as Map<String, dynamic>;

    if (childElement != null) {
      return createProperty<TFormElement>(
          parser(JsonParserNode(childElement), parent) as TFormElement,
          isImmutable);
    }
    return createProperty<TFormElement>(defaultValue(), isImmutable);
  }
}
