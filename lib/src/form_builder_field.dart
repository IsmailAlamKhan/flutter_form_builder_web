import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

enum OptionsOrientation { horizontal, vertical, wrap }
enum ControlAffinity { leading, trailing }

/// A single form field.
///
/// This widget maintains the current state of the form field, so that updates
/// and validation errors are visually reflected in the UI.
class FormBuilderField<T> extends FormField<T> {
  /// Used to reference the field within the form, or to reference form data
  /// after the form is submitted.
  final String name;

  /// Called just before field value is saved. Used to massage data just before
  /// committing the value.
  ///
  /// This sample shows how to convert age in a [FormBuilderTextField] to number
  /// so that the final value is numeric instead of a String
  ///
  /// ```dart
  ///   FormBuilderTextField(
  ///     name: 'age',
  ///     decoration: InputDecoration(labelText: 'Age'),
  ///     valueTransformer: (text) => num.tryParse(text),
  ///     validator: FormBuilderValidators.numeric(context),
  ///     initialValue: '18',
  ///     keyboardType: TextInputType.number,
  ///  ),
  /// ```
  final ValueTransformer<T> valueTransformer;

  /// Called when the field value is changed.
  final ValueChanged<T> onChanged;

  /// The border, labels, icons, and styles used to decorate the field.
  final InputDecoration decoration;

  /// Called when the field value is reset.
  final VoidCallback onReset;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode focusNode;

  //TODO: implement bool autofocus, ValueChanged<bool> onValidated

  /// Creates a single form field.
  const FormBuilderField({
    Key key,
    //From Super
    FormFieldSetter<T> onSaved,
    T initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    bool enabled = true,
    FormFieldValidator<T> validator,
    @required FormFieldBuilder<T> builder,
    @required this.name,
    this.valueTransformer,
    this.onChanged,
    this.decoration = const InputDecoration(),
    this.onReset,
    this.focusNode,
  })  : assert(null != enabled),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: builder,
          validator: validator,
        );

  /*@override
  FormBuilderFieldState<T> createState();*/
  @override
  FormBuilderFieldState<FormBuilderField<T>, T> createState() =>
      FormBuilderFieldState<FormBuilderField<T>, T>();
}

class FormBuilderFieldState<F extends FormBuilderField<T>, T>
    extends FormFieldState<T> {
  @override
  F get widget => super.widget as F;

  FormBuilderState get formState => _formBuilderState;

  /// Returns the initial value, which may be declared at the field, or by the
  /// parent [FormBuilder.initialValue]. When declared at both levels, the field
  /// initialValue prevails.
  T get initialValue =>
      widget.initialValue ??
      (_formBuilderState?.initialValue ??
          const <String, dynamic>{})[widget.name] as T;

  FormBuilderState _formBuilderState;

  @override
  bool get hasError => super.hasError || widget.decoration?.errorText != null;

  @override
  bool get isValid => super.isValid && widget.decoration?.errorText == null;

  bool _touched = false;

  bool get enabled => widget.enabled && (_formBuilderState?.enabled ?? true);

  FocusNode _focusNode;

  FocusNode get effectiveFocusNode => _focusNode;

  @override
  void initState() {
    super.initState();
    // Register this field when there is a parent FormBuilder
    _formBuilderState = FormBuilder.of(context);
    _formBuilderState?.registerField(widget.name, this);
    // Register a touch handler
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_touchedHandler);
    // Set the initial value
    setValue(initialValue);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_touchedHandler);
    // Dispose focus node when created by initState
    if (null == widget.focusNode) {
      _focusNode.dispose();
    }
    _formBuilderState?.unregisterField(widget.name, this);
    super.dispose();
  }

  @override
  void save() {
    super.save();
    if (_formBuilderState != null) {
      if (enabled || !_formBuilderState.widget.skipDisabled) {
        _formBuilderState.setInternalFieldValue(
          widget.name,
          null != widget.valueTransformer
              ? widget.valueTransformer(value)
              : value,
        );
      } else {
        _formBuilderState.removeInternalFieldValue(widget.name);
      }
    }
  }

  void _touchedHandler() {
    if (_focusNode.hasFocus && _touched == false) {
      setState(() => _touched = true);
    }
  }

  @override
  void didChange(T val) {
    super.didChange(val);
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    setValue(initialValue);
    widget.onReset?.call();
  }

  @override
  bool validate() {
    return super.validate() && widget.decoration?.errorText == null;
  }

  void requestFocus() {
    FocusScope.of(context).requestFocus(effectiveFocusNode);
  }

  //  FIXME: This  could be a getter instead of a classic function
  InputDecoration decoration() => widget.decoration.copyWith(
        errorText: widget.decoration.errorText ?? errorText,
      );
}
