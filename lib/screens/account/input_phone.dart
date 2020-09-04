import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sim_info/sim_info.dart';
import 'package:gatabank/blocs/user/user_bloc.dart';
import 'package:gatabank/blocs/user/user_events.dart';
import 'package:gatabank/blocs/user/user_states.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/data/validators/phone_validator.dart';
import 'package:gatabank/helpers/countries.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/account/countries_screen.dart';
import 'package:gatabank/screens/account/recaptcha_screen.dart';
import 'package:gatabank/screens/account/verification_code.dart';
import 'package:gatabank/widgets/common/app_bar_widget.dart';
import 'package:gatabank/widgets/common/button_widget.dart';
import 'package:gatabank/widgets/common/custom_bottom_sheet.dart' as bs;
import 'package:gatabank/widgets/common/input/input_widget.dart';


class InputPhoneScreen extends StatefulWidget {
  final String phone;
  final String countryCode;

  InputPhoneScreen({this.phone, this.countryCode});

  @override
  _InputPhoneScreenState createState() => _InputPhoneScreenState();
}

class _InputPhoneScreenState extends State<InputPhoneScreen> {
  final RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserBloc _userBloc;
  Country _country;
  String _phone;
  String _token;

  @override
  void initState() {
    _getCountryCode();
    super.initState();
  }

  _getCountryCode() async {
    if (!utils.isEmptyString(widget.countryCode)) {
      _country = countryList.firstWhere((country) => country.getPhoneCode() == widget.countryCode);
      return;
    }

    try {
      String countryCode = await SimInfo.getIsoCountryCode;
      _country = countryList.firstWhere((country) => country.isoCode == countryCode.toUpperCase());
    } catch (e) {
      utils.logError(error: e.toString());
    }
  }

  Widget _buildButton() {
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBloc,
      builder: (context, state) {
        return (state == UserStateLoading())
            ? CircularProgressIndicator(key: Key("ok"))
            : Container(
          child: ButtonWidget(
            key: Key('BtnNext'),
            onPressed: _handleNextClicked,
            title: LocaleKeys.account_submit.tr(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 30),
        );
      },
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              App.theme.getSvgPicture('phone_input'),
              SizedBox(
                height: 50,
              ),
              Text(
                LocaleKeys.account_please_enter_a_correct_mobile_number.tr(),
                textAlign: TextAlign.center,
                style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
              ),
              Container(
                padding: EdgeInsets.only(top: 35, bottom: 10, left: 30, right: 30),
                child: InputWidget(
                  title: LocaleKeys.account_mobile_number.tr(),
                  initialValue: widget.phone ?? '',
                  onSaved: (value) => _phone = value,
                  prefixWidget: _countryCodeField(),
                  validator: _validatePhone,
                  autoFocus: true,
                ),
              ),
              _buildButton(),
              SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _countryCodeField() {
    return InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_country?.getPhoneCode() ?? '+',
                style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1)),
            Icon(
              Icons.keyboard_arrow_down,
              color: App.theme.colors.text1,
            ),
            Container(
              height: 20,
              width: 1,
              color: App.theme.colors.text1,
              margin: EdgeInsets.only(right: 5),
            )
          ],
        ),
        onTap: _showCountryCode);
  }

  _showCountryCode() async {
    await bs.showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CountriesScreen(
            currentCountry: _country,
            onCountrySelected: _handleCountrySelected,
          );
        });
  }

  _handleCountrySelected(Country country) {
    setState(() {
      _country = country;
    });
  }

  _buildRecaptcha() {
    return RecaptchaV2(
      controller: recaptchaV2Controller,
      onTokenReceived: (token) {
        _token = token;
        Navigator.pushNamed(context, ScreenRouter.VERIFICATION_CODE, arguments: {
          ScreenRouter.AGR_RECAPTCHA_TOKEN: _token,
          ScreenRouter.AGR_VERIFICATION_PHONE: _phone,
          ScreenRouter.AGR_VERIFICATION_COUNTRY_CODE: _country.getPhoneCode(),
          ScreenRouter.AGR_VERIFICATION_TYPE: ValidationType.VerificationPhone,
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _userBloc = BlocProvider.of<UserBloc>(context);
    return BlocListener<UserBloc, UserState>(
      bloc: _userBloc,
      listener: (context, state) {
        if (state is UserStateFailed) {
          _handleFailed(state.error);
        } else if (state is UserCheckPhoneResult) {
          if (state.result) {
            _handleFailed("Your phone has been existed already!");
          } else {
            recaptchaV2Controller.show();
          }
        }
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: App.theme.colors.background,
            appBar: AppBarWidget(LocaleKeys.account_mobile_number.tr()),
            body: _buildContent(),
          ),
          _buildRecaptcha(),
        ],
      ),
    );
  }

  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _handleNextClicked() {
    _errorMessage = null;
    if (_validateAndSave()) {
      _userBloc.add(UserCheckPhoneNumber(_country.getPhoneCode(), _phone));
    }
  }

  String _validatePhone(String phone) {
    String error = PhoneValidator.validate(phone);
    if (error != null) return error;
    if (_errorMessage == null) return null;
    return _errorMessage;
  }

  String _errorMessage;

  void _handleFailed(String error) {
    if (error.contains(LocaleKeys.error_invalid_mobile_number.tr())) {
      _errorMessage = LocaleKeys.error_invalid_mobile_number.tr();
      _validateAndSave();
    } else if (error.contains(LocaleKeys.error_phone_is_not_available.tr())) {
      _errorMessage = LocaleKeys.error_phone_is_not_available.tr();
      _validateAndSave();
    } else
      utils.errorToast(error);
  }
}
