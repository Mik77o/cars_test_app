import 'package:cars_app/models/car_model.dart';
import 'package:cars_app/models/car_owner_model.dart';
import 'package:cars_app/pages/add_car_page.dart';
import 'package:cars_app/pages/car_details_page.dart';
import 'package:cars_app/repositories/car_owner_repository.dart';
import 'package:cars_app/repositories/car_repository.dart';
import 'package:cars_app/riverpod/car_owners_notifier.dart';
import 'package:cars_app/services/language_service.dart';
import 'package:cars_app/services/navigation_service.dart';
import 'package:cars_app/translations/locale_keys.g.dart';
import 'package:cars_app/widgets/tap_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity/connectivity.dart';

class CarsListPage extends StatefulWidget {
  CarsListPage({Key? key}) : super(key: key);

  @override
  _CarsListPageState createState() => _CarsListPageState();
}

class _CarsListPageState extends State<CarsListPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'child',
        elevation: 4.0,
        onPressed: () async {
          if (await (Connectivity()
              .checkConnectivity()
              .then((value) => value != ConnectivityResult.none))) {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCarPage()))
                .then((value) {
              setState(() {});
            });
          } else
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(child: Text("CarsApp")),
                  content: Text("Problem z połączeniem sieciowym"),
                );
              },
            );
        },
        label: Text(LocaleKeys.addText.tr(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(LocaleKeys.carListText.tr()),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TapIcon(
                color: Colors.white,
                iconData: Icons.settings,
                onTap: () async => await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LanguageService().buildLanguageChoise(context);
                      },
                    )),
          ),
        ],
      ),
      body: FutureBuilder(
          future: Future.wait([
            CarRepository.getCarsList(),
            CarOwnerRepository.getCarOwnersList()
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData) {
              print('project snapshot data is: ${snapshot.data}');
              return Container();
            } else if (snapshot.hasData) {
              var dataList = snapshot.data as List<Object?>;
              var result = dataList.first as List<CarModel>?;
              var ownersList = dataList[1] as List<CarOwnerModel>?;
              _updateCarOwnersList(ownersList);
              if (result != null) {
                return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: refresh,
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropMaterialHeader(
                      backgroundColor: Theme.of(context).accentColor),
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 2,
                      );
                    },
                    primary: true,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return _buildCarTile(result[index]);
                    },
                  ),
                );
              } else if (result == null) {
                return Container(
                  child: Center(
                    child: Text(LocaleKeys.noDataText.tr()),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(child: Text("CarsApp")),
                    content: Text(snapshot.error.toString()),
                  );
                },
              );
            }
            return Center(
              child: SpinKitSquareCircle(
                color: Theme.of(context).accentColor,
              ),
            );
          }),
    );
  }

  Widget _buildCarTile(CarModel model) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, left: 8.0, right: 8, bottom: 4.0),
      child: Material(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(4),
        elevation: 2.0,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onTap: () => NavService.push(context, CarDetailsPage(model: model)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.brand! + ' ' + model.model!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                    '${LocaleKeys.carRegistrationNumberText.tr()}: ' +
                        model.registrationNumber!,
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      LocaleKeys.carColorText.tr(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.drive_eta,
                      color: model.color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateCarOwnersList(List<CarOwnerModel>? ownersList) {
    if (ownersList == null) return;

    var owners = context.read(carOwnersProvider).owners;
    for (var owner in ownersList) {
      if (owners.any((element) => element.id == owner.id) == false) {
        owners.add(owner);
      }
    }
  }
}
