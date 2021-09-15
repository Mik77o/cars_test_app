import 'package:cars_app/models/car_model.dart';
import 'package:cars_app/riverpod/car_owners_notifier.dart';
import 'package:cars_app/services/language_service.dart';
import 'package:cars_app/translations/locale_keys.g.dart';
import 'package:cars_app/widgets/google_map_widget.dart';
import 'package:cars_app/widgets/tap_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class CarDetailsPage extends StatefulWidget {
  CarDetailsPage({Key? key, required this.model}) : super(key: key);

  final CarModel model;
  @override
  _CarDetailsPageState createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
        title: Text(LocaleKeys.carDetailsText.tr()),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(2),
                elevation: 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildOwner(context, widget.model.ownerId)),
                    SizedBox(
                      width: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.drive_eta,
                            color: widget.model.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.model.lat != null && widget.model.lat != null
                ? Expanded(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                              width: 2, color: Theme.of(context).accentColor),
                        ),
                        child: CarLocationView(carModel: widget.model)),
                  ))
                : Material(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(LocaleKeys.locationDisplayProblemText.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _buildOwner(BuildContext context, String? ownerId) {
    if (ownerId == null)
      return Text(
        LocaleKeys.noInformationAboutTheOwnerText.tr(),
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      );
    else {
      var onwersList = context.read(carOwnersProvider).owners;
      for (var o in onwersList) {
        if (o.id == ownerId) {
          return Column(
            children: [
              Text(
                '${LocaleKeys.ownerText.tr()}: ${o.firstName} ${o.lastName}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                '${LocaleKeys.birthDateText.tr()}: ${DateFormat('dd-MM-yyyy').format(o.birthDate!)}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          );
        }
      }
      return Text(
        LocaleKeys.noInformationAboutTheOwnerText.tr(),
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      );
    }
  }
}
