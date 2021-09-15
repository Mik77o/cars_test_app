import 'package:cars_app/helpers/text_form_field_helper.dart';
import 'package:cars_app/models/car_owner_model.dart';
import 'package:cars_app/riverpod/car_owners_notifier.dart';
import 'package:cars_app/services/cars_app_api_service.dart';
import 'package:cars_app/services/language_service.dart';
import 'package:cars_app/services/navigation_service.dart';
import 'package:cars_app/services/toast_service.dart';
import 'package:cars_app/widgets/tap_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cars_app/extensions/color_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cars_app/translations/locale_keys.g.dart';

class AddCarPage extends StatefulWidget {
  AddCarPage({Key? key}) : super(key: key);

  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _carRegistrationNumberController = TextEditingController();

  Color? _carColor;
  DateTime? _selectedDate;
  CarOwnerModel _ownerValue = CarOwnerModel();

  final _markers = Set<Marker>();
  MarkerId _markerId = MarkerId("car");
  LatLng? _latLng;
  double? _lat;
  double? _lng;
  bool _isFirstPosition = true;

  final _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _ownerValue = context.read(carOwnersProvider).owners.first;
  }

  Future<Position> _determineLocation() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(LocaleKeys.locationServicesDisabledText.tr());
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error(LocaleKeys.locationPermissionsDeniedText.tr());
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error(LocaleKeys.locationPermissionsPermanentlyDeniedText.tr());
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
        title: Text(LocaleKeys.addCarText.tr()),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TapIcon(
                color: Colors.white,
                iconData: Icons.settings,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LanguageService().buildLanguageChoise(context);
                    },
                  );
                }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              _carInfoBasicForm(),
              _buildColorChoise(context),
              SizedBox(height: 8),
              _buildProductionYearChoice(context),
              SizedBox(height: 8),
              FutureBuilder(
                  future: _determineLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none && snapshot.hasData) {
                      print('project snapshot data is: ${snapshot.data}');
                      return Container();
                    } else if (snapshot.hasData) {
                      var position = snapshot.data as Position?;
                      if (position != null && _isFirstPosition) {
                        _markers.add(
                          Marker(
                            markerId: _markerId,
                            position: LatLng(position.latitude, position.longitude),
                          ),
                        );
                        _latLng = LatLng(position.latitude, position.longitude);
                        _lat = position.latitude;
                        _lng = position.longitude;
                        _isFirstPosition = false;
                      } else if (position == null) {
                        _markers.add(
                          Marker(
                            markerId: _markerId,
                            position: LatLng(0.0, 0.0),
                          ),
                        );
                        _latLng = LatLng(0.0, 0.0);
                        _lat = 0;
                        _lng = 0;
                        _isFirstPosition = false;
                      }

                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Material(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('$_lat   $_lng',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(width: 2, color: Theme.of(context).accentColor),
                            ),
                            height: 200,
                            child: GoogleMap(
                              myLocationEnabled: true,
                              initialCameraPosition: CameraPosition(target: _latLng!, zoom: 8),
                              markers: _markers,
                              onCameraMove: (position) {
                                setState(() {
                                  _markers.add(Marker(markerId: _markerId, position: position.target));
                                  _lat = position.target.latitude;

                                  _lng = position.target.longitude;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        child: Text(
                            '${LocaleKeys.problemToSetLocationText.tr()}: ${snapshot.error ?? '${LocaleKeys.otherErrorText.tr()}'}'),
                      );
                    }

                    return Container(
                      height: 200,
                      child: Center(
                        child: SpinKitSquareCircle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    );
                  }),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    child: Text(LocaleKeys.addCarText.tr().toUpperCase()),
                    onPressed: () async {
                      if (_globalKey.currentState?.validate() == true &&
                          _latLng != null &&
                          _lng != null &&
                          _ownerValue.id != null &&
                          _ownerValue.id!.isNotEmpty) {
                        if (_carColor != null && _selectedDate != null) {
                          //api method
                        } else {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(child: Text("CarsApp")),
                                content: Text(LocaleKeys.enterColorAndYearOfBrandTheCarText.tr()),
                              );
                            },
                          );
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildProductionYearChoice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(LocaleKeys.chooseYearText.tr()),
                    content: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: YearPicker(
                        firstDate: DateTime(DateTime.now().year - 100, 1, 1),
                        lastDate: DateTime(DateTime.now().year, 1, 1),
                        initialDate: DateTime.now(),
                        selectedDate: _selectedDate ?? DateTime.now(),
                        onChanged: (DateTime dateTime) {
                          setState(() {
                            _selectedDate = dateTime;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.hourglass_empty_rounded),
            label: Text(LocaleKeys.yeaOfProductionText.tr().toUpperCase()),
            style: ElevatedButton.styleFrom(primary: Theme.of(context).buttonColor),
          ),
        ),
        SizedBox(width: 32),
        _selectedDate != null
            ? Container(
                height: 32,
                width: 64,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(width: 2, color: Theme.of(context).accentColor),
                ),
                child: Center(child: Text(_selectedDate!.year.toString())),
              )
            : Container(
                child: Text(LocaleKeys.noText.tr()),
              ),
      ],
    );
  }

  Row _buildColorChoise(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            ColorPicker(
                              pickerColor: _carColor ?? Colors.black,
                              onColorChanged: changeColor,
                              colorPickerWidth: 300.0,
                              pickerAreaHeightPercent: 0.7,
                              enableAlpha: true,
                              displayThumbColor: true,
                              showLabel: true,
                              paletteType: PaletteType.hsv,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(primary: Theme.of(context).buttonColor),
                                    onPressed: () {
                                      NavService.pop(context);
                                    },
                                    child: Text("OK")),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.palette_outlined),
            label: Text(LocaleKeys.carColorText.tr().toUpperCase()),
            style: ElevatedButton.styleFrom(primary: Theme.of(context).buttonColor),
          ),
        ),
        SizedBox(width: 32),
        _carColor != null
            ? Container(
                width: 64,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(width: 2, color: Theme.of(context).accentColor),
                ),
                child: Icon(
                  Icons.drive_eta,
                  color: _carColor,
                ),
              )
            : Container(child: Text(LocaleKeys.noText.tr())),
      ],
    );
  }

  Form _carInfoBasicForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildBrandEntry()),
              SizedBox(width: 16),
              Expanded(child: _buildModelEntry()),
            ],
          ),
          SizedBox(height: 16),
          _carRegistrationNumberEntry(),
          SizedBox(height: 16),
          _buildOwnersDropDownButton(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void changeColor(Color color) => setState(() => _carColor = color);
  Widget _buildBrandEntry() {
    return TextFormField(
      controller: _brandController,
      style: TextStyle(color: Colors.black54, fontSize: 16),
      cursorColor: Theme.of(context).accentColor,
      keyboardType: TextInputType.text,
      decoration: TextInputFormatter.getInputDecoration(context, labelText: LocaleKeys.brandText.tr()),
      validator: (brand) {
        return brand?.isEmpty == true ? LocaleKeys.carBrandText.tr() : null;
      },
    );
  }

  Widget _buildModelEntry() {
    return TextFormField(
      controller: _modelController,
      style: TextStyle(color: Colors.black54, fontSize: 16),
      cursorColor: Theme.of(context).accentColor,
      keyboardType: TextInputType.text,
      decoration: TextInputFormatter.getInputDecoration(context, labelText: LocaleKeys.modelText.tr()),
      validator: (model) {
        return model?.isEmpty == true ? LocaleKeys.carModelText.tr() : null;
      },
    );
  }

  Widget _carRegistrationNumberEntry() {
    return TextFormField(
      controller: _carRegistrationNumberController,
      style: TextStyle(color: Colors.black54, fontSize: 16),
      cursorColor: Theme.of(context).accentColor,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      decoration: TextInputFormatter.getInputDecoration(context, labelText: LocaleKeys.carRegistrationNumberText.tr()),
      validator: (reg) {
        return reg?.isEmpty == true ? LocaleKeys.carRegistrationNumberText.tr() : null;
      },
    );
  }

  Widget _buildOwnersDropDownButton() {
    var owners = context.read(carOwnersProvider).owners;
    if (owners.length > 0) {
      return DropdownButtonFormField<CarOwnerModel>(
        value: _ownerValue,
        icon: const Icon(Icons.person),
        iconSize: 24,
        elevation: 16,
        decoration: TextInputFormatter.getInputDecoration(context, labelText: LocaleKeys.chooseOwnerText.tr()),
        style: TextStyle(color: Colors.black54, fontSize: 16),
        onChanged: (CarOwnerModel? newValue) {
          setState(() {
            _ownerValue = newValue!;
          });
        },
        items: owners.map<DropdownMenuItem<CarOwnerModel>>((CarOwnerModel value) {
          return DropdownMenuItem<CarOwnerModel>(value: value, child: Text('${value.firstName} ${value.lastName}'));
        }).toList(),
      );
    } else
      return Text(LocaleKeys.noOwnersText.tr());
  }
}
