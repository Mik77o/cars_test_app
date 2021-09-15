import 'dart:async';
import 'package:cars_app/models/car_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cars_app/translations/locale_keys.g.dart';

class CarLocationView extends StatefulWidget {
  final CarModel carModel;
  CarLocationView({Key? key, required this.carModel}) : super(key: key);
  @override
  State<StatefulWidget> createState() => CarLocationViewState();
}

class CarLocationViewState extends State<CarLocationView> {
  late final BitmapDescriptor _pinLocationIcon;
  final Set<Marker> _markers = {};
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    setCarPin();
  }

  void setCarPin() async {
    _pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/car_icon.png');
  }

  @override
  Widget build(BuildContext context) {
    LatLng carPosition = LatLng(widget.carModel.lat, widget.carModel.lng);
    CameraPosition initialLocation =
        CameraPosition(zoom: 8, target: carPosition);

    return GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        markers: _markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _markers.add(Marker(
                markerId: MarkerId('car'),
                position: carPosition,
                icon: _pinLocationIcon,
                infoWindow: InfoWindow(
                    title: '${widget.carModel.brand} ${widget.carModel.model}',
                    snippet:
                        '${LocaleKeys.yearText.tr()}: ${widget.carModel.year?.year} ${LocaleKeys.carRegistrationNumberText.tr()}: ${widget.carModel.registrationNumber}')));
          });
        });
  }
}
