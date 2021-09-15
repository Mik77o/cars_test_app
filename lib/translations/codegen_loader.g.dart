// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en = {
    "carListText": "Cars list",
    "carRegistrationNumberText": "Car registration number",
    "carColorText": "Car color",
    "addText": "Add",
    "ownerText": "Owner",
    "birthDateText": "Birth date",
    "yearText": "Year",
    "carDetailsText": "Car details",
    "addCarText": "Add car",
    "modelText": "Model",
    "brandText": "Brand",
    "noText": "no",
    "chooseOwnerText": "Choose an owner",
    "yeaOfProductionText": "production year",
    "locationServicesDisabledText": "Location services are disabled.",
    "locationPermissionsDeniedText": "Location permissions are denied.",
    "locationPermissionsPermanentlyDeniedText":
        "Location permissions are permanently denied, we cannot request permissions.",
    "chooseYearText": "Choose year",
    "problemToSetLocationText":
        "There was a problem setting your location. You must accept the permissions",
    "otherErrorText": "other error",
    "carAddedForText": "A car has been added for",
    " somethingWentWrongText": "Something went wrong",
    "enterColorAndYearOfBrandTheCarText":
        "Enter the color and year of manufacture of the car",
    "carBrandText": "Car brand",
    "carModelText": "Car model",
    "locationDisplayProblemText": "Location display problem",
    "noInformationAboutTheOwnerText": "No information about the owner",
    "noDataText": "No data",
    "noOwnersText": "No owners available"
  };
  static const Map<String, dynamic> pl = {
    "carListText": "Lista samochodów",
    "carRegistrationNumberText": "Numer rejestracyjny",
    "carColorText": "Kolor samochodu",
    "addText": "Dodaj",
    "ownerText": "Właściciel",
    "birthDateText": "Data urodzenia",
    "yearText": "Rok",
    "carDetailsText": "Szczegóły samochodu",
    "addCarText": "Dodaj samochód",
    "modelText": "Model",
    "brandText": "Marka",
    "noText": "brak",
    "chooseOwnerText": "Wybierz właściciela",
    "yeaOfProductionText": "rok produkcji",
    "locationServicesDisabledText": "Usługa lokalizacji jest niedostępna.",
    "locationPermissionsDeniedText": "Nie zezwolono na dostęp do lokalizacji.",
    "locationPermissionsPermanentlyDeniedText":
        "Uprawnienia dostępu do lokalizacji są niedostępne na stałe.",
    "chooseYearText": "Wybierz rok",
    "problemToSetLocationText":
        "Wystąpił problem z ustawieniem Twojej lokalizacji. Należy zaakceptować uprawnienia",
    "otherErrorText": "inny błąd",
    "carAddedForText": "Dodano samochód dla",
    " somethingWentWrongText": "Coś poszło nie tak",
    "enterColorAndYearOfBrandTheCarText":
        "Podaj kolor i rok produkcji samochodu",
    "carBrandText": "Marka samochodu",
    "carModelText": "Model samochodu",
    "locationDisplayProblemText": "Problem z wyświetleniem lokalizacji",
    "noInformationAboutTheOwnerText": "Brak informacji o właścicielu",
    "noDataText": "Brak danych",
    "noOwnersText": "Brak dostępnych właścicieli"
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "pl": pl
  };
}
