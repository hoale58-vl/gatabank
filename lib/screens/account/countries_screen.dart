import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/helpers/countries.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/helpers/theme/themes.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class CountriesScreen extends StatefulWidget {
  final Country currentCountry;
  final Function(Country) onCountrySelected;

  CountriesScreen({Key key, this.currentCountry, this.onCountrySelected}) : super(key: key);

  @override
  _CountriesScreenState createState() => new _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];

  @override
  void initState() {
    _filteredCountries.addAll(countryList);
    if (widget.currentCountry != null) {
      _filteredCountries.remove(widget.currentCountry);
      _filteredCountries.insert(0, widget.currentCountry);
    }
    _allCountries.addAll(_filteredCountries);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = App.theme.colors.text1;
    Color primaryColor = App.theme.colors.primary;
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 5),
      child: Column(children: <Widget>[
        TextField(
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: App.theme.colors.divider),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              hintText: LocaleKeys.account_search_country_code.tr(),
              hintStyle: App.theme.styles.body1.copyWith(color: App.theme.colors.text5),
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.search, color: textColor),
              ),
              suffix: _cancelButton()),
          onChanged: _onSearchInput,
          style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
        ),
        Expanded(
          child: _buildList(),
        )
      ]),
    );
  }

  _cancelButton() => InkWell(
      child: Text(
        LocaleKeys.account_cancel.tr(),
        style: App.theme.styles.body1.copyWith(color: App.theme.colors.primary),
      ),
      onTap: () => Navigator.pop(context));

  _buildList() {
    return SafeArea(
      child: ListView.builder(
          itemCount: _filteredCountries.length,
          itemBuilder: (context, index) {
            Country country = _filteredCountries[index];
            bool isSelected = widget.currentCountry == country;
            return Container(
                child: ListTile(
                  title: Text(country.toString(),
                      style: isSelected
                          ? App.theme.styles.body5.copyWith(color: App.theme.colors.primary)
                          : App.theme.styles.body5
                          .copyWith(color: App.theme.colors.text1, fontWeight: SemiBold)),
                  onTap: () => _handleClick(country),
                ),
                color:
                isSelected ? App.theme.colors.primary.withOpacity(0.11) : Colors.transparent);
          }),
    );
  }

  _handleClick(Country country) {
    widget.onCountrySelected(country);
    Navigator.pop(context);
  }

  _onSearchInput(String text) {
    if (utils.isEmptyString(text)) return;
    setState(() {
      _filteredCountries = _allCountries
          .where((Country country) =>
      country.name.toLowerCase().startsWith(text.toLowerCase()) ||
          country.phoneCode.startsWith(text) ||
          country.isoCode.toLowerCase().startsWith(text.toLowerCase()))
          .toList();
    });
  }
}
