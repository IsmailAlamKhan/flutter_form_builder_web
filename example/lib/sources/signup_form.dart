import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'full_name',
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.email(context),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'password',
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.minLength(context, 6),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'confirm_password',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: (_formKey.currentState != null &&
                            !_formKey.currentState.fields['confirm_password']
                                .isValid)
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    /*FormBuilderValidators.equal(
                        context,
                        _formKey.currentState != null
                            ? _formKey.currentState.fields['password'].value
                            : null),*/
                    (val) {
                      if (val !=
                          _formKey.currentState.fields['password'].value) {
                        return 'Passwords do not match';
                      }
                      return null;
                    }
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderField<bool>(
                  name: 'test',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.equal(context, true),
                  ]),
                  // initialValue: true,
                  decoration: InputDecoration(labelText: 'Accept Terms?'),
                  builder: (FormFieldState<bool> field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        errorText: field.errorText,
                      ),
                      child: SwitchListTile(
                        title: Text(
                            'I have read and accept the terms of service.'),
                        onChanged: (bool value) {
                          field.didChange(value);
                        },
                        value: field.value ?? false,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'Signup',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.saveAndValidate()) {
                      print('Valid');
                    } else {
                      print('Invalid');
                    }
                    print(_formKey.currentState.value);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
