import 'package:cars_app/models/language_model.dart';
import 'package:cars_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageService {
  final Set<LanguageModel> languageList = {
    LanguageModel(id: 0, countryCode: 'pl'),
    LanguageModel(id: 1, countryCode: 'en')
  };

  buildLanguageChoise(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => NavService.pop(context),
                child: Icon(
                  Icons.close_outlined,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languageList
                  .map((data) => RadioListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(data.id == 0 ? 'PL' : 'ENG'),
                        groupValue: context.locale == Locale('pl') ? 0 : 1,
                        value: data.id,
                        onChanged: (val) async {
                          if (data.id == 0)
                            context.setLocale(Locale('pl'));
                          else
                            context.setLocale(Locale('en'));
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
