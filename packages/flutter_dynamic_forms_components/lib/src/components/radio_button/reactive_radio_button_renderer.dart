import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/src/components/single_select_group/single_select_group.dart';
import '../radio_button_group/radio_button_group.dart';
import 'package:rxdart/rxdart.dart';

import 'radio_button.dart';

class ReactiveRadioButtonRenderer extends FormElementRenderer<RadioButton> {
  @override
  Widget render(
      RadioButton element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    var parent = element.parent as RadioButtonGroup;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LazyStreamBuilder<String>(
        initialData: parent.value,
        streamFactory: () =>
            Observable.merge([parent.valueChanged, element.propertyChanged]),
        builder: (context, _) {
          return RadioListTile(
            title: Text(element.label),
            value: element.value,
            groupValue: parent.value,
            onChanged: (String value) => dispatcher(
                  ChangeValueEvent(
                      value: value,
                      elementId: parent.id,
                      propertyName: SingleSelectGroup.valuePropertyName),
                ),
          );
        },
      ),
    );
  }
}