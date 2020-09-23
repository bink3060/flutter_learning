import 'package:buzzkill/drink.dart';
import 'package:buzzkill/generated/l10n.dart';
import 'package:buzzkill/pages/results_page.dart';
import 'package:buzzkill/ui_components/digits_text_field.dart';
import 'package:buzzkill/ui_components/drink_form_radio_list_tile.dart';
import 'package:flutter/material.dart';

/// Form for inputting the information needed to calculate the lethal and safe
/// dosages of caffeinated drinks.
class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _weightTextController = TextEditingController();
  final _servingSizeTextController = TextEditingController();
  final _caffeineTextController = TextEditingController();

  /// The currently selected [Drink] option from the radio list.
  Drink _selectedDrinkSuggestion;

  /// Tells if the form is in a valid state. Useful for enabling/disabling the
  /// action button.
  bool get _isValidInput =>
      _weightTextController.intValue > 0 &&
      (_selectedDrinkSuggestion != null ||
          (_servingSizeTextController.intValue > 0 &&
              _caffeineTextController.intValue > 0));

  List<Drink> _drinkSuggestions;

  Locale _userLocale;

  @override
  void didChangeDependencies() {
    final newLocale = Localizations.localeOf(context);

    if (newLocale != _userLocale) {
      _userLocale = newLocale;
      // 4
      _weightTextController.clear();
      _servingSizeTextController.clear();
      _caffeineTextController.clear();
      _selectedDrinkSuggestion = null;
      _drinkSuggestions = [
        Drink(
          name: S.of(context).firstSuggestedDrinkName,
          caffeineAmount: 145,
          servingSize: 8,
        ),
        Drink(
          name: S.of(context).secondSuggestedDrinkName,
          caffeineAmount: 77,
          servingSize: 1.5,
        ),
        Drink(
          name: S.of(context).thirdSuggestedDrinkName,
          caffeineAmount: 154,
          servingSize: 16,
        ),
      ];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).formPageAppBarTitle,
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          // Dismisses the keyboard when a tap occurs outside of the form.
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                Image.asset('assets/danger.png'),
                _ListItemPadding(
                  child: DigitsTextField(
                    controller: _weightTextController,
                    labelText: S.of(context).formPageWeightInputLabel,
                    suffixText: S.of(context).formPageWeightInputSuffix,
                    onChanged: (_) {
                      // The setState call enables/disables the action button if
                      // the serving size or caffeine amount input changes.
                      setState(() {});
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    S.of(context).formPageRadioListLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ..._drinkSuggestions
                    .map(
                      (suggestion) => RadioListTile<Drink>(
                        dense: true,
                        groupValue: _selectedDrinkSuggestion,
                        value: suggestion,
                        onChanged: _changeSelectedSuggestion,
                        title: Text(suggestion.name),
                      ),
                    )
                    .toList(),
                // Adds the custom drink radio.
                DrinkFormRadioListTile(
                  caffeineInputController: _caffeineTextController,
                  servingSizeInputController: _servingSizeTextController,
                  selectedSuggestion: _selectedDrinkSuggestion,
                  // If the custom drink radio is selected, we set the
                  // _selectedDrinkSuggestion to null, as it isn't one of
                  // the suggestions.
                  onSelected: () => _changeSelectedSuggestion(null),
                  // Important for enabling/disabling the action button if the
                  // serving size or caffeine amount input changes.
                  onInputChanged: () => setState(() {}),
                  titleText: S.of(context).formPageCustomDrinkRadioTitle,
                  servingSizeLabelText:
                      S.of(context).formPageCustomDrinkServingSizeInputLabel,
                  servingSizeSuffixText:
                      S.of(context).formPageCustomDrinkServingSizeInputSuffix,
                  caffeineAmountLabelText:
                      S.of(context).formPageCustomDrinkCaffeineAmountInputLabel,
                  caffeineAmountSuffixText: S
                      .of(context)
                      .formPageCustomDrinkCaffeineAmountInputSuffix,
                ),
                _ListItemPadding(
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: _isValidInput
                          ? () => _pushResultsPage(context)
                          : null,
                      child: Text(
                        S.of(context).formPageActionButtonTitle,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _pushResultsPage(BuildContext context) {
    final weight = _weightTextController.intValue;

    // If there's no selected suggestion, we create a new [Drink] with
    // the inputted data.
    final drink = _selectedDrinkSuggestion ??
        Drink(
          caffeineAmount: _caffeineTextController.intValue,
          servingSize: _servingSizeTextController.intValue.toDouble(),
        );

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ResultsPage(
          bodyWeight: weight,
          drink: drink,
        ),
      ),
    );
  }

  void _changeSelectedSuggestion(Drink drink) {
    setState(() {
      _selectedDrinkSuggestion = drink;
    });
  }

  @override
  void dispose() {
    _weightTextController.dispose();
    _servingSizeTextController.dispose();
    _caffeineTextController.dispose();
    super.dispose();
  }
}

class _ListItemPadding extends StatelessWidget {
  const _ListItemPadding({
    @required this.child,
    Key key,
  })  : assert(child != null),
        super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        child: child,
      );
}

/// Parses the content of a TextEditingController as an int.
extension _NumberInput on TextEditingController {
  int get intValue {
    try {
      return int.parse(text);
    } catch (_) {
      return 0;
    }
  }
}
